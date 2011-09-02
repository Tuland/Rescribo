module Pbuilder::Query
  
  begin
    require 'active_rdf'
  rescue Exception
    print "This sample needs activerdf and activerdf_jena.\n"
  end
  
  # Adds regular expression filter on one variable. This is method override ActiveRdf 
  #  
  # ==== Attributes  
  # 
  # * +variable+ - A ruby symbol that appears in select/where clause
  # * +regexp+ - A ruby regular expression
  # * +options+ - An hash determining options
  #
  # ==== Options
  #  
  # * +:sparql_flags+ - Sparql flags. Ex: The flag "i" means a case-insensitive pattern
  def filter_regexp(variable, regexp, options = {})
    raise(ActiveRdfError, "variable must be a symbol") unless variable.is_a? Symbol
    raise(ActiveRdfError, "regexp must be a ruby regexp") unless regexp.is_a? Regexp
    if options[:sparql_flags]
      filter "regex(str(?#{variable}), #{regexp.inspect.gsub('/','"')}, '#{options[:sparql_flags]}')"
    else
      filter "regex(str(?#{variable}), #{regexp.inspect.gsub('/','"')})"
    end
  end
  
  # Searches instances of a concept and filters results with a constraint
  #
  # ==== Attributes
  #
  # * +concept+ - A concept interested by the query
  # * +constraint+ - A string determining a regular expression to filter the query (case insensitive)
  def search_by_concept(concept, constraint)
    regexp = Regexp.new(Regexp.quote(constraint))  
    self.distinct(:i).where(:i, RDF::type, concept).where(:i, RDFS::label, :lab)
    self.filter_regexp(:lab, regexp, {:sparql_flags => "i"})
  end
  
  # Searches the next instances exploiting patterns
  #
  # ==== Attributes
  #
  # * +curr_instance+ - Current instance (string)
  # * +property+ - Property related to the next instances (curr_instance property ?i)
  # * +concept+ - Class of the next instances (?i RDF:type concept)
  def search_next_instances(curr_instance, property, concept)
    self.distinct(:i).where(curr_instance, property, :i).where(:i, RDF::type, concept)
  end
  
end