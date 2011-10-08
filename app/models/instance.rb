class Instance < ActiveRecord::Base
  acts_as_tree :order => "uri"
  
  belongs_to  :property
  
  has_many    :children,
              :class_name => "Instance",
              :foreign_key => "parent_id",
              :order => "uri",
              :dependent => :destroy
  
  belongs_to  :parent,
              :class_name => "Instance"
              
  belongs_to  :user
end
