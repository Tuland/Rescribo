module Pbuilder
  
  require 'test_helper'
  
  class PatternsAnalysisTest < ActiveSupport::TestCase
  
    INIT_CONCEPT = "A_core"
    CONCEPT = "A"
    PROPERTY_NAME = "p"
    PROPERTY_TYPE = "i"
  
    test "init" do
      @analysis = PatternsAnalysis.new(INIT_CONCEPT)
      assert_instance_of(Array, @analysis.concepts_list)
      assert_instance_of(Hash, @analysis.properties_list)
    end
  
    test "init_concept" do
      @analysis = PatternsAnalysis.new(INIT_CONCEPT)
      assert_equal INIT_CONCEPT, @analysis.concepts_list.first
    end
  
    test "nil_init_concept" do
      @analysis = PatternsAnalysis.new()
      assert_nil(@analysis.concepts_list.first)
    end

    test "update_analysis" do
      @analysis = PatternsAnalysis.new()
      @analysis.update( INIT_CONCEPT, 
                        CONCEPT, 
                        PROPERTY_NAME, 
                        PROPERTY_TYPE)
      assert_equal(@analysis.concepts_list.first, CONCEPT)
      puts @analysis.properties_list.keys
      assert(@analysis.include_edge?( INIT_CONCEPT,
                                      PROPERTY_NAME,
                                      CONCEPT))
      assert_equal( @analysis.properties_list[[INIT_CONCEPT, 
                                              PROPERTY_NAME, 
                                              CONCEPT]], 
                    PROPERTY_TYPE)
    end
  
    test "update_analysis_with_deafault_type" do
      @analysis = PatternsAnalysis.new()
      @analysis.update(INIT_CONCEPT, CONCEPT, PROPERTY_NAME)
      assert_equal(@analysis.properties_list[[INIT_CONCEPT, 
                                              PROPERTY_NAME, 
                                              CONCEPT]], 
                  PatternsAnalysis::DEFAULT_PROPERTY_TYPE)
    end
  
    test "shift_concepts" do
      @analysis = PatternsAnalysis.new(INIT_CONCEPT)
      @analysis.update( INIT_CONCEPT, 
                        CONCEPT, 
                        PROPERTY_NAME, 
                        PROPERTY_TYPE)
      @analysis.shift_concepts
      assert_equal CONCEPT, @analysis.concepts_list.first
    end
  end
  
end