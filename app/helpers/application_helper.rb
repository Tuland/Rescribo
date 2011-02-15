# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  class Integer
    def odd
        self & 1 != 0
     end
    def even
        self & 1 == 0
    end
  end
  
  def onto_loader
    page.visual_effect(:squish, "onto_loader")
    page.delay(1) do
      page.replace_html 'ontology_info', "#{@url_str}"
      page.visual_effect(:morph, "ontology_info", :style => "{background: '#CCFF66'}" )
      page.delay(1) do
        page.insert_html(:after, "ontology_info", :partial => "result")
        page.visual_effect(:highlight, "result")
        page.visual_effect(:scrollTo, "result")
      end
    end
  end
  
  
end
