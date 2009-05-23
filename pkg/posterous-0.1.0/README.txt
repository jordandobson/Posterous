= posterous

http://github.com/jordandobson/Posterous/tree/master

== DESCRIPTION:

The Posterous gem provides posting to Posterous.com using your email, password, site id(if you have multiple sites) and your blog content. With this gem, you have access to post a title, body text, posting source and a source link to Posterous.

Posting images and pulling down your posts will be available soon. They were made available a day before this was completed.

== FEATURES/PROBLEMS:

* All Fields are optional
* Media, AutoPost & Private are not yet implemented
* Posting Only, Reading & Images are not yet included
* Allows you to see if a users email and password are valid
* Allows you to check if a user has a valid site
* Allows you to check if a specified site_id is valid for their account


== SYNOPSIS:

# Instantiate your account 
account = Posterous.new('email_address', 'password')
account = Posterous.new('email_address', 'password', 68710)
account = Posterous.new('email_address', 'password', '68710')

# Check if the user is valid
account.valid_user?

# Check if the user has a site and if they specified a Site ID check it's valid
account.has_site?

# Setup your post
account.title = "My Title"
account.body  = "My Body Text"
account.source = "Glue"
account.source_url  = "http://GlueNow.com"

# Add your post to Posterous.com
account.add_post

# Get a success or error hash back or nil


# URL
http://posterous.com/api/newpost

# IMPLEMENTED FIELDS - All are optional
"site_id"     Optional. Id of the site to post to. 
"title"       Optional. Title of post
"body"        Optional. Body of post
"source"      Optional. The name of your application or website
"sourceLink"  Optional. Link to your application or website

# UNIMPLEMENTED FIELDS - These will likely be implemented in a future release
"autopost"    Optional. 0 or 1.
"private"     Optional. 0 or 1.
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
