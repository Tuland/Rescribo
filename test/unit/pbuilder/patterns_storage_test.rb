module Pbuilder
  
  require 'test_helper'
  
  class PatternsStorageTest < ActiveSupport::TestCase
  
    INIT_CONCEPT = "A_core"
    CONCEPT = "A"
    PROPERTY = "p"
    PROPERTY_ALT = "q"
    CONCEPT_ALT = "B"
  
    def teardown
      @patterns.empty_cache
    end
  
  
    test "init" do
      @patterns = PatternsStorage.new(INIT_CONCEPT)
      assert_instance_of(Array, @patterns.list)
      assert_instance_of(Array, @patterns.cache)
    end
  
    test "init_concept" do
      @patterns = PatternsStorage.new(INIT_CONCEPT)
      assert_equal INIT_CONCEPT, @patterns.list.first.first
    end
  
    test "nil_init_concept" do
      @patterns = PatternsStorage.new()
      assert_nil(@patterns.list.first)
    end
  
    test "cache_with_init_concept" do
      @patterns = PatternsStorage.new(INIT_CONCEPT)
      @patterns.update(INIT_CONCEPT, PROPERTY, CONCEPT)
      assert_equal(INIT_CONCEPT, @patterns.cache.first.first)
    end
  
    test "cache_without_init_concept" do
      @patterns = PatternsStorage.new()
      @patterns.update(INIT_CONCEPT, PROPERTY, CONCEPT)
      assert_equal(INIT_CONCEPT, @patterns.cache.first.first)
    end
  
    test "single_update" do
      @patterns = PatternsStorage.new(INIT_CONCEPT)
      @patterns.update(INIT_CONCEPT, PROPERTY, CONCEPT)
      correct_pattern = [INIT_CONCEPT, PROPERTY, CONCEPT]
      assert_equal(correct_pattern, @patterns.list.first)
    end
  
    test "double_update_with_cache" do
      @patterns = PatternsStorage.new(INIT_CONCEPT)
      @patterns.update(INIT_CONCEPT, PROPERTY, CONCEPT)
      @patterns.update(INIT_CONCEPT, PROPERTY_ALT, CONCEPT_ALT)
      correct_patterns = [ [INIT_CONCEPT, PROPERTY, CONCEPT],
                           [INIT_CONCEPT, PROPERTY_ALT, CONCEPT_ALT] ]
      assert_equal(correct_patterns, @patterns.list)
    end
  
    test "double_update_without_cache" do
      @patterns = PatternsStorage.new(INIT_CONCEPT)
      @patterns.update(INIT_CONCEPT, PROPERTY, CONCEPT)
      @patterns.empty_cache
      @patterns.update(INIT_CONCEPT, PROPERTY_ALT, CONCEPT_ALT)
      correct_patterns = [ [INIT_CONCEPT, PROPERTY, CONCEPT] ]
      assert_equal(correct_patterns, @patterns.list)
    end
  
    test "double_update_with_double_base_concept" do
      @patterns = PatternsStorage.new(INIT_CONCEPT)
      @patterns.update(INIT_CONCEPT, PROPERTY, CONCEPT)
      @patterns.update(INIT_CONCEPT, PROPERTY_ALT, CONCEPT_ALT)
      @patterns.empty_cache
      @patterns.update(CONCEPT_ALT, PROPERTY_ALT, CONCEPT)
      @patterns.update(CONCEPT, PROPERTY, CONCEPT_ALT)
      correct_patterns = [ [  INIT_CONCEPT, 
                              PROPERTY, 
                              CONCEPT ],
                              
                           [  INIT_CONCEPT, 
                              PROPERTY_ALT, 
                              CONCEPT_ALT, 
                              PROPERTY_ALT, 
                              CONCEPT],
                              
                           [  INIT_CONCEPT, 
                              PROPERTY_ALT, 
                              CONCEPT_ALT, 
                              PROPERTY, 
                              CONCEPT_ALT] ]
      assert_equal(correct_patterns, @patterns.list)
    end
  end
end
