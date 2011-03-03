module Pbuilder
  
  require 'test_helper'
  
  class OfflineFinderTest < ActiveSupport::TestCase
    THIS_PATH = File.dirname(File.expand_path(__FILE__)) + "/"
    IDENTIFIER = 1234
    ONTO_NAME = {
      :semi_cycle => "semi_cycle_sample.owl",
      :min_prop_dup => "minimal_property_duplication.owl",
      :prop_dup_1 => "property_duplication_1.owl",
      :prop_dup_2 => "property_duplication_2.owl", 
    }.freeze
    ADAPTER_NAME = "name"
    # Root concepts: ABSTRACT_CONCEPT_STR, ABSTRACT_CONCEPT_RES, CORE_CONCEPT_STR and CORE_CONCEPT_RES                                              
    TestPHelper.set_rootc_const_for_test(self)
    # Const associated with properties: PROPERTY_#{letter}_STR and PROPERTY_#{letter}_RES
    TestPHelper.set_properties_const_for_test(self, "p", "w")
    # Const associated with concepts: CONCEPT_#{letter}_STR and CONCEPT_#{letter}_RES
    TestPHelper.set_concepts_const_for_test(self, "b", "e")
    
    def setup
      Adapter.purge(IDENTIFIER,
                    THIS_PATH)
    end
    
    def teardown
      if ! @adapter.nil?
        @adapter.close
      end
    end
    
    test "simple_storage_instance" do
      abstract_concept, core_concept = setup_adapter(ONTO_NAME[:semi_cycle])
      finder = OfflineFinder.new(core_concept, SimpleStorage)
      assert_instance_of(SimpleStorage, finder.patterns)
    end
    
    test "patterns_tree_instance" do
      abstract_concept, core_concept = setup_adapter(ONTO_NAME[:semi_cycle])
      finder = OfflineFinder.new(core_concept, PatternsTree)
      assert_instance_of(PatternsTree, finder.patterns)
    end
    
    test "root_of_patterns_tree_exploring_a_semi_cycle" do
      abstract_concept, core_concept = setup_adapter(ONTO_NAME[:semi_cycle])
      finder = OfflineFinder.new(core_concept, PatternsTree)
      finder.start
      assert_instance_of(String, finder.patterns.root.value)
      assert_equal(CORE_CONCEPT_STR, finder.patterns.root.value)
    end
    
    test "leaves_of_patterns_tree_exploring_a_semi_cycle" do
      abstract_concept, core_concept = setup_adapter(ONTO_NAME[:semi_cycle])
      finder = OfflineFinder.new(core_concept, PatternsTree)
      finder.start
      correct_leaves = [CONCEPT_C_STR,
                        CONCEPT_D_STR,
                        CONCEPT_E_STR,
                        CONCEPT_E_STR,
                        CONCEPT_E_STR]
      assert_equal_leaves(correct_leaves, finder.patterns.leaves)
    end
    
    test "comparison_simple_storage_with_patterns_tree" do
      abstract_concept, core_concept = setup_adapter(ONTO_NAME[:semi_cycle])
      finder = OfflineFinder.new(core_concept, PatternsTree)
      finder.start
      list_t = finder.patterns.list
      finder = OfflineFinder.new(core_concept, SimpleStorage)
      finder.start
      # List mode: SimpleStorage = PatternsTree
      list_s = finder.patterns.list
      assert_equal(list_t.sort, list_s.sort)
    end
    
    test "semi_cycle_with_simple_storage" do
      abstract_concept, core_concept = setup_adapter(ONTO_NAME[:semi_cycle])
      finder = OfflineFinder.new(core_concept, SimpleStorage)
      finder.start
      correct_patterns = [  [ CORE_CONCEPT_STR,
                              PROPERTY_Q_STR,
                              CONCEPT_C_STR,
                              PROPERTY_T_STR,
                              CONCEPT_E_STR,
                              PROPERTY_W_STR,
                              CONCEPT_E_STR ],
                            
                            [ CORE_CONCEPT_STR,
                              PROPERTY_P_STR,
                              CONCEPT_B_STR,
                              PROPERTY_S_STR,
                              CONCEPT_E_STR,
                              PROPERTY_W_STR,
                              CONCEPT_E_STR ],
                              
                            [ CORE_CONCEPT_STR,
                              PROPERTY_Q_STR,
                              CONCEPT_C_STR,
                              PROPERTY_V_STR,
                              CONCEPT_E_STR,
                              PROPERTY_W_STR,
                              CONCEPT_E_STR ],
                              
                            [ CORE_CONCEPT_STR,
                              PROPERTY_Q_STR,
                              CONCEPT_C_STR,
                              PROPERTY_U_STR,
                              CONCEPT_C_STR ],
                            
                            [ CORE_CONCEPT_STR,
                              PROPERTY_P_STR,
                              CONCEPT_B_STR,
                              PROPERTY_R_STR,
                              CONCEPT_D_STR ] ]
      assert_equal(finder.patterns.list, correct_patterns)
      correct_properties = {  
        [ CORE_CONCEPT_STR, 
          PROPERTY_Q_STR,
          CONCEPT_C_STR ] => SearchEngine::PROPERTY_TYPES[:simple],
        [ CORE_CONCEPT_STR,
          PROPERTY_P_STR,
          CONCEPT_B_STR ] => SearchEngine::PROPERTY_TYPES[:simple],
        [ CONCEPT_C_STR, 
          PROPERTY_T_STR,
          CONCEPT_E_STR ] => SearchEngine::PROPERTY_TYPES[:simple],
        [ CONCEPT_C_STR,
          PROPERTY_V_STR,
          CONCEPT_E_STR ] => SearchEngine::PROPERTY_TYPES[:inverse],
        [ CONCEPT_C_STR,
          PROPERTY_U_STR,
          CONCEPT_C_STR ] => SearchEngine::PROPERTY_TYPES[:reflexive],
        [ CONCEPT_B_STR,
          PROPERTY_S_STR,
          CONCEPT_E_STR ] => SearchEngine::PROPERTY_TYPES[:simple],
        [ CONCEPT_B_STR,
          PROPERTY_R_STR,
          CONCEPT_D_STR ] => SearchEngine::PROPERTY_TYPES[:inverse],
        [ CONCEPT_E_STR,
          PROPERTY_W_STR,
          CONCEPT_E_STR ] => SearchEngine::PROPERTY_TYPES[:reflexive] 
      }                    
      assert_equal(finder.analysis.properties_list, correct_properties)
    end
    
    test "min_property_duplication" do
      abstract_concept, core_concept = setup_adapter(ONTO_NAME[:min_prop_dup])
      finder = OfflineFinder.new(core_concept, PatternsTree)
      finder.start
      assert_equal(finder.patterns.list.size, 2)
    end
    
    test "property_duplication_1" do
      abstract_concept, core_concept = setup_adapter(ONTO_NAME[:prop_dup_1])
      finder = OfflineFinder.new(core_concept, PatternsTree)
      finder.start
      assert_equal(finder.patterns.list.size, 2)
    end
    
    test "property_duplication_2" do
      abstract_concept, core_concept = setup_adapter(ONTO_NAME[:prop_dup_2])
      finder = OfflineFinder.new(core_concept, PatternsTree)
      finder.start
      assert_equal(finder.patterns.list.size, 3)
    end
    
    def assert_equal_leaves(correct_leaves, leaves)
      i=0
      leaves.list.each do |leaf|
        assert_equal(leaf.value, correct_leaves[i])
        i = i.next
      end
    end
    
    def setup_adapter(onto)
      @adapter = Adapter.new( IDENTIFIER,
                              Adapter.local_url(THIS_PATH, onto),
                              ADAPTER_NAME,
                              THIS_PATH)
      SearchEngine.find_a_single_pair_of_rc
    end
     
  end
  
end