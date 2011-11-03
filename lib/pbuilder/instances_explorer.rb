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
    # * +core_concept_node+ - A node (TreeNode) determining the core concept 
    # * +constraint+ - A string determining the constraint of the query
    # * +&action+ - A block used, for example, to store infos.
    #
    # ==== Examples
    #
    # # InstanceExplorer.new(cc ,con) do |instace, p_count, level, property, instance_id|
    # # [...]
    # # end
    #
    # * instance - Instance from the sparql query
    # * p_count - Pattern counter
    # * level - Level number
    # * property - A string determining the uri of property
    # * instance_id - The id of the instance
    def initialize(core_concept_node, constraint, &action)
      @action = action
      @core_instances = []
      @root = core_concept_node
      core_concept_rsc = RDFS::Resource.new(core_concept_node.value)
      @query = Query
      q = @query.new.extend(Pbuilder::Query)
      q = q.search_by_concept(core_concept_rsc, constraint)
      @pass = false
      q.execute do |i|
        @core_instances << @action.call(i, 0, 0, nil, nil)
        @pass = true
      end
    end
    
    # Scans patterns and executes also the block &action passed during the class initialization
    # It returns the max level reached in the scanning
    #
    # ==== Examples
    #
    # # ie.scan_patterns do |p_count|
    # #   puts p_count
    # # end
    #
    # * p_count - Pattern counter
    def scan_patterns
      @max_level = 0
      @root.bfs do |r|
        reached = false
        curr_instances = yield(r.parent_id)
        curr_instances.each do |c_instance|
          q = @query.new.extend(Pbuilder::Query)
          q = q.search_next_instances(c_instance.uri, r.node.edge, r.node.value)
          q.execute do |i|
            @action.call(i, r.id, r.level, r.node.edge, c_instance.id)
            reached = true
          end
        end if ! curr_instances.nil?
        @max_level = r.level if r.level > @max_level
        reached
      end if @pass
      @max_level
    end
    
  end
  
end