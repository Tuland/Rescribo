module PatternsBuilderHelper
  
  def tree_to_html_list(root)
    global_str = "<ul>"
    global_str = root.inspect_recursively(global_str, 0, 
                                          { :starting_item_tag => "<li class='child'>",
                                            :ending_item_tag => "</li>\n",
                                            :starting_children_tag => "\n<ul>",
                                            :ending_children_tag => "</ul>\n",
                                            :separator => "<image src='/images/tree_bullet_s_arrow.gif' alt='arrow' />",
                                            :starting_edge_tag => "<span class='edge'>",
                                            :ending_edge_tag => "</span>" ,
                                            :starting_value_tag => "<span class='value'>",
                                            :ending_value_tag => "</span>" } )
    global_str << "</ul>"
    global_str
  end
  
end
