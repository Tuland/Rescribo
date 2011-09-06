module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end

  class PatternReader
  
    def initialize(pattern)
      @pattern = pattern
      @size = @pattern.size
      @current = 0
    end
  
    def next_prop
      until yield(@current)
        @current = @current.next
      end
      RDFS::Resource.new(@pattern[@current])
    end
    
    alias :next_concept :next_prop
    
    def halted?
      @current >= (@size - 1)
    end
    
    def default_next_concept_and_prop
      prop = next_prop{ |i| i.even?  }
      concept = next_concept{ |i| i.odd?}
      return prop, concept
    end
  
  end
  
end