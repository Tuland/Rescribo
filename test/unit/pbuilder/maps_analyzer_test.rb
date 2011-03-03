module Pbuilder
  
  require 'test_helper'
  
  class MapsAnalyzerTest < ActiveSupport::TestCase
    THIS_PATH = File.dirname(File.expand_path(__FILE__)) + "/"
    IDENTIFIER = 1234
    ONTO_NAME = {
      :simple_multiple_maps => "simple_multiple_maps.owl",
    }.freeze
    ADAPTER_NAME = "name"
    
    def setup
      Adapter.purge(IDENTIFIER,
                    THIS_PATH)
      adapter = Adapter.new(IDENTIFIER,
                            Adapter.local_url(THIS_PATH, 
                                              ONTO_NAME[:simple_multiple_maps]),
                            ADAPTER_NAME,
                            THIS_PATH)
      @maps = Pbuilder::MapsAnalyzer.new
    end
    
    test "root_concepts_list" do
      assert_equal(2, @maps.root_concepts_list.size)
    end
    
    test "finders" do
      assert_equal(2, @maps.finders.size)
      @maps.finders.each do |finder|
        assert_instance_of(OfflineFinder, finder)
      end
    end
    
  end
end