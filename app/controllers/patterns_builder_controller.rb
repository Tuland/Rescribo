require 'pbuilder/adapter'
require 'pbuilder/clouds_explorer'

class PatternsBuilderController < ApplicationController
  
  include_class 'com.mysql.jdbc.Driver'
  
  
  layout 'main', :except => [ :load ]
  
  before_filter :authorize
  
  def index    
    # Actually this line code is redundant
    Pbuilder::Adapter.purge(session[:user_id])
  end
  
  def load
    files = Dir["#{AERIA_DIRECTORY}/*"].collect { |path| path_to_url(path) }
    @url_str = "Files loaded from " + path_to_url(AERIA_DIRECTORY)
    explorer = Pbuilder::CloudsExplorer.new(files,
                                            PERSISTENT_AERIA,
                                            session[:user_id],
                                            { :report => true,
                                              :patterns_file  =>  PATTERNS_FILE,
                                              :analysis_file  =>  ANALYSIS_FILE,
                                              :mappings_file  =>  MAPPINGS_FILE } )
    @global_rc_list = explorer.global_root_concepts
    @global_finders = explorer.global_finders
  end
  
  
  def show_properties
    @id = params[:id]
    @hide_str = "hide_pr_#{@id}"
    @show_str = "show_pr_#{@id}"
    @div = "properties_#{@id}"
    render :action => "show"
  end
  
  def hide_properties
    @id = params[:id]
    @hide_str = "hide_pr_#{@id}"
    @show_str = "show_pr_#{@id}"
    @div = "properties_#{@id}"
    render :action => "hide"
  end
  
  def show_tree
    @id = params[:id]
    @hide_str = "hide_t_#{@id}"
    @show_str = "show_t_#{@id}"
    @div = "tree_#{@id}"
    render :action => "show"
  end
  
  def hide_tree
    @id = params[:id]
    @hide_str = "hide_t_#{@id}"
    @show_str = "show_t_#{@id}"
    @div = "tree_#{@id}"
    render :action => "hide"
  end
    
  def show_patterns
    @id = params[:id]
    @hide_str = "hide_pa_#{@id}"
    @show_str = "show_pa_#{@id}"
    @div = "patterns_#{@id}"
    render :action => "show"
  end
  
  def hide_patterns
    @id = params[:id]
    @hide_str = "hide_pa_#{@id}"
    @show_str = "show_pa_#{@id}"
    @div = "patterns_#{@id}"
    render :action => "hide"
  end 
  
end
