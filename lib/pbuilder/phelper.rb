module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class Phelper
    
    def self.set_concepts_const_for_test(klass, first_letter, last_letter)
      j = 2
      for i in first_letter..last_letter do
        klass.const_set("CONCEPT_#{i.upcase}_STR", "http://www.siti.disco.unimib.it/prova#E#{j}.Concept_#{i.upcase}")
        klass.const_set("CONCEPT_#{i.upcase}_RES", RDFS::Resource.new(eval "#{klass}::CONCEPT_#{i.upcase}_STR"))
        j = j.next
      end
    end
    
    def self.set_properties_const_for_test(klass, first_letter, last_letter)
      j = 1
      for i in first_letter..last_letter do
        klass.const_set("PROPERTY_#{i.upcase}_STR", "http://www.siti.disco.unimib.it/prova#P#{j}.property_#{i}")
        klass.const_set("PROPERTY_#{i.upcase}_RES", RDFS::Resource.new(eval "#{klass}::PROPERTY_#{i.upcase}_STR"))
        j = j.next
      end
    end
    
  end
  
end