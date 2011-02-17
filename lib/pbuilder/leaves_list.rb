module Pbuilder
  
  class LeavesList
    
    # * +list+ - A list that includes the leaves
    attr_reader :list
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +init_concept+ - An initial concept (string) to include
    def initialize(concept=nil)
      if concept.nil?
        @list = Array.new
      else
        @list = Array[TreeNode.new(concept)]
      end
    end
    
    # Create a node and insert it into the list
    #  
    # ==== Attributes  
    #  
    # * +concept+ - A string determining the concept
    # * +property+ - A string determining the property
    def insert(concept, property=nil)
      node = TreeNode.new(concept, property)
      @list << node
      node 
    end
    
    # Find nodes by concept
    #  
    # ==== Attributes  
    #  
    # * +concept+ - A string determining the concept  
    def find_by_concept(concept)
      find{ |node|  node.value == concept }
    end
    
    # Find nodes by concept
    #  
    # ==== Attributes  
    #  
    # * +property+ - A string determining the property  
    def find_by_property(property)
      find{ |node|  node.edge == property }
    end
    
    # Substitute a concept for another
    #  
    # ==== Attributes  
    #  
    # * +prev_concept+ - A string determining the concept to substite
    # * +concept+ - A string determining the new concept     
    # * +property+ - A string determining the property (edge between +prev_conept+ and +concept+)
    def substitute_concept(prev_concept, concept, property)
      node_hash = { concept => property }
      substitute_concept_using_hash(prev_concept, node_hash).first
    end
    
    # Substitute a node for another one that includes a new concept
    #  
    # ==== Attributes  
    #  
    # * +node+ - A node to substite
    # * +concept+ - A string determining the new concept     
    # * +property+ - A string determining the property 
    def substitute_node(node, concept, property)
      node_hash = { concept => property }
      substitute_node_using_hash(node, node_hash).first
    end
    
    # Substitute a concept for others that include new concepts
    #  
    # ==== Attributes  
    #  
    # * +prev_concept+ - A string determining the concept to substite
    # * +nodes_hash+ - An hash that include data nodes to perferfom the substitution
    def substitute_concept_using_hash(prev_concept, nodes_hash)
      substitute_using_hash( nodes_hash, 
                            :find_concept_for_editing, 
                            prev_concept)
    end
    
    # Substitute a node for others
    #  
    # ==== Attributes  
    #  
    # * +node+ - A node to substite
    # * +nodes_hash+ - An hash that include data nodes to perferfom the substitution
    def substitute_node_using_hash(node, nodes_hash)
      substitute_using_hash( nodes_hash, 
                            :find_node_for_editing, 
                            node)
    end
    
    private
    
    # Find a node using a cloned list for editing the original list
    # The block perform operation on finded nodes
    #  
    # ==== Attributes  
    #  
    # * +node+ - A node to find
    #
    # ==== Examples
    #
    # find_concept_for_editing(concept) {|node| puts node.value}
    def find_node_for_editing(node)
      loop_cloned_list do |n|
        if n == node
          yield(n)
        end
      end
    end
    
    # Find a node by concept using a cloned list for editing the original list
    # The block perform operation on finded nodes
    #  
    # ==== Attributes  
    #  
    # * +concept+ - A string determining the concept to find
    #
    # ==== Examples
    #
    # find_concept_for_editing(concept) {|node| puts node.value}
    def find_concept_for_editing(concept)
      loop_cloned_list do |n|
        if n.value == concept
          yield(n)
        end
      end
    end
    
    # Perform substitution using an hash that includes data nodes
    #
    # ==== Attributes  
    #  
    # * +nodes_hash+ - An hash that include data nodes to perferfom the substitution
    # * +finder+ - A string determining the method to search
    # * +args+ - Arguments related to +finder+
    def substitute_using_hash(nodes_hash, finder, *args)
      old_nodes = []
      self.send (finder, *args) do |node|
        old_nodes << node
        nodes_hash.each do |value, edge|
          leaf_node = node.link(value, edge)
          @list.delete(node)
          @list << leaf_node
        end
      end
      old_nodes
    end
    
    # Create a clone list and iterate it
    # The block perform operation on finded nodes
    def loop_cloned_list
      cloned_list = @list.clone
      cloned_list.each do |node|
        yield(node)
      end
    end
    
    # Find item into the list
    # The block define the search condition
    def find
      nodes_list = []
      @list.each do |node|
        if yield(node)
          nodes_list << node
        end
      end
      nodes_list
    end
    
  end
    
end