module Fresh
  module Auth
    module Key
      SIGNATURE = "oauth_signature"
      AUTH_TOKEN = "oauth_token"
      AUTH_SECRET = "oauth_token_secret"
      VERIFIER = "oauth_verifier"
      SESSION = "freshbooks_oauth"
    end

    class Configuration
      attr_writer :oauth_secret
      attr_accessor :url, :nonce_salt

      class Url
        attr_writer :subdomain

        def subdomain
          raise "Fresh::Auth.configuration.url.subdomain cannot be blank" if @subdomain.blank?
          @subdomain
        end

        def base
          "https://#{@subdomain}.freshbooks.com/"
        end

        def request
          self.base + "oauth/oauth_request.php"
        end

        def auth
          self.base + "oauth/oauth_authorize.php"
        end

        def access
          self.base + "oauth/oauth_access.php"
        end

        def api
          self.base + "api/2.1/xml-in"
        end
      end

      def initialize
        @url = Url.new
        @nonce_salt = ''
      end

      def oauth_secret
        raise "Fresh::Auth.configuration.oauth_secret cannot be blank" if @oauth_secret.blank?
        @oauth_secret
      end
    end

    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def constant_params
        {
          :oauth_consumer_key => @configuration.url.subdomain,
          :oauth_signature_method => "PLAINTEXT",
          Key::SIGNATURE => @configuration.oauth_secret+'&',
          :oauth_version => 1.0
        }
      end
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield configuration
    end
  end
end
