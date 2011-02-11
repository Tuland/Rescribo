module Pbuilder
  
  class PatternsStorage
    
    # * +list+ - List to storage patterns
    # * +cache+ - Support list
    attr_reader :list, :cache
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +init_concept+ - An initial concept to include
    def initialize(init_concept=nil)
      if init_concept.nil?
        @list = Array.new
      else
        @list = Array[Array[init_concept]]
      end
      @cache = Array.new
    end
    
    # Reset the cache. Stop to mantain the last patterns in memory
    def empty_cache
      @cache = Array.new
    end
  
    # Update patterns using a cache  
    #  
    # ==== Attributes  
    #  
    # * +prev_concept+ - A concept determining the last item into the pattern to perform the attachment
    # * +property+ - A property to queue 
    # * +next_concept+ - A concept to queue
    def update(prev_concept, 
               property, 
               next_concept)
      size = @list.size
      # empty list => initialization with prev_concept
      if size == 0
        @list << [prev_concept]
        size = size.next
      end
      # approach without cache support => build cache
      if @cache.empty?
        for i in 0...size
          if @list[i].last == prev_concept
            @cache << @list[i].clone
            @list[i] << property
            @list[i] << next_concept
          end
        end
      # approach with cache support
      else
        @cache.each do |pattern_c|
          pattern_temp = pattern_c.clone
          pattern_temp << property
          pattern_temp << next_concept 
          @list << pattern_temp  
        end 
      end
    end
  
    # Print a report  
    #  
    # ==== Attributes  
    #  
    # * +count+ - An integer determining the algorithm step
    def print_report(step)
      puts "STEP #{step}"
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
  
end
