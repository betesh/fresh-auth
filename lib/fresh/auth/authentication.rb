require 'fresh/auth/constants'
require 'fresh/auth/parameters'

module Fresh
  module Auth
    module Authentication

      def AuthenticateWithFreshbooks _redirect_url
        @redirect_url = _redirect_url
        if !session.has_key? Key::Session
          Request() and return if !params.has_key? Key::Verifier
          Access() and redirect_to _redirect_url
        end
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
        _response = ParseHttpResponse RestClient.post(Url::Request, Parameters.Request(@redirect_url))
        redirect_to "#{Url::Auth}?#{Key::AuthToken}=#{_response[Key::AuthToken]}"
      end

      def Access
        _response = ParseHttpResponse RestClient.post(Url::Access, Parameters.Access(params))
        session[Key::Session] = {
          Key::AuthToken => _response[Key::AuthToken],
          Key::AuthSecret => _response[Key::AuthSecret]
        }
      end
    end
  end
end
