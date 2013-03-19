require 'fresh/auth/constants'

module Fresh
  module Auth
    class Configuration
      attr_writer :oauth_secret
      attr_accessor :url, :nonce_salt

      class Url
        attr_writer :subdomain
        attr_accessor :callback_url

        def callback_url
          raise "Freshbooks callback url must be without protocol, host and port. e.g /:controller/:action " if @callback_url.blank? or @callback_url.include?("http://")
          @callback_url
        end
        def subdomain
          raise "Freshbooks subdomain cannot be blank" if @subdomain.blank?
          @subdomain
        end

        def request
          base + "oauth/oauth_request.php"
        end

        def auth
          base + "oauth/oauth_authorize.php"
        end

        def access
          base + "oauth/oauth_access.php"
        end

        def api
          base + "api/2.1/xml-in"
        end
      private
        def base
          "https://#{@subdomain}.freshbooks.com/"
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
