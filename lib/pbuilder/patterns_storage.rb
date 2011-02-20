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
        @list = Array[Array[init_concept.to_s]]
      end
      empty_temp
    end
    
    def empty_temp
      @temp = Hash.new
    end
    
    def import(concept, property)
      @temp[concept.to_s] = property.to_s
    end
  
    # Update patterns using a cache  
    #  
    # ==== Attributes  
    #  
    # * +prev_concept+ - A concept determining the last item into the pattern to perform the attachment
    # * +property+ - A property to queue 
    # * +next_concept+ - A concept to queue
    def update(concept)
      concept = concept.to_s
      @list.each do |pattern|
        if @pattern.last == concept
          first_node = @temp.shift
          @temp.each do |concept_t, property_t|
            cloned_pattern = pattern.clone
            cloned_pattern << property_t
            cloned_pattern << concept_t
            @list # NON VA BENE! Sporco il primo each -> i cloned vanno messi alla fine dell'update! ci vuona una cache
          end
        end
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
