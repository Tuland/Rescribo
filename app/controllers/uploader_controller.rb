begin
  require 'active_rdf'
rescue Exception
  print "This sample needs activerdf and activerdf_jena.\n"
end

require 'pbuilder/adapter'

class UploaderController < ApplicationController
  layout 'main'
  
  before_filter :authorize
  
  def upload_onto
    @ontology = Ontology.find(:first, :conditions => "user_id='#{session[:user_id]}'")
    @files_uploaded = search_file(UploadedOnto::DIRECTORY)  
    render :action => "save_onto"
  end
  
  def save_onto
    begin
      post = UploadedOnto.save(params[:upload])
    rescue
      flash[:notice] = "Something went wrong"
    else
      flash[:notice] = "File has been uploaded successfully"
      build_adapter_from_directory( UploadedOnto::DIRECTORY, 
                                    PERSISTENCE_DIR,
                                    PERSISTENT_ONTO )
    end                                  
    redirect_to :action => "upload_onto"
  end
  
  def upload_aeria
    @files_uploaded = search_file(UploadedAeria::DIRECTORY)
    render :action => "save_aeria"
  end
  
  def save_aeria
    begin
      post = UploadedAeria.save(params[:upload])
    rescue
      flash[:notice] = "Something went wrong"
    else
      flash[:notice] = "File has been uploaded successfully"
    end
    redirect_to :action => "upload_aeria"
  end


  def delete_aeria
    file = params[:file]
    if File.exist?("#{UploadedAeria::DIRECTORY}/#{file}") && ! file.include?("..")
      File.delete("#{UploadedAeria::DIRECTORY}/#{file}")
    end
    redirect_to :action => "upload_aeria"
  end
  
  def delete_onto
    file = params[:file]
    begin 
      if File.exist?("#{UploadedOnto::DIRECTORY}/#{file}") && ! file.include?("..")
        File.delete("#{UploadedOnto::DIRECTORY}/#{file}")
        build_adapter_from_directory(UploadedOnto::DIRECTORY, PERSISTENCE_DIR, PERSISTENT_ONTO )
      end
    rescue
      flash[:notice] = "Something went wrong"
    end
    redirect_to :action => "upload_onto"
  end
  
  def save_url
    @ontology = Ontology.find(:first, :conditions => "user_id='#{session[:user_id]}'")
    if ! @ontology
      @ontology = Ontology.new
    end
    @ontology.url = params[:ontology][:url]
    @ontology.user_id = session[:user_id]
    if @ontology.save
      flash[:notice] = "Ontology defined correctly"
    else
      flash[:notice] = "Something went wrong"
    end
    redirect_to :action => "upload_onto"
  end
  
  private

  def build_adapter_from_directory(directory, persistence_dir, adapter_name)
    files = Dir["#{directory}/*"].collect { |path| path_to_url(path) }
    if ! files.empty?
      begin
        Pbuilder::Adapter.purge(session[:user_id], "", persistence_dir)
        onto_adapter = Pbuilder::Adapter.new( session[:user_id],
                                              files,
                                              adapter_name,
                                              "", persistence_dir)
        onto_adapter.close
      rescue
        flash[:notice] = "Something went wrong"
      else
        flash[:notice] = "The model has been successfully updated (import: #{files.size} files)"
      end
    else
      flash[:notice] = "There aren't files to import into the model"
    end
  end
  
  def search_file(directory)
    Dir.entries(directory) - [".", "..", ".DS_Store"]
  end


end
