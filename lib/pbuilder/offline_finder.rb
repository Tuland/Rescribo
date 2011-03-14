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
    # * +options+ - An hash determining option
    #
    # ==== Options
    #
    # * +:id+ - A personal identifier
    # * +:report+ - Consent to write a report (value: true or false) 
    # * +:patterns_file+ - A string determining the name of the patterns file
    # * +:analysis_file+ - A string determining the name of the analysis file
    # * +:report_view+ - A method to perform the view
    #
    # ==== Report view
    #
    # * "" or nil - A generic view
    # * "list" - A patterns list
    # * "root" - A tree view available only with PatternsTree
    # * "leaves" - A view that show last concept of each pattern. It's available only with PatternsTree
    def start(options={})
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
      if options[:report]
        if options[:report_view].nil? || options[:report_view] = "list"
          view = @patterns
        else
          view = @patterns.send(options[:report_view])
        end
        reports_hash = {options[:patterns_file] => view,
                        options[:analysis_file] => @analysis}
        YamlWriter.store_reports(reports_hash, options[:id], options[:number])
      end
    end
    
  end
  
end
