require 'test/unit'
require 'posterous'
require 'mocha'
require 'fakeweb'

class TestPosterous < Test::Unit::TestCase

  # This makes sure we don't connect to the internet to test
  FakeWeb.allow_net_connect = false

  def setup
    @resp_ok = {"rsp"=>{"site"=>{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, "stat"=>"ok"}}
    @resp_fail = {"rsp"=>{"err"=>{"msg"=>"Invalid Posterous email or password", "code"=>"3001"}, "stat"=>"fail"}}
    @resp_ok_two_sites = {"rsp"=>{"site"=>[{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, {"name"=>"uw-ruby", "primary"=>"false", "private"=>"false", "url"=>"http://uwruby.posterous.com", "id"=>"175260"}], "stat"=>"ok"}}
    @good_response = {"site"=>{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, "stat"=>"ok"}
    @bad_response = {"err"=>{"msg"=>"Invalid Posterous email or password", "code"=>"3001"}, "stat"=>"fail"}
  end

  def test_raises_if_username_is_blank
    assert_raise PosterousAuthError do
      Posterous.new('', 'password')
    end
  end  

  def test_raises_if_password_is_blank
    assert_raise PosterousAuthError do
      Posterous.new('email_address', '')
    end
  end
  
  def test_raises_if_password_is_not_srting
    assert_raise PosterousAuthError do
      Posterous.new('email_address', 666)
    end
  end
    
  def test_raises_if_username_is_not_srting
    assert_raise PosterousAuthError do
      Posterous.new(666, 'password')
    end
  end
  
  def test_site_id_is_false
    actual = Posterous.new('email_address', 'password')
    assert_equal false, actual.site_id
  end
  
  def test_site_id_is_set
    actual = Posterous.new('email_address', 'password', '174966')
    assert_equal '174966', actual.site_id
  end
  
  def test_site_id_is_converted_to_string
    actual = Posterous.new('email_address', 'password', 174966)
    assert_equal '174966', actual.site_id
  end  

  def test_user_authentication_success
    post = Posterous.new('email_address', 'password')
    post.stubs(:ping_account).returns(@good_response)
    assert_equal true, post.valid_user?
  end
  
  def test_user_authentication_fail
    post = Posterous.new('bad_email', 'password')
    post.stubs(:ping_account).returns(@bad_response)
    assert_equal false, post.valid_user?
  end

  def test_ping_authentication_success
    Posterous.stubs(:post).returns(@resp_ok)
    assert_equal @good_response, Posterous.new('e', 'p').ping_account
    assert_not_equal @resp_ok, @good_response
  end
  
  def test_ping_authentication_fail
    Posterous.stubs(:post).returns(@resp_fail)
    assert_equal @bad_response, Posterous.new('jordandobson@gmail.com', 'password').ping_account
    assert_not_equal @resp_fail, @bad_response
  end

end

#   def test_user_has_site
#     # works fine without fake web
#     actual = Posterous.new('jordandobson', 'password', 175260)
#     assert actual.has_site?
#   end