module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end

  class PatternReader

    # Init
    #  
    # ==== Attributes  
    # 
    # * +patterns+ - An array including patterns
    def initialize(pattern)
      @pattern = pattern
      @size = @pattern.size
      @current = 0
    end
  
    # find the next property. 
    #
    # ==== Examples
    #
    # # next_prop{ |i| i.even?  }
    # # in this example properties have an even position
    def next_prop
      until yield(@current)
        @current = @current.next
      end
      RDFS::Resource.new(@pattern[@current])
    end
    
    alias :next_concept :next_prop
    
    # Returns true if redding is halted 
    def halted?
      @current >= (@size - 1)
    end
    
    # Return the next property and concept. 
    # Assumption: properties are in even position and concepts in odd position
    def default_next_concept_and_prop
      prop = next_prop{ |i| i.even?  }
      concept = next_concept{ |i| i.odd?}
      return prop, concept
    end
  
  end
  
end