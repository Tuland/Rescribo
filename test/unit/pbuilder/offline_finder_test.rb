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
    Phelper.set_rootc_const_for_test(self)
    # Const associated with properties: PROPERTY_#{letter}_STR and PROPERTY_#{letter}_RES
    Phelper.set_properties_const_for_test(self, "p", "w")
    # Const associated with concepts: CONCEPT_#{letter}_STR and CONCEPT_#{letter}_RES
    Phelper.set_concepts_const_for_test(self, "b", "e")
    
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
      finder = Pbuilder::OfflineFinder.new(core_concept)
      finder.start
      correct_patterns = [  [ CORE_CONCEPT_RES,
                              PROPERTY_Q_RES,
                              CONCEPT_C_RES,
                              PROPERTY_T_RES,
                              CONCEPT_E_RES,
                              PROPERTY_W_RES,
                              CONCEPT_E_RES ],
                            
                            [ CORE_CONCEPT_RES,
                              PROPERTY_P_RES,
                              CONCEPT_B_RES,
                              PROPERTY_S_RES,
                              CONCEPT_E_RES,
                              PROPERTY_W_RES,
                              CONCEPT_E_RES ],
                              
                            [ CORE_CONCEPT_RES,
                              PROPERTY_Q_RES,
                              CONCEPT_C_RES,
                              PROPERTY_V_RES,
                              CONCEPT_E_RES,
                              PROPERTY_W_RES,
                              CONCEPT_E_RES ],
                              
                            [ CORE_CONCEPT_RES,
                              PROPERTY_Q_RES,
                              CONCEPT_C_RES,
                              PROPERTY_U_RES,
                              CONCEPT_C_RES ],
                            
                            [ CORE_CONCEPT_RES,
                              PROPERTY_P_RES,
                              CONCEPT_B_RES,
                              PROPERTY_R_RES,
                              CONCEPT_D_RES ] ]
      assert_equal(finder.patterns.list, correct_patterns)
      correct_properties = {  
        PROPERTY_Q_RES => SearchEngine::PROPERTY_TYPES[:simple],
        PROPERTY_P_RES => SearchEngine::PROPERTY_TYPES[:simple],
        PROPERTY_T_RES => SearchEngine::PROPERTY_TYPES[:simple],
        PROPERTY_V_RES => SearchEngine::PROPERTY_TYPES[:inverse],
        PROPERTY_U_RES => SearchEngine::PROPERTY_TYPES[:reflexive],
        PROPERTY_S_RES => SearchEngine::PROPERTY_TYPES[:simple],
        PROPERTY_R_RES => SearchEngine::PROPERTY_TYPES[:inverse],
        PROPERTY_W_RES => SearchEngine::PROPERTY_TYPES[:reflexive] 
      }                    
      assert_equal(finder.analysis.properties_list, correct_properties)
    end
     
  end
  
end