module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class SearchEngine
  
    #  <b>A forget</b> property: URI string
    A_FORGET_STR = "http://www.siti.disco.unimib.it/cmm/2010/aeria#a-forget"
    #  <b>A forget</b> property: ActiveRDF resource
    A_FORGET_RESOURCE = RDFS::Resource.new(A_FORGET_STR)
    #  <b>A generalize</b> property: URI string
    A_GENERALIZE_STR = "http://www.siti.disco.unimib.it/cmm/2010/aeria#a-generalize"
    #  <b>A generalize</b> property: ActiveRDF resource
    A_GENERALIZE_RESOURCE = RDFS::Resource.new(A_GENERALIZE_STR)
  
    # Properties classification
    PROPERTY_TYPES={
      :simple => "s",   # Ex: A --q--> B ; q is simple, focusing A
      :inverse => "i",  # Ex: B --p--> A ; p is inverse, focusing A
      :reflexive => "r" # Ex: A --t--> A ; t is reflexive
    }.freeze
    # Edge finders available
    EDGE_FINDERS={
      :simple => "find_simple_edge",      # See: +find_simple_edge+,
      :inverse => "find_inverse_edge",    # See: +find_inverse_edge+
      :reflexive => "find_reflexive_edge" # See: +find_reflexive_edge+
    }.freeze
    # This finders list detect simple, rinverse and reflexive edges
    DEFAULT_FINDERS = [ EDGE_FINDERS[:simple], 
                        EDGE_FINDERS[:inverse], 
                        EDGE_FINDERS[:reflexive] ]                    

    # Core and abstract concepts detection
    def self.find_root_concepts
      query = Query.new.distinct(:s,:o).where(:s, A_GENERALIZE_RESOURCE, :o)
      query.execute do |abstract_concept, core_concept|
         return abstract_concept, core_concept
      end
    end
  
    # Find neighbours of a concept  
    #  
    # ==== Attributes  
    #  
    # * +concept+ - A concept to focus on
    # * +analysis+ - A patterns analysis. See +PatternsAnalysis+
    # * +patterns+ - A patterns storage. See +PatternsStorage+
    # * +finders_list+ - A list determining finders to use into the algorithm. See +DEFAULT_FINDERS+ and +EDGE_FINDERS+
    #
    # ==== Example
    #
    # B --p--> A
    # p is inverse, focusing A
    # Into the pattern: A --p_i--> B
    def self.find_neighbours(concept, 
                        analysis,
                        patterns, 
                        finders_list = DEFAULT_FINDERS )
      patterns.empty_cache
      # Token bound: property count < 1
      condition = Proc.new do |curr_property|
        ! analysis.properties_list.has_key?(curr_property)
      end
      # System update analysis and patterns storage
      update_system = Proc.new do | curr_concept, 
                                    curr_property, 
                                    curr_property_type, 
                                    curr_count |
        analysis.update(curr_concept, 
                        curr_property,
                        curr_property_type)
        patterns.update(concept, 
                        curr_property,
                        curr_concept)
      end
      # Reflection: it perform the finders into to the +finders_list+
      finders_list.each do |finder|
        count = eval "#{finder}(concept, condition, update_system)"  
      end
    end
  
    # Reflexive edge detection. Reflexive edge: statement with a property denoted with "R"
    # See +EDGE_FINDERS[:reflexive]+
    #
    # ==== Attributes  
    #  
    # * +concept+ - A concept to focus on
    # * +condition+ - A futher condition to apply into the algorithm
    # * +update_system+ - A block determining the system updating
    #
    # ==== Example
    #
    # A --t--> A
    # t is reflexive
    # Into the pattern: A --t_r--> A
    def self.find_reflexive_edge(concept,
                            condition,
                            update_system)
      query= Query.new.distinct(:p).where(concept, :p , concept)
      query.execute do |property|
        if condition.call(property)
          update_system.call( concept, 
                              property, 
                              PROPERTY_TYPES[:reflexive])
        end
      end
    end
  
    # Inverse edge detection. Inverse edge: statement with a property denoted with "I"
    # See +EDGE_FINDERS[:inverse]+
    #
    # ==== Attributes  
    #  
    # * +concept+ - A concept to focus on
    # * +condition+ - A futher condition to apply into the algorithm
    # * +update_system+ - A block determining the system updating
    #
    # ==== Example
    #
    # A --q--> B
    # q is simple, focusing A
    # Into the pattern: A --q_s--> B
    def self.find_inverse_edge(concept, 
                          condition,
                          update_system)
      query= Query.new.distinct(:s, :p).where(:s, :p , concept)
      query.execute do |concept_s, property|
        if (property != A_GENERALIZE_RESOURCE && 
            property != A_FORGET_RESOURCE &&
            concept_s != concept && 
            condition.call(property))
          count = update_system.call( concept_s, 
                                      property, 
                                      PROPERTY_TYPES[:inverse])
        end
      end
    end
  
    # Inverse edge detection. Inverse edge: statement with a property denoted with "I"
    # +See EDGE_FINDERS[:simple]+
    #
    # ==== Attributes  
    #  
    # * +concept+ - A concept to focus on
    # * +condition+ - A futher condition to apply into the algorithm
    # * +update_system+ - A block determining the system updating
    def self.find_simple_edge( concept,
                          condition,
                          update_system)
      query = Query.new.distinct(:o, :p).where(concept, :p , :o)
      query.execute do |concept_o, property|
        if (property != RDF::type &&
            concept_o != concept &&
            condition.call(property))
          count = update_system.call( concept_o, 
                                      property, 
                                      PROPERTY_TYPES[:simple])
        end
      end
    end 
  end
  
end
  
