module Pbuilder
  
  require 'test_helper'
  
  class PatternsTreeTest < ActiveSupport::TestCase
    
    INIT_CONCEPT = "Root"
    # Const associated with nodes: NODE_#{letter} and NODE_#{letter}
    TestPHelper.set_node_const(self, "a", "c")
    # Const associated with nodes: EDGE_#{letter} and EDGE_#{letter}
    TestPHelper.set_edge_const(self, "p", "s")
  
    def teardown
      @patterns.empty_temp
    end
  
  
    test "init" do
      @patterns = PatternsTree.new(INIT_CONCEPT)
      assert_instance_of(TreeNode, @patterns.root)
    end
  
    test "init_concept" do
      @patterns = PatternsTree.new(INIT_CONCEPT)
      assert_equal(INIT_CONCEPT, @patterns.root.value)
    end
  
    test "single_update" do
      @patterns = PatternsTree.new(INIT_CONCEPT)
      @patterns.import(NODE_A, EDGE_P)
      @patterns.update(INIT_CONCEPT)
      correct_nodes = [ [INIT_CONCEPT, nil],
                          [NODE_A, EDGE_P ] ]
      assert_equal_into_tree(correct_nodes, @patterns.root)
    end
  
    test "double_update" do
      @patterns = PatternsTree.new(INIT_CONCEPT)
      @patterns.import(NODE_A, EDGE_P)
      @patterns.import(NODE_B, EDGE_Q)
      @patterns.update(INIT_CONCEPT)
      correct_nodes = [ [INIT_CONCEPT, nil],
                           [NODE_A, EDGE_P],
                           [NODE_B, EDGE_Q] ]
      assert_equal_into_tree(correct_nodes, @patterns.root)
    end
 
    test "double_update_with_double_base_concept" do
      @patterns = PatternsTree.new(INIT_CONCEPT)
      @patterns.import(NODE_A, EDGE_P)
      @patterns.import(NODE_B, EDGE_Q)
      @patterns.update(INIT_CONCEPT)
      @patterns.import(NODE_A, EDGE_Q)
      @patterns.update(NODE_B)
      @patterns.import(NODE_B, EDGE_P)
      @patterns.update(NODE_A)
      correct_nodes = [ [INIT_CONCEPT, nil],
                           [NODE_A, EDGE_P],
                           [NODE_B, EDGE_P],
                           [NODE_B, EDGE_Q],
                           [NODE_A, EDGE_Q],
                           [NODE_B, EDGE_P] ]
      assert_equal_into_tree(correct_nodes, @patterns.root)
    end
 
    test "importation_with_identical_nodes" do
      @patterns = PatternsTree.new(INIT_CONCEPT)
      @patterns.import(NODE_A, EDGE_P)
      @patterns.import(NODE_A, EDGE_P)
      @patterns.update(INIT_CONCEPT)
      correct_nodes = [ [INIT_CONCEPT, nil],
                           [NODE_A, EDGE_P],
                           [NODE_A, EDGE_P] ]
     assert_equal_into_tree(correct_nodes, @patterns.root)                    
    end

    test "update_without_import" do
      @patterns = PatternsTree.new(INIT_CONCEPT)
      @patterns.update(INIT_CONCEPT)
      assert_equal(INIT_CONCEPT, @patterns.root.value)
    end
    
    def assert_equal_into_tree(correct_nodes, root)
      i = 0
      root.each do |value, edge|
        j = 0
        assert_equal(correct_nodes[i][j], value)
        j = j.next
        assert_equal(correct_nodes[i][j], edge)
        i = i.next
      end
    end
    
    
  end
  
end
