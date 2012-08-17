require 'fresh/auth/constants'

module Fresh
  module Auth
    module Parameters
      def Parameters.ANewNonce
        Digest::SHA2.hexdigest(Time.now.to_i.to_s + NonceSalt + Random.new.rand.to_s)[0,20]
      end

      def Parameters.Common
        { :oauth_timestamp => Time.now.to_i, :oauth_nonce => ANewNonce() }.merge ConstantParams
      end

      def Parameters.Request _redirect_url
        { :oauth_callback => _redirect_url }.merge Common()
      end

      def Parameters.Access params
        params.keep_if { |k, v| [Key::AuthToken, Key::Verifier].include? k }.merge Common()
      end
    end
  end
end
