module Pbuilder
  
  class MapsAnalyzer
    include PHelper
    
    # +root_concepts_list+ - A list of root concepts (a pair: abstract concept + core concept)
    # +finders+ - A list of offline finder to request patterns information
    attr_reader :root_concepts_list, :finders, :counter
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +options+ - An hash determining options
    #
    # ==== Options
    #
    # * +:files+ - An array including file address (string) of clouds
    # * +:report+ - Consent to write a report (value: true or false) 
    # * +:patterns_file+ - A string determining the name of the patterns file
    # * +:analysis_file+ - A string determining the name of the analysis file
    # * +:id+ - A personal identifier
    # * +:counter+ - A global counter that enumerate clouds
    def initialize(options={})
      rc_list = SearchEngine.find_root_concepts
      @counter = options[:counter] || 0
      @finders, @root_concepts_list = [], []
      rc_list.each do |root_concepts|
        abst_concept = Converter.src_2_str(root_concepts[0])
        core_concept = Converter.src_2_str(root_concepts[1])
        finder = OfflineFinder.new(core_concept, Pbuilder::PatternsTree)
        finder.start({:id             =>  options[:id],
                      :report         =>  options[:report],
                      :patterns_file  =>  options[:patterns_file].to_s,
                      :analysis_file  =>  options[:analysis_file].to_s,
                      :number         =>  @counter,
                      :report_view    =>  ""} )
        @finders << finder
        @root_concepts_list << [abst_concept, core_concept]
        @counter = @counter.next
      end
    end
    
  end
  
end