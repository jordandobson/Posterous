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
    @new_obj_with_bad_id = Posterous.new(@e, @p, "badID")
    @new_obj_with_invalid_id = Posterous.new(@e, @p, "666")
    @resp_ok = {"rsp"=>{"site"=>{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, "stat"=>"ok"}}
    @resp_fail = {"rsp"=>{"err"=>{"msg"=>"Invalid Posterous email or password", "code"=>"3001"}, "stat"=>"fail"}}
    @resp_ok_two_sites = {"rsp"=>{"site"=>[{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, {"name"=>"uw-ruby", "primary"=>"false", "private"=>"false", "url"=>"http://uwruby.posterous.com", "id"=>"175260"}], "stat"=>"ok"}}
    @good_response = {"site"=>{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, "stat"=>"ok"}
    @good_response_two_sites = {"rsp"=>{"site"=>[{"name"=>"ruby-posterous's posterous", "primary"=>"true", "private"=>"false", "url"=>"http://ruby-posterous.posterous.com", "id"=>"174966"}, {"name"=>"uw-ruby", "primary"=>"false", "private"=>"false", "url"=>"http://uwruby.posterous.com", "id"=>"175260"}], "stat"=>"ok"}}
    @bad_response = {"err"=>{"msg"=>"Invalid Posterous email or password", "code"=>"3001"}, "stat"=>"fail"}
    @post_success = {"rsp"=>{"post"=>{"title"=>"Untitled", "url"=>"http://post.ly/dFW", "id"=>"848898", "longurl"=>"http://glue.posterous.com/687985"}, "stat"=>"ok"}}
    @post_title_success = {"rsp"=>{"post"=>{"title"=>"My Title", "url"=>"http://post.ly/dFW", "id"=>"848898", "longurl"=>"http://glue.posterous.com/687985"}, "stat"=>"ok"}}
    @post_invalid_site = {"rsp"=>{"err"=>{"msg"=>"Invalid site id", "code"=>"3002"}, "stat"=>"fail"}}
    @post_access_error = {"rsp"=>{"err"=>{"msg"=>"User does not have access to this site", "code"=>"3003"}, "stat"=>"fail"}}
    @post_bad_account = {"rsp"=>{"err"=>{"msg"=>"Invalid Posterous email or password", "code"=>"3001"}, "stat"=>"fail"}}
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

  def test_has_site_fails_if_response_isnt_Hash
    Posterous.stubs(:post).returns("666")
    assert_equal false, @new_obj.has_site?
  end
  
  def test_builds_query_without_site_id
    expected = {:source=>nil, :title=>nil, :body=>nil, :sourceLink=>nil}
    assert_equal expected, @new_obj.build_query
  end
  
  def test_builds_query_with_site_id
    expected = {:source=>nil, :body=>nil, :sourceLink=>nil, :site_id=>"174966", :title=>nil}
    assert_equal expected, @new_obj_with_id.build_query
  end

  def test_builds_query_with_all_fields_set_without_site_id
    @new_obj.title      = "My Title"
    @new_obj.body       = "My Body"
    @new_obj.source     = "The Tubes"
    @new_obj.source_url = "http://TheTubes.com"
    expected = {:source=>"The Tubes", :body=>"My Body", :sourceLink=>"http://TheTubes.com", :title=>"My Title"}
    assert_equal expected, @new_obj.build_query
  end 

  def test_builds_query_with_all_fields_set_and_site_id
    @new_obj_with_id.title      = "My Title"
    @new_obj_with_id.body       = "My Body"
    @new_obj_with_id.source     = "The Tubes"
    @new_obj_with_id.source_url = "http://TheTubes.com"
    expected = {:source=>"The Tubes", :body=>"My Body", :sourceLink=>"http://TheTubes.com", :site_id=>"174966", :title=>"My Title"}
    assert_equal expected, @new_obj_with_id.build_query
  end
  
  def test_add_post_successful
    Posterous.stubs(:post).returns(@post_success)
    expected = @post_success
    assert_equal expected, @new_obj.add_post
  end
  
  def test_add_post_successful_no_content
    Posterous.stubs(:post).returns(@post_success)
    actual = @new_obj.add_post
    assert_equal "ok", actual["rsp"]["stat"]
    assert actual["rsp"]["post"].is_a?(Hash)
    assert_equal "Untitled", actual["rsp"]["post"]["title"]
  end
  
  def test_add_post_successful_with_title_content
    Posterous.stubs(:post).returns(@post_title_success)
    @new_obj.title = "My Title"
    actual = @new_obj.add_post
    assert_equal "My Title", actual["rsp"]["post"]["title"]
  end
  
  def test_add_post_invalid_site_id_fails
    Posterous.stubs(:post).returns(@post_invalid_site)
    actual = @new_obj_with_bad_id.add_post
    assert_equal "fail", actual["rsp"]["stat"]
    assert_equal nil, actual["rsp"]["post"]
    assert actual["rsp"]["err"]
    assert_equal "Invalid site id",  actual["rsp"]["err"]["msg"]
  end

  def test_add_post_no_access_fails
    Posterous.stubs(:post).returns(@post_access_error)
    actual = @new_obj_with_invalid_id.add_post
    assert_equal "fail", actual["rsp"]["stat"]
    assert_equal nil, actual["rsp"]["post"]
    assert actual["rsp"]["err"]
    assert_equal "User does not have access to this site",  actual["rsp"]["err"]["msg"]
  end
  
  def test_add_post_invalid_account_info
    Posterous.stubs(:post).returns(@post_bad_account)
    actual = Posterous.new("666", "666").add_post
    assert_equal "fail", actual["rsp"]["stat"]
    assert_equal nil, actual["rsp"]["post"]
    assert actual["rsp"]["err"]
    assert_equal "Invalid Posterous email or password",  actual["rsp"]["err"]["msg"]
  end

end

































