module Pbuilder
  
  class CloudsExplorer
    attr_reader :global_root_concepts, :global_finders
    
    # Init
    #  
    # ==== Attributes  
    # 
    # * +identifier+ - A personal identifier 
    # * +options+ - An hash determining options
    # * +adapter_name+ - An adapter name
    #
    # ==== Options
    #  
    # * +:report+ - Consent to write a report (value: true or false)
    # * +:patterns_file+ - A string determining the name of the patterns file
    # * +:analysis_file+ - A string determining the name of the analysis file
    # * +:id+ - A personal identifier
    # * +:mappings_file+ - A string determining the name of the mapping file that contains a list of triples (abstract concept, core concepts, mapping reference number)
    def initialize(files, adapter_name, identifier, options={}, path="")
      @global_root_concepts, @global_finders = [], []
      mappings = {}
      i = 0
      files.each do |file|
        Adapter.purge(options[:id], path)
        adapter = Adapter.new(identifier,
                              file,
                              adapter_name,
                              path)
        begin
          maps = MapsAnalyzer.new({ :report         =>  options[:report],
                                    :id             =>  identifier ,
                                    :patterns_file  =>  options[:patterns_file],
                                    :analysis_file  =>  options[:analysis_file],
                                    :counter => i} )
          maps.root_concepts_list.each do |r_concepts|
            @global_root_concepts << r_concepts
            mappings[r_concepts[0]] = [r_concepts[1], i]
            i = i.next
          end
          maps.finders.each do |finder|
            @global_finders << finder
          end  
        rescue  Exception => e
          puts e.message
          puts e.backtrace.inspect
        ensure
          adapter.close
        end
      end
      if options[:report]
        m = { options[:mappings_file] => mappings}
        YamlWriter.store_reports(m, identifier)
      end
    end
    
  end
end