module Pbuilder
  
  class SoftInstance
    
    attr_reader :uri, :id
    
    def initialize(id, uri)
      @id = id
      @uri = uri
    end
    
  end
end