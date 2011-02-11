module Pbuilder
  
  # Analysis used by algorithm that build patterns
  class PatternsAnalysis
  
    DEFAULT_PROPERTY_TYPE = SearchEngine::PROPERTY_TYPES[:simple]
  
    # * +concept_list+ - List to store concept
    # * +properties_list - List to store properties
    attr_reader :concepts_list, :properties_list
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +init_concept+ - an initial concept to include
    def initialize(init_concept=nil)
      if init_concept.nil?
        @concepts_list, @properties_list = Array.new, Hash.new
      else
        @concepts_list, @properties_list = Array[init_concept], Hash.new
      end
    end
  
    # Update concepts list and properties list  
    #  
    # ==== Attributes  
    #  
    # * +concept+ - A concept to include into the analysis
    # * +property_name+ - A property to include into the analysis
    # * +property_type+ - Type that +property_name+ belong to. See +SearchEngine::PROPERTY_TYPES+
    def update(concept, 
               property_name, 
               property_type = DEFAULT_PROPERTY_TYPE)
      @concepts_list.push(concept)
      @properties_list[property_name] =  property_type
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
