module Pbuilder
  
  class PatternsTree < PatternsStorage
    include PHelper
      
    attr_reader :root, :leaves
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +init_concept+ - An initial concept to include. Allowed: RDFS::Resource, String, <String>
    def initialize(init_concept)
      @leaves = LeavesList.new()
      init_concept = Converter.rsc_2_str(init_concept)
      @root = @leaves.insert(init_concept)
      empty_temp
    end
    
    # Update patterns
     #  
     # ==== Attributes  
     #  
     # * +prev_concept+ - A concept determining the last item into the pattern to perform the attachment. Allowed: RDFS::Resource, String, <String>
    def update(concept)
      concept = Converter.rsc_2_str(concept)
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