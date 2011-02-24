module Pbuilder
  
  class TreeNode
    attr_reader :value, :edge
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +value+ - A string determining the node value
    # * +edge+ - A string determining the edge value (nil if root node)
    def initialize(value, edge = nil)
      @value = value
      @edge = edge
      @children = []
    end
    
    # Link the node to a child
    #  
    # ==== Attributes  
    #  
    # * +value+ - A string determining the node value
    # * +edge+ - A string determining the edge value
    def link(value, edge)
      subtree = TreeNode.new(value, edge)
      @children << subtree
      subtree
    end
    
    # Iterator
    def each
      if @edge.nil?
        yield @value
      else
        yield @value, @edge
      end
      @children.each do |child|
        child.each {|v, e| yield v, e}
      end
    end
    
    def build_patterns(local_list=[], global_list=[])
      if ! @edge.nil?
        local_list << @edge
      end
      local_list << @value
      if @children.empty?
        global_list << local_list
      else
        @children.each do |child|
          new_list = local_list.clone
          child.build_patterns(new_list, 
                               global_list)
        end
      end
      global_list 
    end
    
    # Number of direct children
    def num_of_direct_children
      @children.size
    end
  
    # Print a report  
    def print_report
      if edge.nil?
        self.each {|v| puts "Node: #{v}"}
      else
        self.each {|v, e| puts "Edge: #{e} Node: #{v}"}
      end
    end
    
  end
  
end
