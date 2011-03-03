module Pbuilder
  
  class MapsAnalyzer
    
    # +root_concepts_list+ - A list of root concepts (a pair: abstract concept + core concept)
    # +finders+ - A list of offline finder to request patterns information
    attr_reader :root_concepts_list, :finders
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +options+ - An hash determining option
    #
    # ==== Options
    #  
    # * +:report+ - Consent to write a report (value: true or false) 
    # * +:patterns_file+ - A string determining the name of the patterns file
    # * +:analysis_file+ - A string determining the name of the analysis file
    # * +:mappings_file+ - A string determining the name of the mapping file that contains a list of triples (abstract concept, core concepts, mapping reference number)
    # * +:id+ - A personal identifier
    def initialize(options={})
      @root_concepts_list = SearchEngine.find_root_concepts
      i = 0
      @finders, maps = [], []
      @root_concepts_list.each do |root_concepts|
        finder = OfflineFinder.new(root_concepts[1], Pbuilder::PatternsTree)
        finder.start({:id             =>  options[:id],
                      :report         =>  options[:report],
                      :patterns_file  =>  options[:patterns_file].to_s + ".#{i}",
                      :analysis_file  =>  options[:analysis_file].to_s + ".#{i}",
                      :report_view    =>  ""} )
        @finders << finder
        maps << [root_concepts[0].to_s, root_concepts[1].to_s, i]
        i = i.next
      end
      if options[:report]
        mappings = { options[:mappings_file] => maps}
        YamlWriter.store_reports(mappings, options[:id])
      end
    end
    
  end
  
end