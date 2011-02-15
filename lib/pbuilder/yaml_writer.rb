module Pbuilder
  require 'yaml'
  
  class YamlWriter
    
    def self.store_reports(reports_hash, identifier)
      if ! identifier.nil?
        reports_hash.each do |report, list|
          if ! report.nil?
            file = YamlWriter.get_file_path(identifier,
                                            report)
            YamlWriter.store_list(file, list)
          end
        end
      end
    end
    
    def self.store_list(file, list)
      open(file, 'w') {|f| YAML.dump(list, f)}
    end
    
    def self.get_file_path(identifier, report_file)
      report_file + "_" + identifier.to_s
    end
  
  end
end