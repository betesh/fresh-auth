# Fresh::Auth

This gem makes it really, REALLY easy to use the Freshbooks API.  It couldn't be easier.

With only 3 functions you'll ever need to use, and only 3 configuration values (all required), it can't get any easier.

## Installation

Add this line to your application's Gemfile:
    gem 'fresh-auth'
And then execute:
    $ bundle
Or install it yourself as:
    $ gem install fresh-auth

## Usage

### Configuration:

You must define your freshbooks subdomain and your OAuth Secret in your application code before gems are loaded.  For Ruby on Rails apps, a new file in config/fresh-auth.rb would be appropriate.  To load the configuration before loading the gem, add a line to config/boot.rb (anywhere in the file) to require the configuration file, i.e.: `require File.expand_path('../fresh-auth', __FILE__)`.  Ya, I know, it's a little hack-ish, but does the job.

Your configuration file should look like this (you fill in the three empty strings):

`
#module Fresh
#  module Auth
#    module Url
#      # The part of your login url between 'http://' and '.freshbooks.com'
#      Subdomain = ""
#    end

#    # Under 'My Account' (on the top right when you're logged into Freshbooks)
#    #   -> 'Freshbooks API' -> 'OAuth Developer Access' -> 'OAuth Secret'
#    # You'll need to request this from Freshbooks initially.
#    OAuthSecret = ""

#    # Any string of your choice.  Be creative or check out http://www.thebitmill.com/tools/password.html
#    NonceSalt = ""
#  end
#end
`

### Public API:

There are two modules in this API: Fresh::Auth::Authentication and Fresh::Auth::Api

#### Fresh::Auth::Authentication

This module authenticates you with Freshbooks, storing the authentication in an array called `session`.  This integrates seamlessly with Ruby on Rails' controller environment.  If you're using some framework other than Ruby on Rails, make sure to define session in your class before including the Authentication module.  This isn't recommended because your class will also need to define another object called `params` and implement a `redirect_to` method.  It gets complicated.  Better leave it to Rails to handle this for you.

The only public function of this module is AuthenticateWithFreshbooks.  It takes one argument, redirect, which is the url that you would like Freshbooks to redirect the user to once user has logged into Freshbooks and is redirected to your site.

To use it, just add the following line of code to your controller:
`
include Fresh::Auth::Authentication
`

Then, the following line of code authenticates with Freshbooks from any method in your controller:
`
AuthenticateWithFreshbooks redirect
`

#### Fresh::Auth::Api

Once you've authenticated, you want to send XML requests to Freshbooks.  The first step is preparing the XML with Fresh::Auth::Api.GenerateXml, which you'll supply with a block that defines all the nested XML that you want in your request.  GenerateXml also takes two arguments before the block: the class and method that you want to call.

First, in your controller:
`include Fresh::Auth::Api`

Then, in some method in that controller:

`
#my_xml = GenerateXml :invoice, :update do |xml|
#  xml.client_id 20
#  xml.status 'sent'
#  xml.notes 'Pick up the car by 5'
#  xml.terms 'Cash only'
#  xml.lines {
#    xml.line {
#      xml.name 'catalytic converter'
#      xml.quantity 1
#      xml.unit_cost 450
#      xml.type 'Item'
#    }
#    xml.line {
#      xml.name 'labor'
#      xml.quantity 1
#      xml.unit_cost 60
#      xml.type 'Time'
#    }
#  }
#end
`

Ok, you created the XML.  Now you want to send it.  Sounds pretty complicated, right?  No at all! Ready?  Let's go!

`_response = PostToFreshbooksApi my_xml`

Now, are you wondering what's in `_response`?  I'll tell you shortly, but before we discuss that, we have to know about the exception that PostToFreshbooksApi might raise.  It raises a detailed error message if the respons status is not 'ok'.  Makes sense, right?

Now, you still want to know what's in `_response`?  Oh, nothing fancy.  Just a Nokogiri XML object, representing the root element of the xml response.  Could this get any easier?

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
