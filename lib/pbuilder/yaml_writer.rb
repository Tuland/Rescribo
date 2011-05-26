module Pbuilder
  require 'yaml'
  
  class YamlWriter
    
    # Store reports
    #  
    # ==== Attributes
    #
    # * +report_hash+ - An hash defined by couples (report_name => content_list)
    # * +id+ - Identifier
    # * +number+ - Code number
    def self.store_reports(reports_hash, id, number=nil )
      if ! id.nil?
        reports_hash.each do |report, list|
          if ! report.nil?
            file = YamlWriter.get_file_path(id,
                                            report,
                                            number)
            YamlWriter.store_list(file, list)
          end
        end
      end
    end
    
    # Dump a list storing in a file
    #  
    # ==== Attributes
    #
    # * +file+ - File name
    # * +list+ - Content list    
    def self.store_list(file, list)
      open(file, 'w') {|f| YAML.dump(list, f)}
    end
    
    # Returns a file path
    #  
    # ==== Attributes
    #
    # * +id+ - Identifier
    # * +report_file+ - File name (report)
    # * +number+ - Code number    
    def self.get_file_path(id, report_file, number=nil)
      if number != nil
        report_file = report_file + "." + number.to_s
      end
      report_file + "_" + id.to_s + ".yml"
    end
  
  end
end