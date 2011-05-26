module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class DbAdapter < AbstractAdapter
    
    attr_reader :database
    
    def initialize( identifier, 
                    urls,
                    adapter_name,
                    db_config )
      @database =  DbAdapter.get_database(db_config[:database], 
                                          db_config[:host])
      @db_user = db_config[:username]
      @db_password = db_config[:password]

      urls.each do |url|
        @adapter = init_load(url, adapter_name, identifier)
      end
      init_setup(@adapter)
    end
    
    def self.get_connection(adapter_name, 
                            identifier, 
                            db_config)
      database =  DbAdapter.get_database( db_config[:database], 
                                          db_config[:host])
      DbAdapter.add_source( identifier,
                            adapter_name,
                            database,
                            db_config[:username],
                            db_config[:password])
    end
    
    def self.get_database(database_name, host)
      "jdbc:mysql://#{host}/#{database_name}"
    end
    
    private
    
    def init_load(url, adapter_name, identifier)
      DbAdapter.add_source( identifier,
                            adapter_name,
                            @database,
                            @db_user,
                            @db_password)
      adapter.load( url, 
                    :format => :rdfxml, 
                    :into => :default_model )
      adapter
    end
    
    def self.add_source(identifier,
                        adapter_name,
                        database,
                        db_user,
                        db_password)
      adapter = ConnectionPool.add_data_source( :type => :jena, 
                                                :model => adapter_name, 
                                                :id => identifier,
                                                :database => {:url => database + ";create=true", 
                                                              :type => "MySQL", 
                                                              :username => db_user, 
                                                              :password => db_password})
      adapter.enabled = true
      adapter
    end
      
  end
  
end