require 'fresh/auth/configuration'
require 'fresh/auth/constants'
require 'fresh/auth/parameters'

module Fresh
  module Auth
    module Authentication
      def AuthenticateWithFreshbooks
        @redirect_url = "http://#{request.host_with_port}#{Fresh::Auth.configuration.url.callback_url}"
        Request()
=begin
        @redirect_url = request.url.split("?")[0]
        if !session.has_key? Key::SESSION
          Request() and return if !params.has_key? Key::VERIFIER
          Access() and redirect_to @redirect_url
        end
=end
      end
      
      def AccessOfFreshbooks
        Access()
      end
      
private
      def ParseHttpResponse _response
        _hash = {}
        _response.split('&').collect{ |v|
          elem = v.split('=')
          { elem[0] => elem[1] }
        }.each { |k| _hash.merge! k}
        _hash
      end

      def Request
        _response = ParseHttpResponse RestClient.post(Fresh::Auth.configuration.url.request, Parameters.Request(@redirect_url))
        redirect_to "#{Fresh::Auth.configuration.url.auth}?#{Key::AUTH_TOKEN}=#{_response[Key::AUTH_TOKEN]}"
      end

      def Access
        _response = ParseHttpResponse RestClient.post(Fresh::Auth.configuration.url.access, Parameters.Access(params))
        session[Key::SESSION] = {
          Key::AUTH_TOKEN => _response[Key::AUTH_TOKEN],
          Key::AUTH_SECRET => _response[Key::AUTH_SECRET]
        }
      end
    end
  end
end
