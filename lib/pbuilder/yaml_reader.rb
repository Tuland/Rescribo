module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  require 'yaml'
  
  class YamlReader
    include PHelper
    
    # +:mappings+ - An Hash determining every mapping available. Key: abstract concept
    attr_reader :mappings
    
    # Init
    #  
    # ==== Attributes
    #
    # * +user_ id+ - A personal identifier
    # * +mappings_file+ - A string determining the name of the mappings file
    # * +patterns_file+ - A string determining the name of the patterns file
    # * +analysis_file+ - A string determining the name of the analysis file
    def initialize(user_id, mappings_file, patterns_file, analysis_file)
      @id = user_id
      file = YamlWriter.get_file_path(user_id, mappings_file)
      @mappings = open(file) { |f| YAML.load(f) }
      @mappings_file = mappings_file
      @patterns_file = patterns_file
      @analysis_file = analysis_file
    end
    
    # Load patterns idetified by an abstract concept  
    #  
    # ==== Attributes
    #
    # * +abstract_concepts+ - A sequence of abstract concepts. Allowed: RDFS::Resource, String, <String>
    def load(*abstract_concepts)
      patterns, analysis = {}, {}
      abstract_concepts.each do |concept|
        concept = Converter.src_2_str(concept)
        number = @mappings[concept][1]
        file_p = YamlWriter.get_file_path(@id, @patterns_file, number)
        patterns[concept] = open(file_p) { |f| YAML.load(f) }
        file_a = YamlWriter.get_file_path(@id, @analysis_file, number)
        analysis[concept] = open(file_a) { |f| YAML.load(f) }
      end 
      return patterns, analysis
    end
    
    # Load every patterns available
    def load_all
      load(*@mappings.keys)
    end
    
  end
  
end