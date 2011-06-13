require 'pbuilder/endpoint_adapter'

class Prefix < ActiveRecord::Base
  validates_uniqueness_of   :prefix,
                            :message => "is already being used"
                            
                            
  def self.get_prefixes(user_id)
    prefixes = Prefix.find(:all, :conditions => ["user_id = ?", user_id])
    Pbuilder::EndpointAdapter.set_prefixes(prefixes) do |p|
      {:prefix => p.prefix, :namespace => p.namespace}
    end
    prefixes
  end
  
end
