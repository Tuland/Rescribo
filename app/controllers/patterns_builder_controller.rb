require 'pbuilder/adapter'
require 'pbuilder/clouds_explorer'

#require 'pbuilder/maps_analyzer'
#require 'pbuilder/yaml_writer'


class PatternsBuilderController < ApplicationController
  layout 'main', :except => [ :load ]
  
  before_filter :authorize
  
  def index
    # Actually this line code is redundant
    Pbuilder::Adapter.purge(session[:user_id])
  end
  
  def load
    @url_str = "Files loaded from " + path_to_url(AERIA_DIRECTORY)
    
    explorer = Pbuilder::CloudsExplorer.new(AERIA_DIRECTORY,
                                            PERSISTENT_AERIA,
                                            { :report => true,
                                              :id             =>  session[:user_id],
                                              :patterns_file  =>  PATTERNS_FILE,
                                              :analysis_file  =>  ANALYSIS_FILE,
                                              :mappings_file  =>  MAPPINGS_FILE } ) { |path| path_to_url(path) }
    @global_rc_list = explorer.global_root_concepts
    @global_finders = explorer.global_finders
  end
  
end
