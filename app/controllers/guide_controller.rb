class GuideController < ApplicationController
  layout 'main'
  
  before_filter :authorize
  def index
  end
end
