module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class InstancesExplorer
    
    attr_reader :core_instances
    
    def initialize(patterns, core_concept, constraint, &action)
      @action = action
      core_concept_rsc = RDFS::Resource.new(core_concept) 
      @patterns = patterns 
      @query = Query
      q = @query.new.extend(Pbuilder::Query)
      q = q.search_by_concept(core_concept_rsc, constraint)
      @core_instances = []
      c_instances = []
      q.execute do |i|
        c_instances << i
      end
      for j in 0...patterns.size
        list = Array.new
        c_instances.each do |c|
          list << @action.call(c, j, 0, nil, nil)
        end
        @core_instances << list
      end
      
    end
    
    def scan_patterns
      p_count = 0
      @patterns.each do |pattern|
        puts "----- NUOVO PATTERN"
        level = 0
        curr_instances = []
        # UTILIZZARE CHILDREN DI ACTS_AS_TREE
        curr_instances = @core_instances[p_count]
        pr = PatternReader.new(pattern[1..-1])
        until pr.halted?
          prop, concept = pr.default_next_concept_and_prop
          level = level.next
          puts "----- prop: " + prop.to_s
          puts "----- concept: " + concept.to_s
          next_instances = []
          curr_instances.each do |c_instance|
            # recuperare dal DB l'ID di c_instance tramite NOME, N_PATTERN, LEVEL, PROPERTY_ID
            puts "---- instance: " + c_instance.uri.to_s
            q = @query.new.extend(Pbuilder::Query)
            q = q.search_next_instances(c_instance.uri, prop, concept)
            q.execute do |i|
              # salvare nel DB c_instance.id come i.father_id
              # inserire il valore ritornato in "id" (vedi riga successiva qui sotto)
              next_instances << @action.call(i, p_count, level, prop, c_instance.id)
              puts "!!! Found: " + i.to_s
            end
          end
          curr_instances = next_instances
        end
        p_count = p_count.next
      end
    end
    
    
    
  end
  
end