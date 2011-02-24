module Pbuilder
  
  class PatternsTree < PatternsStorage
      
    attr_reader :root, :leaves
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +init_concept+ - An initial concept to include
    def initialize(init_concept)
      @leaves = LeavesList.new()
      @root = @leaves.insert(init_concept.to_s)
      empty_temp
    end
    
    # Update patterns
     #  
     # ==== Attributes  
     #  
     # * +prev_concept+ - A concept determining the last item into the pattern to perform the attachment
     # * +property+ - A property to queue 
     # * +next_concept+ - A concept to queue
    def update(concept)
      concept = concept.to_s
      if ! @temp.empty?
        @leaves.substitute_concept_using_matrix(concept, 
                                                @temp)
        empty_temp
      end
    end

    def list
      @root.build_patterns
    end   
      
  end
    
end