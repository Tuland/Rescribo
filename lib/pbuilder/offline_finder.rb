module Pbuilder
  
  class OfflineFinder
    
    # +analysis+ - structure of analysis involved by the searching algorithm
    # +patterns - patterns storage
    attr_reader :analysis, :patterns
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +core_concept+ - A core concept representing the root of subgraph
    # * +storage_klass+ - A class to perform storage (See +PatternsStorage+ : +SimpleStorage+ and +PatternsTree+)
    def initialize(core_concept, storage_klass)
      @analysis = PatternsAnalysis.new(core_concept)
      @patterns = storage_klass.new(core_concept)
    end
    
    # Start search
    #  
    # ==== Attributes  
    #  
    # * +identifier+ - A personal identifier
    # * +patterns_file+ - A string determing the name of the patterns file
    # * +analysis_file+ - A string determing the name of the analysis file
    def start(identifier=nil, patterns_file=nil, analysis_file=nil)
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
      reports_hash = {patterns_file => @patterns.list,
                      analysis_file => @analysis }
      YamlWriter.store_reports(reports_hash, identifier)
    end
    
  end
  
end
