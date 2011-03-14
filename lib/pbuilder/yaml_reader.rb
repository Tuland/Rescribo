module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  require 'yaml'
  
  class YamlReader
    
    attr_reader :reports, :mappings
    
    def initialize(user_id, mappings_file, patterns_file, analysis_file)
      @id = user_id
      file = YamlWriter.get_file_path(user_id, mappings_file)
      @mappings = open(file) { |f| YAML.load(f) }
      @mappings_file = mappings_file
      @patterns_file = patterns_file
      @analysis_file = analysis_file
    end
    
    def load(*abstract_concepts)
      abstract_concept  = RDFS::Resource.new(abstract_concept).to_s
      number = @mapping[abstract_concept][1]
      patterns, analysis = {}, {}
      abstract_concepts.each do |concept|
        file_p = YamlWriter.get_file_path(@id, @patterns_file, number)
        patterns[concept] = open(file_p) { |f| YAML.load(f) }
        file_a = YamlWriter.get_file_path(@id, @analysis_file, number)
        analysis[concept] = open(file_a) { |f| YAML.load(f) }
      end 
      return patterns, anaysis
    end
    
    def load_all
      load(*@mappings.keys)
    end
  
end