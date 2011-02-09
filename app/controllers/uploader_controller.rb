class UploaderController < ApplicationController
  layout 'main'
  
  before_filter :authorize
  
  def upload_onto
    render :action => "save_onto"
  end
  
  def save_onto
    begin
      post = UploadedOnto.save(params[:upload])
    rescue
      flash[:notice] = "Something went wrong"
    else
      flash[:notice] = "File has been uploaded successfully"
    end
    redirect_to :action => "upload_onto"
  end
  
  def upload_aeria
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
  
end
