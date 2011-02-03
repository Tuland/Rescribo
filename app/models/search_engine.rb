class SearchEngine
  
  A_FORGET_STR = "http://www.siti.disco.unimib.it/cmm/2010/aeria#a-forget"
  A_FORGET_RESOURCE = RDFS::Resource.new(A_FORGET_STR)
  A_GENERALIZE_STR = "http://www.siti.disco.unimib.it/cmm/2010/aeria#a-generalize"
  A_GENERALIZE_RESOURCE = RDFS::Resource.new(A_GENERALIZE_STR)
  
  PROPERTY_TYPES={
    :simple => "s",
    :inverse => "i",
    :reflexive => "r"
  }.freeze
  EDGE_FINDERS={
    :simple => "find_simple_edge",
    :inverse => "find_inverse_edge",
    :reflexive => "find_reflexive_edge"
  }.freeze
  DEFAULT_FINDERS = [ EDGE_FINDERS[:simple], 
                      EDGE_FINDERS[:inverse], 
                      EDGE_FINDERS[:reflexive] ]                    

  # Core and abstract concepts detection
  def find_root_concepts
    query = Query.new.distinct(:s,:o).where(:s, A_GENERALIZE_RESOURCE, :o)
    query.execute do |abstract_concept, core_concept|
       return abstract_concept, core_concept
    end
  end
  
  def find_neighbours(concept, 
                      analysis,
                      patterns, 
                      finders_list = DEFAULT_FINDERS )
    patterns.empty_cache
    # Token bound: property count < 1
    condition = Proc.new do |curr_property|
      ! analysis.properties_list.has_key?(curr_property)
    end
    update_system = Proc.new do | curr_concept, 
                                  curr_property, 
                                  curr_property_type, 
                                  curr_count |
      analysis.update(curr_concept, 
                      curr_property,
                      curr_property_type)
      patterns.update(concept, 
                      curr_property,
                      curr_concept)
    end
    finders_list.each do |finder|
      count = eval "#{finder}(concept, condition, update_system)"  
    end
  end
  
  # See EDGE_FINDERS[:reflexive]
  def find_reflexive_edge(concept,
                          condition,
                          update_system)
    query= Query.new.distinct(:p).where(concept, :p , concept)
    query.execute do |property|
      if condition.call(property)
        update_system.call( concept, 
                            property, 
                            PROPERTY_TYPES[:reflexive])
      end
    end
  end
  
  # See EDGE_FINDERS[:inverse]
  def find_inverse_edge(concept, 
                        condition,
                        update_system)
    query= Query.new.distinct(:s, :p).where(:s, :p , concept)
    query.execute do |concept_s, property|
      if (property != A_GENERALIZE_RESOURCE && 
          property != A_FORGET_RESOURCE &&
          concept_s != concept && 
          condition.call(property))
        count = update_system.call( concept_s, 
                                    property, 
                                    PROPERTY_TYPES[:inverse])
      end
    end
  end
  
  # See EDGE_FINDERS[:simple]
  def find_simple_edge( concept,
                        condition,
                        update_system)
    query = Query.new.distinct(:o, :p).where(concept, :p , :o)
    query.execute do |concept_o, property|
      if (property != RDF::type &&
          concept_o != concept &&
          condition.call(property))
        count = update_system.call( concept_o, 
                                    property, 
                                    PROPERTY_TYPES[:simple])
      end
    end
  end
  
end
