require 'rubygems'
require 'httparty'
require 'base64'

class PosterousAuthError < StandardError; end

# NEXT STEPS
# include a file or multiple files
# include tags
# get and set primary id
# include reading posts
# build gem
# post on rubyforge

class Posterous
  VERSION     = '0.1.0'
  DOMAIN      = 'posterous.com'
  POST_PATH   = '/api/newpost'
  AUTH_PATH   = '/api/getsites'

  include HTTParty
  # HTTParty Specific
  base_uri DOMAIN

  attr_accessor :title, :body, :source, :source_url, :date
  attr_reader   :site_id, :private_post, :autopost, :media

  def initialize user, pass, site_id = nil
    raise PosterousAuthError, 'Either Username or Password is blank and/or not a string.' if \
      !user.is_a?(String) || !pass.is_a?(String) || user == "" || pass == ""
    self.class.basic_auth user, pass
    @site_id = site_id ? site_id.to_s : site_id
    @title = @body = @source = @source_url = @date = @media = nil
  end
  
  def site_id= val
    @site_id = val.to_s
  end
  
  def valid_user?
    res = ping_account
    return false unless res.is_a?(Hash)
    res["stat"] == "ok" ? true : false
  end

  def has_site?
    res = ping_account
    return false unless res.is_a?(Hash)
    if res["site"].is_a?(Hash)        # Check for single site and a specific id if specified
      @site_id && @site_id == res["site"]["id"] || !@site_id ? true : false
    elsif res["site"].is_a?(Array)    # Check lists sites and that the specified site id is present
      res["site"].each do |site|
        return true if @site_id && @site_id == site["id"]
      end
      false
    else
      false
    end
  end
  
  def set_to_private
    @private_post = 1
  end
  
  def set_to_autopost
    @autopost = 1
  end

  def add_post
    self.class.post(POST_PATH, :query => build_query)
  end

  def build_query
    options           = { :site_id    => @site_id,
                          :media      => @media,
                          :autopost   => @autopost,
                          :private    => @private_post,
                          :date       => @date }
    query             = { :title      => @title,
                          :body       => @body,
                          :source     => @source,
                          :sourceLink => @source_url }
                          
    #Clean out any empty options &  merge
    options.delete_if { |k,v| !v }  
    query.merge!(options)
  end

  def ping_account
    self.class.post(AUTH_PATH, :query => {})["rsp"]
  end
  
end


#   def get_media_data
#     if @media
#       #IO.read(@media)
#       #File.open(@media, 'rb') { |f| f.read }
#       @media
#     else
#       false
#     end
#   end
#     m       = get_media_data
#     media   = m         ? { :media   => Base64.encode64(m)      } : {}
