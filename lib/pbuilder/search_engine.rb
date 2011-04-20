module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  include PHelper
  
  class SearchEngine
  
    #  <b>Marker</b> class: URI string
    MARKER_STR = "http://www.siti.disco.unimib.it/cmm/2010/aeria#Marker"
    #  <b>Marker</b> class: ActiveRDF resource
    MARKER_RESOURCE = RDFS::Resource.new(MARKER_STR)
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
    # This finders list detect reflexive, simple and rinverse edges (in this order)
    DEFAULT_FINDERS = [ EDGE_FINDERS[:reflexive],
                        EDGE_FINDERS[:simple], 
                        EDGE_FINDERS[:inverse] ]                    

    # Core and abstract concepts detection. Return pairs in a list
    def self.find_root_concepts
      query = Query.new.distinct(:s,:o).where(:s, A_GENERALIZE_RESOURCE, :o)
      concepts = []
      query.execute do |abstract_concept, core_concept|
         concepts << [abstract_concept, core_concept]
      end
      concepts
    end
    
    # Core and abstract concepts detection (first pair)
    def self.find_a_single_pair_of_rc
      root_concepts_list = self.find_root_concepts
      abstract_concept, core_concept = root_concepts_list[0][0], root_concepts_list[0][1]
    end
  
    # Find neighbours of a concept  
    #  
    # ==== Attributes  
    #  
    # * +concept+ - A concept (String or ActiveRDF Resource) to focus on
    # * +analysis+ - A patterns analysis. See +PatternsAnalysis+
    # * +patterns+ - A list of patterns storage. See +PatternsStorage+
    # * +finders_list+ - A list determining finders to use into the algorithm. See +DEFAULT_FINDERS+ and +EDGE_FINDERS+
    #
    # ==== Example
    #
    # B --p--> A
    # p is an inverse edge, focusing A
    # Into the pattern: A --p_i--> B
    #
    # ==== Infos
    #
    # Only one inverse property is taken in consideration (See: search_engine_test.rb)
    def self.find_neighbours( concept, 
                              analysis,
                              patterns_storage, 
                              finders_list = DEFAULT_FINDERS )
      # Token bound: property count < 1
      condition = Proc.new do |curr_property, curr_concept|
        ! analysis.include_edge?(concept, curr_property, curr_concept) &&
        ! analysis.include_property_name?(curr_property.inverseOf) &&
        ! analysis.include_inverse_of?(curr_property)
      end
      # System update analysis and patterns storage
      update_system = Proc.new do | curr_concept, 
                                    curr_property, 
                                    curr_property_type|
        analysis.update(concept,
                        curr_concept, 
                        curr_property,
                        curr_property_type)
        patterns_storage.import(curr_concept,
                                curr_property)

      end
      # Reflection: it performs the finders included in the +finders_list+
      finders_list.each do |finder|
        concept = RDFS::Resource.new(concept)
        count = self.send finder, concept, condition, update_system  
      end
      # Update storage
      patterns_storage.update(concept)
    end
  
    # Reflexive edge detection. Reflexive edge: statement with a property denoted with "R"
    # See +EDGE_FINDERS[:reflexive]+
    #
    # ==== Attributes  
    #  
    # * +concept+ - A concept (ActiveRDF Resource) to focus on
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
        if condition.call(property, concept)
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
    # * +concept+ - A concept (ActiveRDF Resource) to focus on
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
        if (property.different?(A_GENERALIZE_RESOURCE,
                                A_FORGET_RESOURCE,
                                RDFS::label) &&
            concept_s != concept && 
            condition.call(property, concept_s))
          update_system.call( concept_s, 
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
    # * +concept+ - A concept (ActiveRDF Resource) to focus on
    # * +condition+ - A futher condition to apply into the algorithm
    # * +update_system+ - A block determining the system updating
    def self.find_simple_edge(concept,
                              condition,
                              update_system)
      query = Query.new.distinct(:o, :p).where(concept, :p , :o)
      query.execute do |concept_o, property|
        if (property != RDF::type &&  
            concept_o != concept &&   # avoid overlapping with find_reflexive_edge
            condition.call(property, concept_o))
          update_system.call( concept_o, 
                              property, 
                              PROPERTY_TYPES[:simple])
        end
      end
    end
     
  end
  
end
  
