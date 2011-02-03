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
  
  
end
