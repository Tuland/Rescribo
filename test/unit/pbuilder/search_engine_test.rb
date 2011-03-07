module Pbuilder
  
  require 'test_helper'
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class SearchEngineTest < ActiveSupport::TestCase
    
    THIS_PATH = File.dirname(File.expand_path(__FILE__)) + "/"
    IDENTIFIER = 1234
    ONTO_NAME = {
      :minimal => "minimal_sample.owl",
      :simple_edge => "simple_edge_sample.owl",
      :inverse_edge => "inverse_edge_sample.owl",  
      :reflexive_edge => "reflexive_edge_sample.owl",
      :s_i_r_edges => "s_i_r_edges_sample.owl",
      :min_prop_dup => "minimal_property_duplication.owl",
      :inverse_property_1 => "inverse_property_1.owl",
      :inverse_property_2 => "inverse_property_2.owl",
      :inverse_property_3 => "inverse_property_3.owl"
    }.freeze
    ADAPTER_NAME = "name"
    FILE_PATH = Adapter.personal_persistence_file(ADAPTER_NAME,
                                                  IDENTIFIER,
                                                  THIS_PATH)
    # Root concepts: ABSTRACT_CONCEPT_STR, ABSTRACT_CONCEPT_RES, CORE_CONCEPT_STR and CORE_CONCEPT_RES                                              
    TestPHelper.set_rootc_const_for_test(self)
    # Const associated with properties: PROPERTY_#{letter}_STR and PROPERTY_#{letter}_RES
    TestPHelper.set_properties_const_for_test(self, "p", "r")
    # Const associated with concepts: CONCEPT_#{letter}_STR and CONCEPT_#{letter}_RES
    TestPHelper.set_concepts_const_for_test(self, "b", "c")
                
    def setup
      Adapter.purge(IDENTIFIER,
                    THIS_PATH)
    end
    
    def teardown
      if ! @adapter.nil?
        @adapter.close
      end
    end
                
    test "root_concepts" do
      @adapter = default_adapter(ONTO_NAME[:minimal])
      abstract_concept, core_concept = SearchEngine.find_a_single_pair_of_rc
      assert_equal(ABSTRACT_CONCEPT_RES, abstract_concept)
      assert_equal(CORE_CONCEPT_RES, core_concept)
    end
    
    test "simple_edge" do
      @adapter = default_adapter(ONTO_NAME[:simple_edge])
      abstract_concept, core_concept = SearchEngine.find_a_single_pair_of_rc
      edge = Array[core_concept]
      update_system = minimal_update_system(edge)
      condition = minimal_condition
      SearchEngine.find_simple_edge( core_concept,
                                     condition,
                                     update_system)
      correct_edge = [CORE_CONCEPT_RES, 
                      PROPERTY_P_RES,
                      CONCEPT_B_RES ]
      assert_equal(edge, correct_edge)
    end
    
    test "inverse_edge" do
      @adapter = default_adapter(ONTO_NAME[:inverse_edge])
      abstract_concept, core_concept = SearchEngine.find_a_single_pair_of_rc
      edge = Array[core_concept]
      update_system = minimal_update_system(edge)
      condition = minimal_condition
      SearchEngine.find_inverse_edge( core_concept,
                                        condition,
                                        update_system)
      correct_edge = [CORE_CONCEPT_RES, 
                      PROPERTY_P_RES,
                      CONCEPT_B_RES ]
      assert_equal(edge, correct_edge)
    end
    
    test "reflexive_edge" do
      @adapter = default_adapter(ONTO_NAME[:reflexive_edge])
      abstract_concept, core_concept = SearchEngine.find_a_single_pair_of_rc
      edge = Array[core_concept]
      update_system = minimal_update_system(edge)
      condition = minimal_condition
      SearchEngine.find_reflexive_edge( core_concept,
                                        condition,
                                        update_system)
      correct_edge = [CORE_CONCEPT_RES, 
                      PROPERTY_P_RES,
                      CORE_CONCEPT_RES ]
      assert_equal(edge, correct_edge)
    end

    test "find_neighbours" do
      @adapter = default_adapter(ONTO_NAME[:s_i_r_edges])
      abstract_concept, core_concept = SearchEngine.find_a_single_pair_of_rc
      analysis = PatternsAnalysis.new(core_concept)
      patterns = SimpleStorage.new(core_concept)
      SearchEngine.find_neighbours( core_concept, 
                                    analysis,
                                    patterns )
      correct_patterns = [[CORE_CONCEPT_STR, PROPERTY_P_STR, CONCEPT_B_STR],
                          [CORE_CONCEPT_STR, PROPERTY_Q_STR, CONCEPT_C_STR],
                          [CORE_CONCEPT_STR, PROPERTY_R_STR, CORE_CONCEPT_STR]]
      assert_equal(patterns.list, correct_patterns)
    end
    
    test "property_duplication" do
      @adapter = default_adapter(ONTO_NAME[:min_prop_dup])
      abstract_concept, core_concept = SearchEngine.find_a_single_pair_of_rc
      analysis = PatternsAnalysis.new(core_concept)
      patterns = SimpleStorage.new(core_concept)
      SearchEngine.find_neighbours( core_concept, 
                                    analysis,
                                    patterns )
      assert_equal(patterns.list.size, 2)
    end

    test "inverse_property_1" do
      correct_pattern = [ CORE_CONCEPT_STR, 
                          PROPERTY_P_STR,
                          CONCEPT_B_STR ]
      @adapter = default_adapter(ONTO_NAME[:inverse_property_1])
      abstract_concept, core_concept = SearchEngine.find_a_single_pair_of_rc
      analysis = PatternsAnalysis.new(core_concept)
      patterns = SimpleStorage.new(core_concept)
      SearchEngine.find_neighbours( core_concept, 
                                    analysis,
                                    patterns )
      assert_equal(patterns.list, [correct_pattern])
    end
    
    test "inverse_property_2" do
      correct_pattern = [ CORE_CONCEPT_STR, 
                          PROPERTY_P_STR,
                          CONCEPT_B_STR ]
      @adapter = default_adapter(ONTO_NAME[:inverse_property_2])
      abstract_concept, core_concept = SearchEngine.find_a_single_pair_of_rc
      analysis = PatternsAnalysis.new(core_concept)
      patterns = SimpleStorage.new(core_concept)
      SearchEngine.find_neighbours( core_concept, 
                                    analysis,
                                    patterns )
      assert_equal(patterns.list, [correct_pattern])
    end
    
    # TODO: Take in consideration more then one inverse property

    private
    
    def minimal_condition
      condition = Proc.new { true }
    end
    
    def minimal_update_system(edge)
      update_system = Proc.new do | curr_concept, 
                                    curr_property, 
                                    curr_property_type |
        edge.push(curr_property,
                  curr_concept )
      end
    end
    
    def default_adapter(onto_name)
      Adapter.new(IDENTIFIER,
                  Adapter.local_url(THIS_PATH, onto_name),
                  ADAPTER_NAME,
                  THIS_PATH)
    end
  end
  
end