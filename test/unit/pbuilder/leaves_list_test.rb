module Pbuilder
  
  require 'test_helper'
  
  class LeavesListTest < ActiveSupport::TestCase
    
    INIT_CONCEPT = "root"
    # Const associated with nodes: NODE_#{letter} and NODE_#{letter}
    TestPHelper.set_node_const(self, "a", "c")
    # Const associated with nodes: EDGE_#{letter} and EDGE_#{letter}
    TestPHelper.set_edge_const(self, "p", "s")
    
    def setup
      @leaves = LeavesList.new(INIT_CONCEPT)
    end
   
    test "init" do
      assert_instance_of(Array, @leaves.list)
    end
    
    test "insert" do
      @leaves.insert(NODE_A, EDGE_P)
      assert_equal(@leaves.list.size, 2)
    end
    
    test "find" do
      node = @leaves.insert(NODE_A, EDGE_P)
      result_1 = @leaves.find_by_concept(NODE_A)
      result_2 = @leaves.find_by_property(EDGE_P)
      assert_equal(result_1, result_2)
      assert_equal(result_1.first, node)
    end
    
    test "concept_substitution_with_a_single_node" do
      root = @leaves.substitute_concept(INIT_CONCEPT, 
                                        NODE_A, 
                                        EDGE_P)
      assert_instance_of(TreeNode, root)
      assert_equal(@leaves.list.size, 1)
      result = @leaves.find_by_concept(NODE_A)
      assert_equal(result.size, 1)
    end
    
    test "concept_substitution_with_multiple_nodes" do
      nodes = { NODE_A => EDGE_P,
                NODE_B => EDGE_Q, 
                NODE_C => EDGE_R }
      @leaves.substitute_concept_using_hash( INIT_CONCEPT,
                                            nodes )
      assert_equal(@leaves.list.size, nodes.length )
    end
    
    test "node_substitution" do
      node = @leaves.insert(NODE_A, EDGE_P)
      @leaves.substitute_node(node, NODE_B, EDGE_Q)
      assert_instance_of(TreeNode, node)
      assert_equal(@leaves.list.size, 2)
      result = @leaves.find_by_concept(NODE_B)
      assert_equal(result.size, 1)                    
    end
    
    test "multiple_subistitution" do
      nodes = { NODE_B => EDGE_R,
                NODE_C => EDGE_S }
      node_1 = @leaves.insert(NODE_A, EDGE_P)
      node_2 = @leaves.insert(NODE_A, EDGE_Q)
      old_nodes = @leaves.substitute_concept_using_hash(NODE_A, 
                                                        nodes)
      assert_equal(old_nodes.size, 2)
      old_nodes.each do |node|
        assert_instance_of(TreeNode, node)
      end
      assert_equal(@leaves.list.size, nodes.length * 2 + 1)
      result = @leaves.find_by_concept(NODE_A)
      assert_equal(result.size, 0)
      result = @leaves.find_by_concept(NODE_B)
      assert_equal(result.size, 2)
      result = @leaves.find_by_concept(NODE_C)
      assert_equal(result.size, 2)
      n = node_1.num_of_direct_children
      assert_equal(n, 2)
    end
    
  end
  
end