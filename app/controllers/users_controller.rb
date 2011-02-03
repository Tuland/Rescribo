class UsersController < ApplicationController
  layout 'main'
  
  before_filter :authorize, :except => [:new, :create]

  def index
    redirect_to :controller => "users", :action => "new"
  end


  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  # POST /users 
  # POST /users.xml 
  def create 
    @user = User.new(params[:user]) 
    respond_to do |format| 
    if @user.save 
      flash[:notice] = "User #{@user.name} was successfully created." 
      format.html { redirect_to(:controller => "admin", :action =>'index') } 
      format.xml { render :xml => @user, :status => :created, 
      :location => @user } 
    else 
      format.html { render :action => "new" } 
      format.xml { render :xml => @user.errors, 
      :status => :unprocessable_entity } 
    end 
    end 
  end
  
end