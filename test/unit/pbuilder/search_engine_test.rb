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
      :s_i_r_edges => "s_i_r_edges_sample.owl" 
    }.freeze
    ADAPTER_NAME = "name"
    FILE_PATH = Adapter.personal_persistence_file(ADAPTER_NAME,
                                                  IDENTIFIER,
                                                  THIS_PATH)
    # Root concepts                                              
    ABSTRACT_CONCEPT_STR = "http://www.siti.disco.unimib.it/prova#A1.AbstractConcept"
    ABSTRACT_CONCEPT_RES = RDFS::Resource.new(ABSTRACT_CONCEPT_STR)
    CORE_CONCEPT_STR = "http://www.siti.disco.unimib.it/prova#E1.Concept_A_Core"
    CORE_CONCEPT_RES = RDFS::Resource.new(CORE_CONCEPT_STR)
    # Properties
    PROPERTY_P_STR = "http://www.siti.disco.unimib.it/prova#P1.property_p"
    PROPERTY_P_RES = RDFS::Resource.new(PROPERTY_P_STR)
    PROPERTY_Q_STR = "http://www.siti.disco.unimib.it/prova#P2.property_q"
    PROPERTY_Q_RES = RDFS::Resource.new(PROPERTY_Q_STR)
    PROPERTY_R_STR = "http://www.siti.disco.unimib.it/prova#P3.property_r"
    PROPERTY_R_RES = RDFS::Resource.new(PROPERTY_R_STR)
    #Concepts
    CONCEPT_B_STR = "http://www.siti.disco.unimib.it/prova#E2.Concept_B"
    CONCEPT_B_RES = RDFS::Resource.new(CONCEPT_B_STR)
    CONCEPT_C_STR = "http://www.siti.disco.unimib.it/prova#E3.Concept_C"
    CONCEPT_C_RES = RDFS::Resource.new(CONCEPT_C_STR)
                
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
      abstract_concept, core_concept = SearchEngine.find_root_concepts
      assert_equal(ABSTRACT_CONCEPT_RES, abstract_concept)
      assert_equal(CORE_CONCEPT_RES, core_concept)
    end
    
    test "simple_edge" do
      @adapter = default_adapter(ONTO_NAME[:simple_edge])
      abstract_concept, core_concept = SearchEngine.find_root_concepts
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
      abstract_concept, core_concept = SearchEngine.find_root_concepts
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
      abstract_concept, core_concept = SearchEngine.find_root_concepts
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
      abstract_concept, core_concept = SearchEngine.find_root_concepts
      analysis = PatternsAnalysis.new(core_concept)
      patterns = PatternsStorage.new(core_concept)
      SearchEngine.find_neighbours( core_concept, 
                                    analysis,
                                    patterns )
      correct_patterns = [[CORE_CONCEPT_RES, PROPERTY_P_RES, CONCEPT_B_RES],
                          [CORE_CONCEPT_RES, PROPERTY_Q_RES, CONCEPT_C_RES],
                          [CORE_CONCEPT_RES, PROPERTY_R_RES, CORE_CONCEPT_RES]]
      assert_equal(patterns.list, correct_patterns)
    end

    private
    
    def minimal_condition
      condition = Proc.new { true }
    end
    
    def minimal_update_system(statement)
      update_system = Proc.new do | curr_concept, 
                                    curr_property, 
                                    curr_property_type |
        statement.push( curr_property,
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