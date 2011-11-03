module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class SplittedExplorer
    
    attr_reader :core_instances
    
    # Init
    #  
    # ==== Attributes  
    # 
    # * +patterns+ - An array including patterns
    # * +core_concept+ - A string or a resource determining the core concept 
    # * +constraint+ - A string determining the constraint of the query
    # * +&action+ - A block used, for example, to store infos.
    #
    # ==== Examples
    #
    # # InstanceExplorer.new(p,cc ,c) do |instace, p_count, level, property, instance_id|
    # # [...]
    # # end
    # * instance - Instance from the sparql query
    # * p_count - Pattern counter
    # * level - Level number
    # * property - A string determining the uri of property
    # * instance_id - The id of the instance  
    def initialize(patterns, core_concept, constraint, &action)
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
    end
    
    
    # Scans patterns and executes also the block &action passed during the class initialization
    def scan_patterns
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
          end if ! curr_instances.nil? 
          curr_instances = next_instances
        end
        p_count = p_count.next
      end
    end 
  end
  
end