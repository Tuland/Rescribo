module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class Phelper
    
    # Set constant associated with root concept for +klass+
    # (testing mode)
    # 
    # ==== Attributes  
    #  
    # * +klass+ - A Class to extend
    def self.set_rootc_const_for_test(klass)
      klass.const_set("ABSTRACT_CONCEPT_STR", "http://www.siti.disco.unimib.it/prova#A1.AbstractConcept")
      klass.const_set("ABSTRACT_CONCEPT_RES", RDFS::Resource.new(eval "#{klass}::ABSTRACT_CONCEPT_STR"))
      klass.const_set("CORE_CONCEPT_STR", "http://www.siti.disco.unimib.it/prova#E1.Concept_A_Core")
      klass.const_set("CORE_CONCEPT_RES", RDFS::Resource.new(eval "#{klass}::CORE_CONCEPT_STR"))
    end
    
    # Set constant associated with properties for +klass+
    # (testing mode)
    #  
    # ==== Attributes  
    #  
    # * +klass+ - A Class to extend
    # * +first_letter+ - The first letter that itentified the first constant
    # * +last_letter+ - The last letter that itentified the last constant
    def self.set_concepts_const_for_test(klass, first_letter, last_letter)
      j = 2
      for i in first_letter..last_letter do
        klass.const_set("CONCEPT_#{i.upcase}_STR", "http://www.siti.disco.unimib.it/prova#E#{j}.Concept_#{i.upcase}")
        klass.const_set("CONCEPT_#{i.upcase}_RES", RDFS::Resource.new(eval "#{klass}::CONCEPT_#{i.upcase}_STR"))
        j = j.next
      end
    end
    
    # Set constant associated with concept for +klass+
    # (testing mode)
    # #  
    # ==== Attributes  
    #  
    # * +klass+ - A Class to extend
    # * +first_letter+ - The first letter that itentified the first constant
    # * +last_letter+ - The last letter that itentified the last constant
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