class Instance < ActiveRecord::Base
  include Pbuilder::PHelper
  
  def self.save_grouping_by_pattern(uris, pattern, user_id, level)
    uris.each do |uri|
      i = Instance.new
      i.uri = Converter.abbreviate(uri)
      i.pattern = pattern
      i.user_id = user_id
      i.level = level
      if ! i.save
        return false
      end
    end
    true
  end
  
  
  
end
