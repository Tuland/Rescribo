module RewriterHelper
  
  include Pbuilder::PHelper
  
  def convert_to_str(resource)
    Converter.src_2_str(resource)
  end
  
  def abbreviate(resource)
    Converter.abbreviate(resource)
  end
end
