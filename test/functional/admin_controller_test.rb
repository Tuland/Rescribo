require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  
  fixtures :users
  
  if false
    test "index" do
      get :index
      assert_response :success
    end
  end
  
  test "login" do
    tullio = users(:tullio)
    post :login, :name => tullio.name, :password => "secret"
    assert_redirected_to :controller => "guide", :action => "index"
    assert_equal tullio.id, session[:user_id]
  end
  
  test "bad_password" do
    tullio = users(:tullio)
    post :login, :name => tullio.name, :password => "wrong"
    assert_template "login"
  end
  
end
