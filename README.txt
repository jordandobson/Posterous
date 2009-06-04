= posterous

http://github.com/jordandobson/Posterous/tree/master

== DESCRIPTION:

The Posterous gem provides posting to Posterous.com using your email, password, site id(if you have multiple sites) and your blog content. With this gem, you have access to add an entry on posterous by providing these options a title, body text, date, tags, set to autopost, set private, posted by source name and a posted by source link to Posterous. You can include no options, all options or anything in between. 

Posting images with posts, posting only images and pulling down your posts will be available very soon. 

== FEATURES/PROBLEMS:

* All Fields are optional
* Media files are not yet implemented
* Posting Only, Reading & Images are not yet included
* Check if a users email and password are a valid account
* Check if a user has a valid site
* Check if a specified site_id is valid for their account
* Get their primary Site ID
* This is very throughly tested

== SYNOPSIS:

1. Instantiate your account

    * You can provide just the email and password
    
        account = Posterous::Client.new('email_address', 'password')
      
    * Or you can provide the ID as a string or integer

        account = Posterous::Client.new('email_address', 'password', 68710)
        account = Posterous::Client.new('email_address', 'password', '68710')

2. Get more info about the user's account if you need it

    * Check if the user is valid
    
        account.valid_user?
      
    * Check if the user has a site AND if you've entered a Site ID, check it's valid too
    
        account.has_site?
      
    * Get the users primary site ID (In case they have multiple sites)
    
        account.primary_site
      
    * Get a list of your sites and additional info
    
        account.account_info

3. Setup your post with any or all of these optional fields

    * You can set your id at this point or at the begining when it's instantiated
    
        account.site_id         = account.get_primary_site or specific site ID

    * Set these optional fields
    
        account.title           = "My Title"
        account.body            = "My Body Text"
        account.source          = "Glue"
        account.source_url      = "http://GlueNow.com"
        account.tags            = ["Glue", "Posterous", "Ruby", "Made By Squad"]
        account.date            = Time.now
    
    * Call the set_to method with either :private or :autopost to apply that setting
    
        account.set_to :private
        account.set_to :autopost

4. Add your post to Posterous.com

    * Set this to a variable to work with the response
    
        response = account.add_post

5. You get a success or error hash back or nil

    * Your response should look something like this if successful
    
    response #=> { "rsp" => { "post" => { "title"   => "My Title", "url" => "http://post.ly/dFW", "id" => "848898", "longurl" => "http://glue.posterous.com/687985" },  "stat" => "ok" } }
    
    * See the tests for this gem for failure responses and responses for other methods


# MORE INFO

  * URL
  
    http://posterous.com/api/newpost

  * IMPLEMENTED FIELDS - All are optional
  
    "site_id"     Optional. Id of the site to post to. 
    "title"       Optional. Title of post
    "body"        Optional. Body of post
    "source"      Optional. The name of your application or website
    "sourceLink"  Optional. Link to your application or website
    "date"        Optional. In GMT. Any parsable format. Cannot be in the future.
    "tags"        Optional. Comma separate tags
    "autopost"    Optional. 0 or 1.
    "private"     Optional. 0 or 1.

  * UNIMPLEMENTED FIELDS - These will likely be implemented in a future release

    "media"       Optional. File data. Multiple files OK

== REQUIREMENTS:

* HTTPparty, & Mocha (For Tests)

== INSTALL:

* sudo gem install posterous -include-dependencies

== LICENSE:

(The MIT License)

Copyright (c) 2009 Jordan Dobson

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
