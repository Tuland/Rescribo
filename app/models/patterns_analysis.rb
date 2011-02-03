# Analysis used by algorithm that build patterns 
class PatternsAnalysis
  
  # Lists that store concepts and properties visited 
  attr_accessor :concepts_list, :properties_list
  
  def initialize(init_concept=nil)
    @concepts_list, @properties_list = Array[init_concept], Hash.new
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
             property_type = PROPERTY_TYPES[:simple])
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
  
end
