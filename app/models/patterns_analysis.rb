class PatternsAnalysis
  attr_accessor :concepts_list, :properties_list
  
  def initialize(init_concept=nil)
    @concepts_list, @properties_list = Array[init_concept], Hash.new
  end
  
  def update(concept, 
             property_name, 
             property_type = PROPERTY_TYPES[:simple])
    @concepts_list.push(concept)
    @properties_list[property_name] =  property_type
  end
  
  def puts_report(count)
    puts "STEP #{count}"
    puts "CONCEPTS: "
    puts @concepts_list
    puts "PROPERTIES: "
    @properties_list.each do |p_name, p_type|
      puts "#{p_name} --> #{p_type}"
    end
    puts "\n"
  end
  
end
