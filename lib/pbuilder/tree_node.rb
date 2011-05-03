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
    
    # Returns a string containing the representation of the tree
    #  
    # ==== Attributes  
    #  
    # * +global_str+ - A string to append items
    # * +depth+ - Minimum depth (Integer)
    # * +options+ - An hash determining options
    #
    # ==== Options
    #
    # * +:starting_item_tag+ - List Item tag (opening). HTML example: <li>
    # * +:ending_item_tag+ - ist Item tag (closing).HTML example: </li>
    # * +:starting_separator_tag+ - Separation between 'edge' and 'value'. Example: -
    # * +:starting_edge_tag+ - tag for 'edge' (openig). HTML example: <span class="edge">
    # * +:ending_edge_tag+ - tag for 'edge' (closing).HTML example: </span>
    # * +:starting_value_tag+ - tag for 'value' (openig). HTML example: <span class="value">
    # * +:ending_value_tag+ - tag for 'value' (closing).HTML example: </span>
    # * +:starting_children_tag+ - List tag (opening). HTML example: <ul>
    # * +:ending_children_tag+ - List tag (closing).HTML example: </ul>
    
    def inspect_recursively(global_str, depth = nil, options = {})
      if options[:starting_item_tag]
        global_str << options[:starting_item_tag]
      end
      if ! depth.nil?
        global_str << "#{depth} "
      end
      if @edge
        if options[:starting_edge_tag]
          global_str << options[:starting_edge_tag]
        end
        global_str << @edge
        if options[:ending_edge_tag]
          global_str << options[:ending_edge_tag]
        end
        if options[:separator]
          global_str << options[:separator]
        end
      end
      if options[:starting_value_tag]
        global_str << options[:starting_value_tag]
      end
      global_str << @value
      if options[:ending_value_tag]
        options[:ending_value_tag]
      end
      if options[:ending_item_tag]
        global_str << options[:ending_item_tag]
      end
      if ! @children.nil?
        if options[:starting_children_tag]
          global_str <<  options[:starting_children_tag]
        end
        depth = depth.next
        @children.each do |child|
          global_str = child.inspect_recursively(global_str, depth,options)
        end
        if options[:ending_children_tag]
          global_str <<  options[:ending_children_tag]
        end
      end
      global_str
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
    
    # Build a pattern list exploring the tree recursively.
    # Depth-first search
    # * +local_list+ - A temporary local list (needed by recursion)
    # * +global_list+ - A global list to return
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
