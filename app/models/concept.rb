class Concept < ActiveRecord::Base
  belongs_to :user
  
  def self.import_from_matrix(matrix, user_id)
    i=0
    matrix.each do |array|
      j, w = 0, 0 
      array.each do |item|
        if j % 2 == 0
          concept = Concept.new(
            :uri => item,
            :pattern => i,
            :level => w,
            :user_id => user_id)
          concept.save
          w = w.next
        end
        j = j.next
      end
      i = i.next
    end
  end
  
end
