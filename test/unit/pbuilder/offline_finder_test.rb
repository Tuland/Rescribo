module Pbuilder
  
  require 'test_helper'
  
  class OfflineFinderTest < ActiveSupport::TestCase
    THIS_PATH = File.dirname(File.expand_path(__FILE__)) + "/"
    IDENTIFIER = 1234
    ONTO_NAME = {
      :semi_cycle => "semi_cycle_sample.owl",
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
    
    test "semi_cycle" do
      @adapter = Adapter.new( IDENTIFIER,
                              Adapter.local_url(THIS_PATH, ONTO_NAME[:semi_cycle]),
                              ADAPTER_NAME,
                              THIS_PATH)
      abstract_concept, core_concept = Pbuilder::SearchEngine.find_root_concepts
      finder = Pbuilder::OfflineFinder.new(core_concept, SimpleStorage)
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
        PROPERTY_Q_STR => SearchEngine::PROPERTY_TYPES[:simple],
        PROPERTY_P_STR => SearchEngine::PROPERTY_TYPES[:simple],
        PROPERTY_T_STR => SearchEngine::PROPERTY_TYPES[:simple],
        PROPERTY_V_STR => SearchEngine::PROPERTY_TYPES[:inverse],
        PROPERTY_U_STR => SearchEngine::PROPERTY_TYPES[:reflexive],
        PROPERTY_S_STR => SearchEngine::PROPERTY_TYPES[:simple],
        PROPERTY_R_STR => SearchEngine::PROPERTY_TYPES[:inverse],
        PROPERTY_W_STR => SearchEngine::PROPERTY_TYPES[:reflexive] 
      }                    
      assert_equal(finder.analysis.properties_list, correct_properties)
    end
     
  end
  
end