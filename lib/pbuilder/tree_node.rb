module Pbuilder
  
  class TreeNode
    attr_reader :value, :edge
    
    # Init
    #  
    # ==== Attributes  
    #  
    # * +init_concept+ - An initial concept to include
    def initialize(value, edge = nil)
      @value = value
      @edge = edge
      @children = []
    end
    
    def link(value, edge)
      subtree = TreeNode.new(value, edge)
      @children << subtree
      subtree
    end
    
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
  
    # Print a report  
    #  
    # ==== Attributes  
    #  
    # * +count+ - An integer determining the algorithm step
    def print_report
      if edge.nil?
        self.each {|v| puts "Node: #{v}"}
      else
        self.each {|v, e| puts "Edge: #{e} Node: #{v}"}
      end
    end
    
  end
  
end
