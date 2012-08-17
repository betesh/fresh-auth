require 'fresh/auth/constants'
require 'fresh/auth/parameters'
require 'rest_client'
require 'builder'
require 'nokogiri'

module Fresh
  module Auth
    module Api
      def GenerateXml klass, method, &block
        xml = Builder::XmlMarkup.new( :indent => 2 )
        xml.instruct! :xml, :encoding => "utf-8"
        xml.request :method => "#{klass}.#{method}" do |req|
          yield xml
        end
      end

      def PostToFreshbooksApi xml
        root = Nokogiri::XML(RestClient.post Url::Api, xml, HttpHeaders()).root
        raise "Request to Freshbooks API failed:\n#{root}" if "ok" != root.attributes["status"].to_s
        root
      end
private
      def HttpHeaders
        _header = {
          :'OAuth realm' => "",
          Key::AuthToken => session[Key::Session][Key::AuthToken]
        }.merge Parameters.Common()
        _header[Key::Signature] += session[Key::Session][Key::AuthSecret]
        val = ""
        _header.collect{ |k, v| val += "#{k}=\"#{v}\","}
        { :Authorization => val.chomp(",") }
      end
    end
  end
end
