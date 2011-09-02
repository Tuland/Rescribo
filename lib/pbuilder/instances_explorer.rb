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
      @query = Query.new.extend(Pbuilder::Query)
      q = @query.search_by_concept(core_concept_rsc, constraint)
      q.execute do |y|
        @core_instances << y
      end
      for j in 1..patterns.size
        yield(@core_instances, j)
      end
    end
    
    def scan_patterns
      puts "!!!!!!!!!!!!!!!!!!!!!!!!"
      @patterns.each do |pattern|
        puts "----- NUOVO PATTERN"
        curr_instances = @core_instances
        for i in 1...pattern.size do
          if i % 2 == 1
            prop = RDFS::Resource.new(pattern[i])
            puts "----- prop: " + i.to_s + prop.to_s
          else
            puts "----- concept: " + pattern[i].to_s
            concept= RDFS::Resource.new(pattern[i])
            puts "???" + curr_instances.to_s
            curr_instances.each do |c_instance|
              puts "---- instance: " + c_instance.to_s
              q = @query.search_next_instances(c_instance, prop, concept)
              q.execute do |y|
                #next_instances << y
                puts "!!! Found: " + y.to_s
              end
            end
          end
        end
      end
    end
    
    
    
  end
  
end