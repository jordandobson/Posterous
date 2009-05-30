require 'rubygems'
require 'httparty'

class PosterousAuthError < StandardError; end
class PosterousTagError  < StandardError; end
class PosterousSiteError < StandardError; end

###
### FUTURE PLANS
###
#   * Include media with your post
#   * Post only a media file and get a url for it back
#   * Allow reading in posterous posts
#   * Include more usage examples outside of readme

class Posterous

  VERSION     = '0.1.2'
  DOMAIN      = 'posterous.com'
  POST_PATH   = '/api/newpost'
  AUTH_PATH   = '/api/getsites'

  include HTTParty
  base_uri DOMAIN

  attr_accessor :title, :body, :source, :source_url, :date, :tags
  attr_reader   :site_id, :private_post, :autopost

  def initialize user, pass, site_id = nil
    raise PosterousAuthError, 'Either Username or Password is blank and/or not a string.' if \
      !user.is_a?(String) || !pass.is_a?(String) || user == "" || pass == ""
    self.class.basic_auth user, pass
    @site_id = site_id ? site_id.to_s : site_id
    @source = @body = @title = @source_url = @date = @media = @tags = nil
  end

  def site_id= id
    @site_id = id.to_s
  end
  def tags= ary
    raise PosterousTagError, 'Tags must add from be in an array' if !ary.is_a?(Array)
    @tags = ary.join(", ")
  end

  def valid_user?
    res = get_account_info
    return false unless res.is_a?(Hash)
    res["stat"] == "ok" ? true : false
  end

  def has_site?
    res = get_account_info
    return false unless res.is_a?(Hash)
    if res["site"].is_a?(Hash)
      @site_id && @site_id == res["site"]["id"] || !@site_id ? true : false
    elsif res["site"].is_a?(Array)
      res["site"].each do |site|
        return true if @site_id && @site_id == site["id"]
      end
      false
    else
      false
    end
  end

  def get_primary_site
    res = get_account_info
    raise PosterousSiteError, "Couldn't find a primary site. Check login and password is valid." \
      unless res.is_a?(Hash) && res["stat"] == "ok" && res["site"]
    site_list = res["site"].is_a?(Array) ? res["site"] : [res["site"]]
    site_list.each do |site|
      return site["id"] if site["primary"] == "true"
    end
    return nil
  end

  def set_to_private
    @private_post = 1
  end

  def set_to_autopost
    @autopost = 1
  end

  def build_query
    options = { :site_id    => @site_id,
                :autopost   => @autopost,
                :private    => @private_post,
                :date       => @date,
                :tags       => @tags }

    query   = { :title      => @title,
                :body       => @body,
                :source     => @source,
                :sourceLink => @source_url }

    options.delete_if { |k,v| !v }
    query.merge!(options)
  end

  def get_account_info
    self.class.post(AUTH_PATH, :query => {})["rsp"]
  end
  
  def add_post
    self.class.post(POST_PATH, :query => build_query)
  end
  
end