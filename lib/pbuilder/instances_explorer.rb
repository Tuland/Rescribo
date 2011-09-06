module Pbuilder
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  class InstancesExplorer
    
    attr_reader :core_instances
    
    def initialize(patterns, core_concept, constraint)
      core_concept_rsc = RDFS::Resource.new(core_concept)  
      @core_instances = []
      @patterns = patterns 
      @query = Query
      q = @query.new.extend(Pbuilder::Query)
      q = q.search_by_concept(core_concept_rsc, constraint)
      q.execute do |y|
        @core_instances << y
      end
      for j in 1..patterns.size
        yield(@core_instances, j)
      end
    end
    
    def scan_patterns
      @patterns.each do |pattern|
        puts "----- NUOVO PATTERN"
        level = 0
        curr_instances = @core_instances
        pr = PatternReader.new(pattern[1..-1])
        until pr.halted?
          prop, concept = pr.default_next_concept_and_prop
          level = level.next
          puts "----- prop: " + prop.to_s
          puts "----- concept: " + concept.to_s
          next_instances = []
          curr_instances.each do |c_instance|
            # recuperare dal DB l'ID di c_instance tramite NOME, N_PATTERN, LEVEL
            puts "---- instance: " + c_instance.to_s
            q = @query.new.extend(Pbuilder::Query)
            q = q.search_next_instances(c_instance, prop, concept)
            q.execute do |y|
              next_instances << y
              # salvare nel DB c_instance.id come y.father_id
              puts "!!! Found: " + y.to_s
            end
          end
          curr_instances = next_instances
        end
      end
    end
    
    
    
  end
  
end