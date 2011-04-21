module Pbuilder
  
  require 'test_helper'
  
  class CloudsExplorerTest < ActiveSupport::TestCase
    THIS_PATH = File.dirname(File.expand_path(__FILE__)) + "/"
    IDENTIFIER = 1234
    ONTO_NAME = {
      :simple_edge => "simple_edge_sample.owl",
    }.freeze
    ADAPTER_NAME = "name"
    
    TestPHelper.set_rootc_const_for_test(self)
    
    test "overlapping" do
      file_addr = Adapter.local_url(THIS_PATH, ONTO_NAME[:simple_edge])
      
      explorer = CloudsExplorer.new([ file_addr, file_addr ],
                                    ADAPTER_NAME,
                                    IDENTIFIER,
                                    THIS_PATH)
      global_rc_list = explorer.global_root_concepts
      root_concepts = [ ABSTRACT_CONCEPT_STR,
                        CORE_CONCEPT_STR]
      assert_equal(global_rc_list, [root_concepts, root_concepts])
    end
    
  end
end