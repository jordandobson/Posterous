require 'rubygems'
require 'httparty'

module Posterous

  VERSION = '0.1.6'

  class AuthError < StandardError; end
  class TagError  < StandardError; end
  class SiteError < StandardError; end

  ###
  ### FUTURE PLANS
  ###
  #   * Include media with your post
  #   * Post only a media file and get a url for it back
  #   * Allow reading in posterous posts
  #   * Include more usage examples outside of readme

  class Client

    DOMAIN      = 'posterous.com'
    POST_PATH   = '/api/newpost'
    AUTH_PATH   = '/api/getsites'
  
    include  HTTParty
    base_uri DOMAIN

    attr_accessor :title, :body, :source, :source_url, :date
    attr_reader   :private_post, :autopost, :site_id, :tags

    def initialize user, pass, site_id = nil
      raise AuthError, 'Either Username or Password is blank and/or not a string.' if \
        !user.is_a?(String) || !pass.is_a?(String) || user == "" || pass == ""
      self.class.basic_auth user, pass
      @site_id = site_id ? site_id.to_s : site_id
      @source = @body = @title = @source_url = @date = @media = @tags = @autopost = @private_post = nil
    end

    def site_id= id
      @site_id = id.to_s
    end

    def tags= ary
      raise TagError, 'Tags must added using an array' if !ary.is_a?(Array)
      @tags = ary.join(", ")
    end

    def valid_user?
      res = account_info
      return false unless res.is_a?(Hash)
      res["stat"] == "ok"
    end

    def has_site?
      res = account_info
      return false unless res.is_a?(Hash)
      
      case res["site"]
      when Hash
        return true unless @site_id
        return @site_id == res["site"]["id"]
      when Array
        res["site"].each do |site|
          return true if @site_id && @site_id == site["id"]
        end      
      end
      false
    end

    def primary_site
      res = account_info
      raise SiteError, "Couldn't find a primary site. Check login and password is valid." \
        unless res.is_a?(Hash) && res["stat"] == "ok" && res["site"]
      [res["site"]].flatten.each do |site|
        return site["id"] if site["primary"] == "true"
      end
      nil
    end

    def set_to on
      @private_post = 1 if on == :private
      @autopost     = 1 if on == :autopost
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

    def account_info
      self.class.post(AUTH_PATH, :query => {})["rsp"]
    end
    
    def add_post
      self.class.post(POST_PATH, :query => build_query)
    end
    
  end
end