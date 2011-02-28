module Pbuilder
  
  class MapsAnalyzer
    
    # +root_concepts_list+ - A list of root concepts (a pair: abstract concept + core concept)
    # +finders+ A list of offline finder to request patterns information
    attr_reader :root_concepts_list, :finders
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +core_concept+ - A core concept representing the root of subgraph
    # * +storage_klass+ - A class to perform storage (See +PatternsStorage+ : +SimpleStorage+ and +PatternsTree+)
    def initialize(patterns_file, analysis_file, mapttings_file, id)
      @root_concepts_list = SearchEngine.find_root_concepts
      i = 0
      @finders, maps = [], []
      @root_concepts_list.each do |root_concepts|
        finder = OfflineFinder.new(root_concepts[1], Pbuilder::PatternsTree)
        finder.start({:id             =>  id,
                      :report         =>  true,
                      :patterns_file  =>  patterns_file + ".#{i}",
                      :analysis_file  =>  analysis_file + ".#{i}",
                      :report_view    =>  ""} )
        @finders << finder
        maps << [root_concepts[0].to_s, root_concepts[1].to_s, i]
        i = i.next
      end
      mappings = { mapttings_file => maps}
      YamlWriter.store_reports(mappings, id)
    end
    
  end
  
end