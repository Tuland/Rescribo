module Pbuilder
  
  require 'test_helper'
  
  class SimpleStorageTest < ActiveSupport::TestCase
  
    INIT_CONCEPT = "Root"
    # Const associated with nodes: NODE_#{letter} and NODE_#{letter}
    TestPHelper.set_node_const(self, "a", "c")
    # Const associated with nodes: EDGE_#{letter} and EDGE_#{letter}
    TestPHelper.set_edge_const(self, "p", "s")
  
    def teardown
      @patterns.empty_temp
    end
  
  
    test "init" do
      @patterns = SimpleStorage.new(INIT_CONCEPT)
      assert_instance_of(Array, @patterns.list)
    end
  
    test "init_concept" do
      @patterns = SimpleStorage.new(INIT_CONCEPT)
      assert_equal INIT_CONCEPT, @patterns.list.first.first
    end
  
    test "nil_init_concept" do
      @patterns = SimpleStorage.new()
      assert_nil(@patterns.list.first)
    end
  
    test "single_update" do
      @patterns = SimpleStorage.new(INIT_CONCEPT)
      @patterns.import(NODE_A, EDGE_P)
      @patterns.update(INIT_CONCEPT)
      correct_pattern = [INIT_CONCEPT, EDGE_P, NODE_A]
      assert_equal(correct_pattern, @patterns.list.first)
    end
  
    test "double_update" do
      @patterns = SimpleStorage.new(INIT_CONCEPT)
      @patterns.import(NODE_A, EDGE_P)
      @patterns.import(NODE_B, EDGE_Q)
      @patterns.update(INIT_CONCEPT)
      correct_patterns = [ [INIT_CONCEPT, EDGE_P, NODE_A],
                           [INIT_CONCEPT, EDGE_Q, NODE_B] ]
      assert_equal(correct_patterns, @patterns.list)
    end
  
    test "double_update_with_double_base_concept" do
      @patterns = SimpleStorage.new(INIT_CONCEPT)
      @patterns.import(NODE_A, EDGE_P)
      @patterns.import(NODE_B, EDGE_Q)
      @patterns.update(INIT_CONCEPT)
      @patterns.import(NODE_A, EDGE_Q)
      @patterns.update(NODE_B)
      @patterns.import(NODE_B, EDGE_P)
      @patterns.update(NODE_A)
      correct_patterns = [ [  INIT_CONCEPT, 
                              EDGE_P, 
                              NODE_A,
                              EDGE_P,
                              NODE_B ],
                              
                           [  INIT_CONCEPT, 
                              EDGE_Q, 
                              NODE_B, 
                              EDGE_Q, 
                              NODE_A,
                              EDGE_P,
                              NODE_B] ]
      assert_equal(correct_patterns, @patterns.list)
    end
    
    test "importation_with_identical_nodes" do
      @patterns = SimpleStorage.new(INIT_CONCEPT)
      @patterns.import(NODE_A, EDGE_P)
      @patterns.import(NODE_A, EDGE_P)
      @patterns.update(INIT_CONCEPT)
      correct_patterns = [ [  INIT_CONCEPT,
                              EDGE_P,
                              NODE_A ],
                              
                            [ INIT_CONCEPT,
                              EDGE_P,
                              NODE_A ] ]
      assert_equal(correct_patterns, @patterns.list)                    
    end
    
    test "update_without_import" do
      @patterns = SimpleStorage.new(INIT_CONCEPT)
      @patterns.update(INIT_CONCEPT)
      assert_equal([[ INIT_CONCEPT ]], @patterns.list)
    end
    
  end
end
