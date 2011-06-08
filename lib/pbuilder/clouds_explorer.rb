module Pbuilder
  
  include Java
  
  class CloudsExplorer
    attr_reader :global_root_concepts, :global_finders, :mappings
    attr_accessor :prefixes
    
    # Init
    #  
    # ==== Attributes  
    # 
    # * +files+ - An array including file address (string) of clouds
    # * +identifier+ - A personal identifier 
    # * +adapter_name+ - An adapter name
    # * +options+ - An hash determining options
    # * +path+ - A path where store the persistence directory
    #
    # ==== Options
    #  
    # * +:report+ - Consent to write a report (value: true or false)
    # * +:patterns_file+ - A string determining the name of the patterns file
    # * +:analysis_file+ - A string determining the name of the analysis file
    # * +:id+ - A personal identifier
    # * +:mappings_file+ - A string determining the name of the mapping file that contains a list of triples (abstract concept, core concepts, mapping reference number)
    # * +:counter+ - A global counter that enumerate clouds
    def initialize(files, adapter_name, identifier, options={}, path="")
      @global_root_concepts, @global_finders = [], []
      @mappings = {}
      @prefixes = java.util.HashMap.new
      i = 0
      files.each do |file|
        Adapter.purge(identifier, path)
        adapter = Adapter.new(identifier,
                              [file],
                              adapter_name,
                              path)
        @prefixes.putAll(adapter.prefixes)
        
        begin
          maps = MapsAnalyzer.new({ :report         =>  options[:report],
                                    :id             =>  identifier ,
                                    :patterns_file  =>  options[:patterns_file],
                                    :analysis_file  =>  options[:analysis_file],
                                    :counter => i} )
          maps.root_concepts_list.each do |r_concepts|
            @global_root_concepts << r_concepts
            @mappings[r_concepts[0]] = [r_concepts[1], i]
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
        m = { options[:mappings_file] => @mappings}
        YamlWriter.store_reports(m, identifier)
      end
    end
    
  end
  
end