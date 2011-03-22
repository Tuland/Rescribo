module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  # Analysis used by algorithm that build patterns
  class PatternsAnalysis
    include PHelper
  
    DEFAULT_PROPERTY_TYPE = SearchEngine::PROPERTY_TYPES[:simple]
  
    # * +:concepts_list+ - List to store concept that must be visited (duplication, push & shift)
    # * +:properties_list+ - List to store properties 
    # * +:visited_concepts+ - List of visited concepts (no duplication, only push)
    attr_reader :concepts_list, :properties_list, :visited_concepts, :edges_list
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +init_concept+ - an initial concept to include
    def initialize(init_concept=nil)
      if init_concept.nil?
        @concepts_list = Array.new
        @visited_concepts = Array.new
      else
        init_concept = Converter.src_2_str(init_concept)
        @concepts_list = Array[init_concept]
        @visited_concepts = Array[init_concept]
      end
      @properties_list = Hash.new
    end
  
    # Update concepts list and properties list  
    #  
    # ==== Attributes  
    #  
    # * +concept_s+ - A concept (subject) to include into the analysis. Allowed: RDFS::Resource, String, <String>
    # * +concept_o+ - A concept (object) to include into the analysis. Allowed: RDFS::Resource, String, <String>
    # * +property_name+ - A property to include into the analysis. Allowed: RDFS::Resource, String, <String>
    # * +property_type+ - Type that +property_name+ belong to. See +SearchEngine::PROPERTY_TYPES+
    def update( concept_s,
                concept_o, 
                property_name, 
                property_type = DEFAULT_PROPERTY_TYPE)
      concept_s = Converter.src_2_str(concept_s)
      concept_o = Converter.src_2_str(concept_o)
      property_name = Converter.src_2_str(property_name)
      @concepts_list.push(concept_o)
      update_properties_list( concept_s,
                              property_name,
                              concept_o,
                              property_type)
      if ! @visited_concepts.include?(concept_o)
        @visited_concepts.push(concept_o)
      end
    end
    
    # Answer if an edge is already visited
    def include_edge?(concept_s, 
                      property_name,
                      concept_o)
      concept_s = Converter.src_2_str(concept_s)
      concept_o = Converter.src_2_str(concept_o)
      property_name = Converter.src_2_str(property_name)
      result_s = include_directed_edge?(concept_s, 
                                        property_name,
                                        concept_o)
      result_i = include_directed_edge?(concept_o, 
                                        property_name,
                                        concept_s) 
      result_s || result_i
    end
    
    # Answer if a property (+property_rsc+) is inverse of a property included in the properties list 
    #
    # ==== Attributes 
    #
    # +property_rsc+ - An ActiveRDF resource determining a property
    def include_inverse_of?(property_rsc)
      each_property_name do |item|
        p = RDFS::Resource.new(item).inverseOf
        if p == property_rsc
          return true
        end
      end
      return false
    end
    
    # Answer if a property is included in the properties list. The verification is limited to name
    #
    # ==== Attributes 
    #
    # +property+ - A property URI (also an ActiveRDF resource). Allowed: RDFS::Resource, String, <String>
    def include_property_name?(property)
      property = Converter.src_2_str(property)
      each_property_name do |item|
        if item == property
          return true
        end
      end
      return false
    end
    
    # Iterate over property names
    def each_property_name
      @properties_list.keys.each do |edge|
        yield(edge[1])
      end
    end
  
    # Print a report  
    #  
    # ==== Attributes  
    #  
    # * +step+ - An integer determining the algorithm step
    def puts_report(step)
      puts "STEP #{step}"
      puts "CONCEPTS: "
      puts @concepts_list
      puts "PROPERTIES: "
      @properties_list.each do |p_name, p_type|
        puts "#{p_name} --> #{p_type}"
      end
      puts "\n"
    end
  
    # Returns the first element of the concept list and removes it
    def shift_concepts
      @concepts_list.shift
    end
    
    private
    
    def update_properties_list( concept_s,
                                property_name,
                                concept_o,
                                property_type)
      edge = [concept_s, property_name, concept_o]
      @properties_list[edge] =  property_type
    end
    
    def include_directed_edge?(concept_s, property_name, concept_o)
      edge = [concept_s, property_name, concept_o]
      @properties_list.has_key?(edge)
    end
    
  end
  
end
