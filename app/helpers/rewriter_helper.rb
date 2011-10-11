module RewriterHelper
  
  include Pbuilder::PHelper
  
  def convert_to_str(resource)
    Converter.rsc_2_str(resource)
  end
  
  def abbreviate(resource)
    Converter.abbreviate(resource)
  end
  
  def children_list(level, children)
    str = ""
    str << "<ul>\n"
    children.each do |child|
      str << "\t<li class='child' id='li_#{child.id.to_s}'>\n"
      str << "\t\t<span class='edge'>#{h(abbreviate(child.property.uri))}</span>"
      str << "\t\t<image src='/images/tree_bullet_s_arrow.gif' alt='arrow' />"
      str << "\t\t<span class='instance_tag'>#{level.to_s}</span>\n"
      str << "\t\t<span class='value' id='#{child.id.to_s}'> #{h(abbreviate(child.uri))}</span>\n"
      str << "\t</li>\n"
    end
    str << "</ul>\n"
    str
  end
  
  def li_concept(n_pattern, level, concept)
    str = ""
    str << "<li id='li_concept_#{n_pattern}_#{level}'>"
    str << "\t<span class='concept_tag'>CONCEPT #{level}</span>"
    str << "\t<span id='concept_#{n_pattern}_#{level}'>#{h(abbreviate(concept))}</span>"
    str << "</li>"
  end
  
end
