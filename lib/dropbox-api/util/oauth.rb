module Dropbox
  module API

    module OAuth

      class Consumer

        attr_accessor :options, :key, :secret
        
        def initialize(consumer_key, consumer_secret, options = {})
          @options = options
          @key = consumer_key
          @secret = consumer_secret
          @connection = Faraday.new options[:site] do |faraday|
            faraday.request :oauth,
              :consumer_key => consumer_key,
              :consumer_secret => consumer_secret
            faraday.adapter Faraday.default_adapter
          end
        end

        def get_request_token
          response = @connection.post @options[:request_token_path]
          params = CGI::parse(response.body)
          RequestToken.new(self, params['oauth_token'].first, params['oauth_token_secret'].first)
        end

        def authorize_url
          @options[:site] + @options[:authorize_path]
        end

      end

      class RequestToken

        attr_accessor :token, :secret

        def initialize(consumer, token, secret)
          @consumer = consumer
          @token = token
          @secret = secret
          @connection = Faraday.new @consumer.options[:site] do |faraday|
            faraday.request :oauth,
              :consumer_key => @consumer.key,
              :consumer_secret => @consumer.secret,
              :token => token,
              :token_secret => secret
            faraday.adapter Faraday.default_adapter
          end
        end

        def authorize_url(params = {})
          params.update(:oauth_token => @token)
          build_authorize_url(@consumer.authorize_url, params)
        end

        def get_access_token(*arguments)
          response = @connection.post @consumer.options[:access_token_path]
          params = CGI::parse(response.body)
          AccessToken.new(params['oauth_token'].first, params['oauth_token_secret'].first)
        end

        protected

        def build_authorize_url(base_url, params)
          uri = URI::parse(base_url)
          uri.query = params.map { |k, v| [k, CGI::escape(v)] * "=" } * "&"
          uri.to_s
        end

      end

      AccessToken = Struct.new(:token, :secret)

      class << self

        def consumer(endpoint)
          if !Dropbox::API::Config.app_key or !Dropbox::API::Config.app_secret
            raise Dropbox::API::Error::Config.new("app_key or app_secret not provided")
          end
          Consumer.new(Dropbox::API::Config.app_key, Dropbox::API::Config.app_secret,
            :site => Dropbox::API::Config.endpoints[endpoint],
            :request_token_path => Dropbox::API::Config.prefix + "/oauth/request_token",
            :authorize_path     => Dropbox::API::Config.prefix + "/oauth/authorize",
            :access_token_path  => Dropbox::API::Config.prefix + "/oauth/access_token")
        end

        def access_token(consumer, options = {})
          Faraday.new consumer.options[:site] do |faraday|
            faraday.request :oauth,
              :consumer_key => Dropbox::API::Config.app_key,
              :consumer_secret => Dropbox::API::Config.app_secret,
              :token => options[:token],
              :token_secret => options[:secret]
            faraday.adapter Faraday.default_adapter
          end
        end

      end

    end

  end
end

