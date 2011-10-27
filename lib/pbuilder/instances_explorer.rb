module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class InstancesExplorer
    
    attr_reader :core_instances
    
    # Init
    #  
    # ==== Attributes  

    #
    # ==== Examples
    # 
    def initialize(core_concept_node, constraint, &action)  
      
      #########################
=begin
      @action = action
      core_concept_rsc = RDFS::Resource.new(core_concept) 
      @patterns = patterns 
      @query = Query
      q = @query.new.extend(Pbuilder::Query)
      q = q.search_by_concept(core_concept_rsc, constraint)
      @core_instances = []
      c_instances = []
      q.execute do |i|
        c_instances << i
      end
      for j in 0...patterns.size
        list = Array.new
        c_instances.each do |c|
          list << @action.call(c, j, 0, nil, nil)
        end
        @core_instances << list
      end
=end
      #######################
      
      @action = action
      @core_instances = []
      @root = core_concept_node
      core_concept_rsc = RDFS::Resource.new(core_concept_node.value)
      @query = Query
      q = @query.new.extend(Pbuilder::Query) 
      q = q.search_by_concept(core_concept_rsc, constraint)
      q.execute do |i|
        ########## qui bisogna salvare l'appartenenza del nodo pattern
        @core_instances << @action.call(i, 0, 0, nil, nil)
      end
      
      # Attenzione il root ha una differente query rispetto agli altri! Ha anche il constraint!
      # Creare una lista 
   
    end
    
    
    # Scans patterns and executes also the block &action passed during the class initialization
    def scan_patterns
      
      ########################
=begin
      p_count = 0
      @patterns.each do |pattern|
        level = 0
        curr_instances = []
        curr_instances = @core_instances[p_count]
        pr = PatternReader.new(pattern[1..-1])
        until pr.halted?
          prop, concept = pr.default_next_concept_and_prop
          level = level.next
          next_instances = []
          curr_instances.each do |c_instance|
            q = @query.new.extend(Pbuilder::Query)
            q = q.search_next_instances(c_instance.uri, prop, concept)
            q.execute do |i|
              next_instances << @action.call(i, p_count, level, prop, c_instance.id)
            end
          end
          curr_instances = next_instances
        end
        p_count = p_count.next
      end
=end
      ########################
      
      
      # utilizzare bfs da root! Non considera root ma solo i successivi
      
      # PROBLEMA come faccio a recuperare u curr_instances giusti? Il vecchio metodo non va bene
      # utiliziamo una altra &action per find (trova instance di un determinato concetto/stepalgoritmo)?
      # si potrebbe usare "pattern" (o creare un nuovo attributo) per conoscere il concetto  l'id del concetto di appartenenza
      
      # ATTENZIONE: sarebbe meglio che bfs escludesse i nodi che hanno un progenitore privo istanze. NB: anche @root
      @root.bfs do |r_node| # ?????? TOGLIERE r_ e METTERE SOLO node
        curr_instances = yield(r_node.parent_id)
        curr_instances.each do |c_instance|
          q = @query.new.extend(Pbuilder::Query)
          # ATTENZIONE usando ReachabilityIndo va usato r_node.edge e r_node.value
          q = q.search_next_instances(c_instance.uri, r_node.property, r_node.concept)
          q.execute do |i|
            # ATTENZIONE usando ReachabilityIndo va usato r_node.r_info.level r_node.r_info.id
            @action.call(i, r_node.id, r_node.level, r_node.property, c_instance.id)
          end
        end if ! curr_instances.nil?
      end
      
    end
    
  end
  
end