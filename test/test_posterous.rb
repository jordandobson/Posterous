require 'test/unit'
require 'posterous'
require 'mocha'

class TestPosterous < Test::Unit::TestCase

  def setup
    @e = "email"
    @p = "password"

    @new_obj                  = Posterous::Client.new(@e, @p)
    @new_obj_with_id          = Posterous::Client.new(@e, @p, "174966")
    @new_obj_with_bad_id      = Posterous::Client.new(@e, @p, "badID")
    @new_obj_with_invalid_id  = Posterous::Client.new(@e, @p, "666")

    @private_url_path  = /[.]posterous[.]com\/private\//

    @resp_ok           ={ "rsp"     => {
                          "site"    => {
                          "name"    => "ruby-posterous's posterous",
                          "primary" => "true", "private"=>"false",
                          "url"     => "http://ruby-posterous.posterous.com",
                          "id"      => "174966" },
                          "stat"    => "ok" }}

    @resp_fail         ={ "rsp"     => {
                          "err"     => {
                          "msg"     => "Invalid Posterous email or password",
                          "code"    => "3001" },
                          "stat"    => "fail" }}

    @resp_ok_2_sites   ={ "rsp"     => {
                          "site"    => [{
                          "name"    => "ruby-posterous's posterous",
                          "primary" => "false",
                          "private" => "false",
                          "url"     => "http://ruby-posterous.posterous.com",
                          "id"      => "174966"
                          }, {
                          "name"    => "uw-ruby",
                          "primary" => "true",
                          "private" => "false",
                          "url"     => "http://uwruby.posterous.com",
                          "id"      => "175260" }],
                          "stat"    => "ok"     }}

    @good_response     ={ "site"    => {
                          "name"    => "ruby-posterous's posterous",
                          "primary" => "true",
                          "private" => "false",
                          "url"     => "http://ruby-posterous.posterous.com",
                          "id"      => "174966" },
                          "stat"    => "ok" }

    @bad_response      ={ "err"     => {
                          "msg"     => "Invalid Posterous email or password",
                          "code"    => "3001" },
                          "stat"    => "fail" }

    @post_success      ={ "rsp"     => {
                          "post"    => {
                          "title"   => "Untitled",
                          "url"     => "http://post.ly/dFW",
                          "id"      => "848898", 
                          "longurl" => "http://glue.posterous.com/687985" },
                          "stat"    => "ok" }}

    @post_title_success ={"rsp"     => {
                          "post"    => {
                          "title"   => "My Title",
                          "url"     => "http://post.ly/dFW",
                          "id"      => "848898",
                          "longurl" => "http://glue.posterous.com/687985" },
                          "stat"    => "ok" }}

    @post_invalid_site ={ "rsp"     => {
                          "err"     => {
                          "msg"     => "Invalid site id",
                          "code"    => "3002" },
                          "stat"    => "fail" }}

    @post_access_error ={ "rsp"     => {
                          "err"     => {
                          "msg"     => "User does not have access to this site",
                          "code"    => "3003" },
                          "stat"    => "fail" }}

    @post_bad_account  ={ "rsp"     => {
                          "err"     => {
                          "msg"     => "Invalid Posterous email or password",
                          "code"    => "3001" },
                          "stat"    => "fail" }}

    @post_private_good ={ "rsp"     => {
                          "post"    => {
                          "title"   => "Posterous test",
                          "url"     => "http://post.ly/gxK",
                          "id"      => "891064",
                          "longurl" => "http://glue.posterous.com/private/tGIEAateBy" },
                          "stat"    => "ok" }}

  end

  def test_raises_if_username_is_blank
    assert_raise Posterous::AuthError do
      Posterous::Client.new('', @p)
    end
  end

  def test_raises_if_password_is_blank
    assert_raise Posterous::AuthError do
      Posterous::Client.new(@e, '')
    end
  end

  def test_raises_if_password_is_not_srting
    assert_raise Posterous::AuthError do
      Posterous::Client.new(@e, 666)
    end
  end

  def test_raises_if_username_is_not_srting
    assert_raise Posterous::AuthError do
      Posterous::Client.new(666, @p)
    end
  end

  def test_site_id_can_be_witheld
    actual = Posterous::Client.new(@e, @p)
    assert_equal nil, actual.site_id
  end

  def test_site_id_can_be_provided
    actual = Posterous::Client.new(@e, @p, '174966')
    assert_equal '174966', actual.site_id
  end

  def test_site_id_is_converted_to_string
    actual = Posterous::Client.new(@e, @p, 174966)
    assert_equal '174966', actual.site_id
  end

  def test_user_is_valid
    Posterous::Client.stubs(:post).returns(@resp_ok)
    assert_equal true, @new_obj.valid_user?
  end

  def test_user_is_invalid
    Posterous::Client.stubs(:post).returns(@resp_fail)
    assert_equal false, @new_obj.valid_user?
  end

  def test_user_is_invalid_when_response_isnt_hash
    Posterous::Client.stubs(:post).returns("666")
    assert_equal false, @new_obj.valid_user?
  end

  def test_ping_success_hash_adjustment
    Posterous::Client.stubs(:post).returns(@resp_ok)
    assert_equal @good_response, @new_obj.account_info
  end

  def test_ping_fail_hash_adjustment
    Posterous::Client.stubs(:post).returns(@resp_fail)
    assert_equal @bad_response, @new_obj.account_info
  end

  def test_has_site_is_successful
    Posterous::Client.stubs(:post).returns(@resp_ok)
    assert_equal true, @new_obj.has_site?
  end

  def test_has_site_successful_if_site_id_matches_only_result
    Posterous::Client.stubs(:post).returns(@resp_ok_2_sites)
    assert_equal true, @new_obj_with_id.has_site?
  end

  def test_has_site_fails_if_site_id_doesnt_match_only_result
    Posterous::Client.stubs(:post).returns(@resp_ok)
    assert_equal false, @new_obj_with_bad_id.has_site?
  end
  
  def test_has_site_successful_that_site_id_matches_response
    Posterous::Client.stubs(:post).returns(@resp_ok)
    assert_equal true, @new_obj_with_id.has_site?
  end

  def test_has_site_is_successful_on_multiple_when_specified
    Posterous::Client.stubs(:post).returns(@resp_ok_2_sites)
    assert_equal true, @new_obj_with_id.has_site?
  end

  def test_has_site_fails_if_specified_and_site_id_not_listed
    Posterous::Client.stubs(:post).returns(@resp_ok_2_sites)
    assert_equal false, @new_obj_with_bad_id.has_site?
  end

  def test_has_site_fails_when_multiple_and_site_not_specified
    Posterous::Client.stubs(:post).returns(@resp_ok_2_sites)
    assert_equal false, @new_obj.has_site?
  end

  def test_has_site_fails_with_error_response
    Posterous::Client.stubs(:post).returns(@resp_fail)
    assert_equal false, @new_obj.has_site?
  end

  def test_has_site_fails_if_response_isnt_hash
    Posterous::Client.stubs(:post).returns("666")
    assert_equal false, @new_obj.has_site?
  end

  def test_tags_are_added_correctly
    @new_obj.tags = []
    assert_equal @new_obj.tags, ""
  end

  def test_tags_single_is_correctly
    @new_obj.tags = ["Glue"]
    assert_equal @new_obj.tags, "Glue"
  end

  def test_tags_multiple_is_correctly_joined
    @new_obj.tags = ["Glue", "Posterous", "Ruby on Rails"]
    assert_equal @new_obj.tags, "Glue, Posterous, Ruby on Rails"
  end

  def test_raises_if_tags_not_set_as_array
    assert_raise Posterous::TagError do
      @new_obj.tags = "hello, "
    end
  end

  def test_gets_primary_single_site
    Posterous::Client.stubs(:post).returns(@resp_ok)
    assert_equal @resp_ok["rsp"]["site"]["id"],             @new_obj.primary_site
  end

  def test_gets_primary_site_from_multiple_listing
    Posterous::Client.stubs(:post).returns(@resp_ok_2_sites)
    assert_equal @resp_ok_2_sites["rsp"]["site"][1]["id"],  @new_obj.primary_site
  end

  def test_gets_primary_site_raises_on_error
    Posterous::Client.stubs(:post).returns(@resp_fail)
    assert_raise Posterous::SiteError do
      @new_obj.primary_site
    end
  end

  def test_gets_primary_site_is_passed_to_overide_site_id
    Posterous::Client.stubs(:post).returns(@resp_ok_2_sites)
    original                 = @new_obj_with_id.site_id
    @new_obj_with_id.site_id = @new_obj_with_id.primary_site
    updated                  = @new_obj_with_id.site_id
    assert_not_equal   original, updated
    assert_equal       @resp_ok_2_sites["rsp"]["site"][1]["id"], updated 
  end

  def test_gets_primary_site_is_set_to_site_id
    Posterous::Client.stubs(:post).returns(@resp_ok)
    original         = @new_obj.site_id
    @new_obj.site_id = @new_obj.primary_site
    updated          = @new_obj_with_id.site_id
    assert_not_equal   original, updated
    assert_equal       @resp_ok["rsp"]["site"]["id"], updated
  end

  def test_builds_query_without_site_id
    expected = { :source => nil, :title => nil, :body => nil, :sourceLink => nil}
    assert_equal expected, @new_obj.build_query
  end

  def test_builds_query_with_site_id
    expected = { :source => nil, :body => nil, :sourceLink => nil, :site_id => "174966", :title => nil }
    assert_equal expected, @new_obj_with_id.build_query
  end

  def test_builds_query_with_all_fields_set_without_site_id
    @new_obj.title      = "My Title"
    @new_obj.body       = "My Body"
    @new_obj.source     = "The Tubes"
    @new_obj.source_url = "http://TheTubes.com"
    expected = { :source => "The Tubes", :body => "My Body", :sourceLink => "http://TheTubes.com", :title => "My Title" }
    assert_equal expected, @new_obj.build_query
  end 

  def test_builds_query_with_date_option
    date = Time.now
    @new_obj.date = date
    expected = { :source => nil, :body => nil, :sourceLink => nil, :title => nil, :date => date }
    assert_equal expected, @new_obj.build_query
  end

  def test_builds_query_with_private_option
    @new_obj.set_to :private
    expected = { :source => nil, :body => nil, :sourceLink => nil, :title => nil, :private => 1 }
    assert_equal expected, @new_obj.build_query
  end

  def test_builds_query_with_autopost_option
    @new_obj.set_to :autopost
    expected = { :source => nil, :body => nil, :sourceLink => nil, :title => nil, :autopost => 1 }
    assert_equal expected, @new_obj.build_query
  end

  def test_builds_query_with_integer_set_as_site_id
    @new_obj.site_id = 20
    expected = { :source => nil, :body => nil, :sourceLink => nil, :site_id => "20", :title => nil }
    assert_equal expected, @new_obj.build_query
  end

  def test_builds_query_with_all_options_set
    date = Time.now
    @new_obj.date    = date
    @new_obj.site_id = 20
    @new_obj.set_to :private
    expected = { :source => nil, :body => nil, :sourceLink => nil, :site_id => "20", :title => nil, :private => 1, :date => date }
    assert_equal expected, @new_obj.build_query
  end

  def test_builds_query_with_all_fields_set_and_site_id
    @new_obj_with_id.title      = "My Title"
    @new_obj_with_id.body       = "My Body"
    @new_obj_with_id.source     = "The Tubes"
    @new_obj_with_id.source_url = "http://TheTubes.com"
    expected = { :source => "The Tubes", :body => "My Body", :sourceLink => "http://TheTubes.com", :site_id => "174966", :title => "My Title" }
    assert_equal expected, @new_obj_with_id.build_query
  end

  def test_add_post_successful
    Posterous::Client.stubs(:post).returns(@post_success)
    expected = @post_success
    assert_equal expected, @new_obj.add_post
  end

  def test_add_post_successful_no_content
    Posterous::Client.stubs(:post).returns(@post_success)
    actual = @new_obj.add_post
    assert       actual["rsp"]["post"].is_a?(Hash)
    assert_equal "ok",                actual["rsp"]["stat"]
    assert_equal "Untitled",          actual["rsp"]["post"]["title"]
  end

  def test_add_post_successful_with_title_content
    Posterous::Client.stubs(:post).returns(@post_title_success)
    @new_obj.title = "My Title"
    actual = @new_obj.add_post
    assert_equal "My Title",          actual["rsp"]["post"]["title"]
  end

  def test_add_post_invalid_site_id_fails
    Posterous::Client.stubs(:post).returns(@post_invalid_site)
    actual = @new_obj_with_bad_id.add_post
    assert_equal  "fail",             actual["rsp"]["stat"]
    assert_equal  nil,                actual["rsp"]["post"]
    assert_equal  "Invalid site id",  actual["rsp"]["err"]["msg"]
  end

  def test_add_post_no_access_fails
    Posterous::Client.stubs(:post).returns(@post_access_error)
    actual = @new_obj_with_invalid_id.add_post
    assert_equal "fail",              actual["rsp"]["stat"]
    assert_equal nil,                 actual["rsp"]["post"]
    assert_match "not have access",   actual["rsp"]["err"]["msg"]
  end

  def test_add_post_invalid_account_info
    Posterous::Client.stubs(:post).returns(@post_bad_account)
    actual = Posterous::Client.new("666", "666").add_post
    assert_equal "fail",              actual["rsp"]["stat"]
    assert_equal nil,                 actual["rsp"]["post"]
    assert_match "Invalid Posterous", actual["rsp"]["err"]["msg"]
  end

  def test_add_post_is_private_by_default
    Posterous::Client.stubs(:post).returns(@post_success)
    actual = @new_obj.add_post
    assert_equal    "ok",               actual["rsp"]["stat"]
    assert_no_match @private_url_path,  actual["rsp"]["post"]["longurl"]
  end

  def test_add_post_is_made_private
    Posterous::Client.stubs(:post).returns(@post_private_good)
    @new_obj.set_to :private
    actual = @new_obj.add_post
    assert_equal "ok",                  actual["rsp"]["stat"]
    assert_match @private_url_path,     actual["rsp"]["post"]["longurl"]
  end

end