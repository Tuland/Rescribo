module Pbuilder
  require 'yaml'
  
  class YamlWriter
    
    def self.store_reports(reports_hash, id)
      if ! id.nil?
        reports_hash.each do |report, list|
          if ! report.nil?
            file = YamlWriter.get_file_path(id,
                                            report)
            YamlWriter.store_list(file, list)
          end
        end
      end
    end
    
    def self.store_list(file, list)
      open(file, 'w') {|f| YAML.dump(list, f)}
    end
    
    def self.get_file_path(id, report_file)
      report_file + "_" + id.to_s
    end
  
  end
end