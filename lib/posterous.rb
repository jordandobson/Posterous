require 'rubygems'
require 'httparty'

class PosterousAuthError < StandardError; end

class Posterous
  VERSION     = '0.1.0'
  DOMAIN      = 'posterous.com'
  POST_PATH   = '/api/newpost'
  AUTH_PATH   = '/api/getsites'

  include HTTParty
  # HTTParty Specific
  base_uri DOMAIN

  attr_accessor :title, :body, :source, :source_link
  attr_reader   :site_id

  def initialize user, pass, site_id = false
    raise PosterousAuthError, 'Either Username or Password is blank and/or not a string.' if \
      !user.is_a?(String) || !pass.is_a?(String) || user == "" || pass == ""
    self.class.basic_auth user, pass
    @site_id = site_id ? site_id.to_s : site_id
  end

  def valid_user?
    res = ping_account
    return false unless res.is_a?(Hash)
    res["stat"] == "ok" ? true : false
  end
  
  def get_primary_site
    # Set the site_id to the primary account if multiple or to the only one that exists or raise
  end

  def has_site?
    res = ping_account
    return false unless res.is_a?(Hash)
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
    self.class.post(AUTH_PATH, :query => {})["rsp"]
  end

  def add_post
    self.class.post(POST_PATH, :query => {
      :site_id => @site_id, :title => @title, :body => @body, :source => @source, :sourceLink => @source_link}) if has_site?
  end

end