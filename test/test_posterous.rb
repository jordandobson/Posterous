require 'test/unit'
require 'posterous'
require 'mocha'

class TestPosterous < Test::Unit::TestCase

  def setup
    @valid_resp   = {"site"=>{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, "stat"=>"ok"}
    @invalid_resp = {"err"=>{"msg"=>"Invalid Posterous email or password", "code"=>"3001"}, "stat"=>"fail"}
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
  
  def test_raises_if_username_is_not_srting
    assert_raise PosterousAuthError do
      Posterous.new(666, 'password')
    end
  end
  
  def test_raises_if_password_is_not_srting
    assert_raise PosterousAuthError do
      Posterous.new('email_address', 666)
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
    post = Posterous.new('jordandobson@gmail.com', 'password')
    post.stubs(:ping_account).returns(@valid_resp)
    assert_equal true, post.valid_user?
  end

  def test_user_authentication_fail
    post = Posterous.new('failed@account.com', 'password')
    post.stubs(:ping_account).returns(@invalid_resp)
    assert_equal false, post.valid_user?
  end
  
#   def test_user_has_site
#     # works fine without fake web
#     actual = Posterous.new('jordandobson', 'password', 175260)
#     assert actual.has_site?
#   end

end
