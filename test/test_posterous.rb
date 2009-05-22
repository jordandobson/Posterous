require 'test/unit'
require 'posterous'
require 'fakeweb'

module FakeWeb
  class Registry
    alias :normalize_uri_org :normalize_uri
    def normalize_uri(uri)
      # I'm thinking I need to remove basic auth that FakeWeb dies on
      normalize_uri_org("http://" + uri.to_s.gsub(/^.+@/, ""))
    end
  end
end

class TestPosterous < Test::Unit::TestCase

 FakeWeb.allow_net_connect = false
  
  def setup
    # Neither seem to help 
    FakeWeb.register_uri("http://posterous.com:80/api/getsites?", :response => "#{File.dirname(__FILE__)}/files/response_for_getsites.txt")
    FakeWeb.register_uri("http://jordandobson@gamil.com:password@posterous.com:80/api/getsites?", :response => "#{File.dirname(__FILE__)}/files/response_for_getsites.txt")
  end

  def test_raises_if_username_is_blank
    assert_raise PosterousAuthError do
      Posterous.new('', 'password')
    end
  end

  def test_raises_if_password_is_blank
    assert_raise PosterousAuthError do
      Posterous.new('jordandobson@gmail.com', '')
    end
  end
  
  def test_raises_if_username_is_not_srting
    assert_raise PosterousAuthError do
      Posterous.new(666, 'password')
    end
  end
  
  def test_raises_if_password_is_not_srting
    assert_raise PosterousAuthError do
      Posterous.new('jordandobson@gmail.com', 666)
    end
  end

  def test_site_id_is_false
    actual = Posterous.new('jordandobson@gmail.com', 'password')
    assert_equal false, actual.site_id
  end
  
  def test_site_id_is_set
    actual = Posterous.new('jordandobson@gmail.com', 'password', '174966')
    assert_equal '174966', actual.site_id
  end
  
  def test_site_id_is_converted_to_string
    actual = Posterous.new('jordandobson@gmail.com', 'password', 174966)
    assert_equal '174966', actual.site_id
  end

  def test_user_authenticates
    # works fine without 
    actual = Posterous.new('jordandobson@gmail.com', 'password')
    assert actual.valid_user?
  end
  
  def test_user_has_site
    # works fine without fake web
    actual = Posterous.new('jordandobson@gmail.com', 'password', 175260)
    assert actual.has_site?
  end

end
