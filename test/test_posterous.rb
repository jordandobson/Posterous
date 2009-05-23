require 'test/unit'
require 'posterous'
require 'mocha'
require 'fakeweb'

class TestPosterous < Test::Unit::TestCase

  # This makes sure we don't connect to the internet to test
  FakeWeb.allow_net_connect = false

  def setup
    @e = "email"
    @p = "password"
    @new_obj = Posterous.new(@e, @p)
    @resp_ok = {"rsp"=>{"site"=>{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, "stat"=>"ok"}}
    @resp_fail = {"rsp"=>{"err"=>{"msg"=>"Invalid Posterous email or password", "code"=>"3001"}, "stat"=>"fail"}}
    @resp_ok_two_sites = {"rsp"=>{"site"=>[{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, {"name"=>"uw-ruby", "primary"=>"false", "private"=>"false", "url"=>"http://uwruby.posterous.com", "id"=>"175260"}], "stat"=>"ok"}}
    @good_response = {"site"=>{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, "stat"=>"ok"}
    @bad_response = {"err"=>{"msg"=>"Invalid Posterous email or password", "code"=>"3001"}, "stat"=>"fail"}
  end

  def test_raises_if_username_is_blank
    assert_raise PosterousAuthError do
      Posterous.new('', @p)
    end
  end  

  def test_raises_if_password_is_blank
    assert_raise PosterousAuthError do
      Posterous.new(@e, '')
    end
  end
  
  def test_raises_if_password_is_not_srting
    assert_raise PosterousAuthError do
      Posterous.new(@e, 666)
    end
  end
    
  def test_raises_if_username_is_not_srting
    assert_raise PosterousAuthError do
      Posterous.new(666, @p)
    end
  end
  
  def test_site_id_is_false
    actual = Posterous.new(@e, @p)
    assert_equal false, actual.site_id
  end
  
  def test_site_id_is_set
    actual = Posterous.new(@e, @p, '174966')
    assert_equal '174966', actual.site_id
  end
  
  def test_site_id_is_converted_to_string
    actual = Posterous.new(@e, @p, 174966)
    assert_equal '174966', actual.site_id
  end  

  def test_user_authentication_success
    @new_obj.stubs(:ping_account).returns(@good_response)
    assert_equal true, @new_obj.valid_user?
  end
  
  def test_user_authentication_fail
    @new_obj.stubs(:ping_account).returns(@bad_response)
    assert_equal false, @new_obj.valid_user?
  end

  def test_ping_authentication_success_hash
    Posterous.stubs(:post).returns(@resp_ok)
    assert_equal @good_response, @new_obj.ping_account
  end
  
  def test_ping_authentication_fail_hash
    Posterous.stubs(:post).returns(@resp_fail)
    assert_equal @bad_response, @new_obj.ping_account
  end

end

#   def test_user_has_site
#     # works fine without fake web
#     actual = Posterous.new('jordandobson', 'password', 175260)
#     assert actual.has_site?
#   end