module Pbuilder
  
  require 'test_helper'
  
  class AdapterTest < ActiveSupport::TestCase
    
    THIS_PATH = File.dirname(File.expand_path(__FILE__)) + "/"
    IDENTIFIER = 1234
    ONTO_NAME = {
      :minimal => "minimal_sample.owl"
    }.freeze
    URL = Adapter.local_url(THIS_PATH, ONTO_NAME[:minimal])
    ADAPTER_NAME = "name"
    FILE_PATH = Adapter.personal_persistence_file(ADAPTER_NAME,
                                                  IDENTIFIER,
                                                  THIS_PATH)
                                                  
    def setup
      Adapter.purge(IDENTIFIER,
                    THIS_PATH)
      @adapter = Adapter.new( IDENTIFIER, 
                              URL, 
                              ADAPTER_NAME,
                              THIS_PATH)
      @adapter.close
    end
    
    test "presence_of_persitence_file" do
      assert FileTest.exist?(FILE_PATH)
    end
    
    test "absence_of_persitence_file" do
      Adapter.purge(IDENTIFIER,
                    THIS_PATH)
      assert ! FileTest.exist?(FILE_PATH)
    end   
    
  end
  
end