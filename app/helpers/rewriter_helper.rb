module RewriterHelper
  
  include Pbuilder::PHelper
  
  def convert_to_str(resource)
    Converter.rsc_2_str(resource)
  end
  
  def abbreviate(resource)
    Converter.abbreviate(resource)
  end
end
