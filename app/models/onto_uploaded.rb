class OntoUploaded < ActiveRecord::Base
  NAME = "onto.owl"
  PUBLIC_DIRECTORY = "onto"
  
  PUBLIC_ADDRESS = PUBLIC_DIRECTORY + "/" + NAME
  
  DIRECTORY = "public/" + PUBLIC_DIRECTORY

  def self.save(upload)
    name = upload['datafile'].original_filename
    # create the file path
    path = File.join(DIRECTORY, NAME)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end
end
