require 'test/unit'
require 'posterous'
require 'mocha'
require 'fakeweb'

class TestPosterous < Test::Unit::TestCase

  # This makes sure we don't connect to the new while testing 
  FakeWeb.allow_net_connect = false

  def setup
    @e = "email"
    @p = "password"
    @new_obj = Posterous.new(@e, @p)
    @new_obj_with_id = Posterous.new(@e, @p, "174966")
    @new_obj_with_bad_id = Posterous.new(@e, @p, "666")
    @resp_ok = {"rsp"=>{"site"=>{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, "stat"=>"ok"}}
    @resp_fail = {"rsp"=>{"err"=>{"msg"=>"Invalid Posterous email or password", "code"=>"3001"}, "stat"=>"fail"}}
    @resp_ok_two_sites = {"rsp"=>{"site"=>[{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, {"name"=>"uw-ruby", "primary"=>"false", "private"=>"false", "url"=>"http://uwruby.posterous.com", "id"=>"175260"}], "stat"=>"ok"}}
    @good_response = {"site"=>{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, "stat"=>"ok"}
    @good_response_two_sites = {"rsp"=>{"site"=>[{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, {"name"=>"uw-ruby", "primary"=>"false", "private"=>"false", "url"=>"http://uwruby.posterous.com", "id"=>"175260"}], "stat"=>"ok"}}
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

  def test_user_is_valid
    Posterous.stubs(:post).returns(@resp_ok)
    assert_equal true, @new_obj.valid_user?
  end

  def test_user_is_invalid
    Posterous.stubs(:post).returns(@resp_fail)
    assert_equal false, @new_obj.valid_user?
  end
  
  def test_user_is_invalid_when_response_isnt_hash
    Posterous.stubs(:post).returns("666")
    assert_equal false, @new_obj.valid_user?
  end

  def test_ping_success_hash_adjustment
    Posterous.stubs(:post).returns(@resp_ok)
    assert_equal @good_response, @new_obj.ping_account
  end

  def test_ping_fail_hash_adjustment
    Posterous.stubs(:post).returns(@resp_fail)
    assert_equal @bad_response, @new_obj.ping_account
  end

  def test_has_site_is_successful
    Posterous.stubs(:post).returns(@resp_ok)
    assert_equal true, @new_obj.has_site?
  end

  def test_has_site_successful_if_site_id_matches_only_result
    Posterous.stubs(:post).returns(@resp_ok_two_sites)
    assert_equal true, @new_obj_with_id.has_site?
  end

  def test_has_site_fails_if_site_id_doesnt_match_only_result
    Posterous.stubs(:post).returns(@resp_ok)
    assert_equal false, @new_obj_with_bad_id.has_site?
  end

  def test_has_site_is_successful_on_multiple_when_specified
    Posterous.stubs(:post).returns(@resp_ok_two_sites)
    assert_equal true, @new_obj_with_id.has_site?
  end

  def test_has_site_fails_if_specified_and_site_id_not_listed
    Posterous.stubs(:post).returns(@resp_ok_two_sites)
    assert_equal false, @new_obj_with_bad_id.has_site?
  end

  def test_has_site_fails_when_multiple_and_site_not_specified
    Posterous.stubs(:post).returns(@resp_ok_two_sites)
    assert_equal false, @new_obj.has_site?
  end

  def test_has_site_fails_with_error_response
    Posterous.stubs(:post).returns(@resp_fail)
    assert_equal false, @new_obj.has_site?
  end

  def test_has_site_fails_with_error_response
    Posterous.stubs(:post).returns(@resp_fail)
    assert_equal false, @new_obj.has_site?
  end

  def test_has_site_fails_if_response_isnt_Hash
    Posterous.stubs(:post).returns("666")
    assert_equal false, @new_obj.has_site?
  end

end