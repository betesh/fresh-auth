module Fresh
  module Auth
    module Url
      Base = "https://#{Subdomain}.freshbooks.com/"
      Request = Base+"oauth/oauth_request.php"
      Auth = Base+"oauth/oauth_authorize.php"
      Access = Base+"oauth/oauth_access.php"
      Api = Base+"api/2.1/xml-in"
    end

    module Key
      Signature = "oauth_signature"
      AuthToken = "oauth_token"
      AuthSecret = "oauth_token_secret"
      Verifier = "oauth_verifier"
      Session = "freshbooks_oauth"
    end

    ConstantParams = {
      :oauth_consumer_key => Url::Subdomain,
      :oauth_signature_method => "PLAINTEXT",
      Key::Signature => OAuthSecret+'&',
      :oauth_version => 1.0
    }
  end
end
