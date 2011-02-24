module Pbuilder

  require 'test_helper'
  
  class TreeNodeTest < ActiveSupport::TestCase
    
    ROOT_NODE = "root"
    # Const associated with nodes: NODE_#{letter} and NODE_#{letter}
    TestPHelper.set_node_const(self, "a", "c")
    # Const associated with nodes: EDGE_#{letter} and EDGE_#{letter}
    TestPHelper.set_edge_const(self, "p", "r")
    
    def setup
      @root_node = TreeNode.new(ROOT_NODE)
      @children = { NODE_A => EDGE_P, 
                    NODE_B => EDGE_Q,
                    NODE_C => EDGE_R }
      @nodes = @children.clone
      @nodes[ROOT_NODE] = nil
    end
    
    test "root_node" do
      # Tree mode
      assert_equal(ROOT_NODE, @root_node.value)
      assert_equal(nil, @root_node.edge)
      # List mode
      assert_equal([[ROOT_NODE]], @root_node.build_patterns)
    end
    
    test "multiple_children" do   
      ## Build Tree
      @children.each do |value, edge|
        @root_node.link(value, edge)
      end
      ## Assertions
      # Tree mode
      @root_node.each do |value, edge|
        assert_equal(@nodes[value], edge)
        assert_equal(@nodes.index(edge), value) 
      end
      # List mode
      correct_patterns = [[ ROOT_NODE, EDGE_P, NODE_A ],
                          [ ROOT_NODE, EDGE_Q, NODE_B ],
                          [ ROOT_NODE, EDGE_R, NODE_C ]]
      assert_equal(correct_patterns, @root_node.build_patterns)
    end
    
    test "long_path" do
      ## Build Tree
      node = @root_node
      @children.each do |value, edge|
        node = node.link(value, edge)
      end
      ## Assertions
      # Tree mode
      @root_node.each do |value, edge|
        assert_equal(@nodes[value], edge)
        assert_equal(@nodes.index(edge), value) 
      end
      # List mode
      correct_patterns = [[ ROOT_NODE, 
                            EDGE_P, 
                            NODE_A,
                            EDGE_Q,
                            NODE_B,
                            EDGE_R, 
                            NODE_C ]]
      assert_equal(correct_patterns, @root_node.build_patterns)
    end
    
  end
  
end
  
  