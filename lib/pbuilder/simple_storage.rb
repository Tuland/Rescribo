module Pbuilder
  
  class SimpleStorage < PatternsStorage
    
    # * +list+ - List to storage patterns
    attr_reader :list
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +init_concept+ - An initial concept to include
    def initialize(init_concept=nil)
      if init_concept.nil?
        @list = Array.new
      else
        @list = Array[Array[init_concept.to_s]]
      end
      empty_temp
    end
  
    # Update patterns using a cache  
    #  
    # ==== Attributes  
    #  
    # * +prev_concept+ - A concept determining the last item into the pattern to perform the attachment
    # * +property+ - A property to queue 
    # * +next_concept+ - A concept to queue
    def update(concept)
      if ! @temp.empty?
        concept = concept.to_s
        new_patterns = []
        @list.each do |pattern|
          if pattern.last == concept
            cloned_temp = @temp.clone
            first_node = cloned_temp.shift
            cloned_temp.each do |node|
              cloned_pattern = pattern.clone
              cloned_pattern << node[1] #property
              cloned_pattern << node[0] #concept
              new_patterns << cloned_pattern
            end
            pattern << first_node[1]  # property
            pattern << first_node[0]  # concept
          end
        end
        empty_temp
        @list = @list + new_patterns
      end
    end
  
    # Print a report  
    #  
    # ==== Attributes  
    #  
    # * +step+ - An integer determining the algorithm step
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
