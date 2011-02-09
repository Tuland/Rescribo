module Pbuilder
  
  class OfflineFinder
    attr_reader :analysis, :patterns
  
    def initialize(core_concept)
      @analysis = PatternsAnalysis.new(core_concept)
      @patterns = PatternsStorage.new(core_concept)
    end
  
    def start
      step_count = 0
      # @patterns_analysis.puts_report(step_count)
      while ! @analysis.concepts_list.empty?
        SearchEngine.find_neighbours( @analysis.concepts_list.first, 
                                      @analysis,
                                      @patterns)
        step_count = step_count.next 
        # @patterns_analysis.puts_report(step_count)
        # @patterns_list.puts_patterns(step_count)
        @analysis.shift_concepts
      end
    end
  end
  
end
