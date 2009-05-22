= posterous

* FIX (url)

== DESCRIPTION:

account = Posterous.new('info@gluenow.com', 'Password1')
account = Posterous.new('info@gluenow.com', 'Password1', 68710)
account = Posterous.new('info@gluenow.com', 'Password1', '68710')

account.valid_user?
account.has_site?
account.title = "My Title"
account.body  = "My Body Text"


# URL
http://posterous.com/api/newpost

# FIELDS
"site_id"     Optional. Id of the site to post to. If not supplied, posts to the user's default site
"media"       Optional. File data. Multiple files OK
"title"       Optional. Title of post
"body"        Optional. Body of post
"autopost"    Optional. 0 or 1.
"private"     Optional. 0 or 1.
"source"      Optional. The name of your application or website
"sourceLink"  Optional. Link to your application or website
 
# References 
http://posterous.com/api/posting
http://fakeweb.rubyforge.org/
http://github.com/jnunemaker/httparty/tree/master

== FEATURES/PROBLEMS:

* FIX (list of features or problems)

== SYNOPSIS:

  FIX (code sample of usage)

== REQUIREMENTS:

* FIX (list of requirements)

== INSTALL:

* FIX (sudo gem install, anything else)

== LICENSE:

(The MIT License)

Copyright (c) 2009 FIX

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
