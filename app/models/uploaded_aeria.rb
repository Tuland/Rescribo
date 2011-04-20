class UploadedAeria < ActiveRecord::Base
  NAME = "aeria_summary.owl"
  PUBLIC_DIRECTORY = "summary"
  
  PUBLIC_ADDRESS = PUBLIC_DIRECTORY + "/" + NAME
  
  DIRECTORY = "public/" + PUBLIC_DIRECTORY

  def self.save(upload)
    name = upload['datafile'].original_filename
    # create the file path
    path = File.join(DIRECTORY, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end
end
