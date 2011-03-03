module Pbuilder
  
  # Analysis used by algorithm that build patterns
  class PatternsAnalysis
  
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
        init_concept = init_concept.to_s
        @concepts_list = Array[init_concept]
        @visited_concepts = Array[init_concept]
      end
      @properties_list = Hash.new
    end
  
    # Update concepts list and properties list  
    #  
    # ==== Attributes  
    #  
    # * +concept+ - A concept to include into the analysis
    # * +property_name+ - A property to include into the analysis
    # * +property_type+ - Type that +property_name+ belong to. See +SearchEngine::PROPERTY_TYPES+
    def update( concept_s,
                concept_o, 
                property_name, 
                property_type = DEFAULT_PROPERTY_TYPE)
      concept_s = concept_s.to_s
      concept_o = concept_o.to_s
      property_name = property_name.to_s
      @concepts_list.push(concept_o)
      edge = [concept_s, property_name, concept_o]
      @properties_list[edge] =  property_type
      if ! @visited_concepts.include?(concept_o)
        @visited_concepts.push(concept_o)
      end
    end
    
    def include_edge?(concept_s, 
                      property_name,
                      concept_o)
      concept_s = concept_s.to_s
      concept_o = concept_o.to_s
      property_name = property_name.to_s
      edge = [concept_s, property_name, concept_o]
      result_s = @properties_list.has_key?(edge)
      edge = [concept_o, property_name, concept_s]
      result_i = @properties_list.has_key?(edge)
      result_s || result_i
    end
  
    # Print a report  
    #  
    # ==== Attributes  
    #  
    # * +count+ - An integer determining the algorithm step
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
    
  end
  
end
