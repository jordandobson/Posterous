require 'rubygems'
require 'httparty'

class PosterousAuthError < StandardError; end

class Posterous
  VERSION     = '0.1.0'
  DOMAIN      = 'posterous.com'
  POST_PATH   = '/api/newpost'
  AUTH_PATH   = '/api/getsites'
  SOURCE      = 'Glue'
  SOURCELINK  = 'http://GlueNow.com'
  
  include HTTParty
  # HTTParty Specific
  base_uri DOMAIN
  
  attr_accessor :title, :body, :site_id
  
  def initialize user, pass, site_id = false
    raise PosterousAuthError, 'Either Username or Password is blank and/or not a string.' if \
      !user.is_a?(String) || !pass.is_a?(String) || user == "" || pass == "" 
    self.class.basic_auth user, pass
    @site_id = site_id ? site_id.to_s : site_id
  end

  def valid_user?
    res = ping_account["rsp"]
    res["stat"] == "ok" ? true : false
  end
  
  def has_site?
    res = ping_account["rsp"]
    if res["site"].is_a?(Hash)        # Check for single site and a specific id if specified
      @site_id && @site_id == res["site"]["id"] || !@site_id ? true : false
    elsif res["site"].is_a?(Array)   # Check lists sites and that the specified site id is present
      res["site"].each do |site|
        return true if @site_id && @site_id == site["id"]
      end
      false
    else
      false
    end
  end
  
  def ping_account
    self.class.post(AUTH_PATH, :query => {})
  end
  
  def add_post
    self.class.post(POST_PATH, :query => {
      :site_id => @site_id, :title => @title, :body => @body, :source => SOURCE, :sourceLink => SOURCELINK})
  end
  
end
