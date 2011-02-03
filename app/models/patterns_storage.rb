class PatternsStorage
  
  attr_reader :list, :cache
  
  def initialize(init_concept=nil)
    @list = Array[Array[init_concept]]
    @cache = Array.new
  end
  
  def empty_cache
    @cache = Array.new
  end
  
  def update(prev_concept, 
             property, 
             next_concept)
    size = @list.size
    if @cache.empty?
      for i in 0...size
        if @list[i].last == prev_concept
          @cache << @list[i].clone
          @list[i] << property
          @list[i] << next_concept
        end
      end
    else
      @cache.each do |pattern_c|
        pattern_temp = pattern_c.clone
        pattern_temp << property
        pattern_temp << next_concept 
        @list << pattern_temp  
      end 
    end
  end
  
  def print_report(count)
    puts "STEP #{count}"
    i = 0
    @list.each do |pattern|
      i = i.next
      puts "PATTERN #{i}"
      j = 0
      pattern.each do |item|
        j = j.next
        puts "#{j} - #{item}"
      end
    end
    puts "\n"
  end
  
end
