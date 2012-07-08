module Dropbox
  module API

    class Connection

      module Requests

        def request(options = {})
          response = yield
          raise Dropbox::API::Error::ConnectionFailed if !response
          case response.status
            when 401
              raise Dropbox::API::Error::Unauthorized
            when 403
              parsed = MultiJson.decode(response.body)
              raise Dropbox::API::Error::Forbidden.new(parsed["error"])
            when 404
              raise Dropbox::API::Error::NotFound
            when 400, 406
              parsed = MultiJson.decode(response.body)
              raise Dropbox::API::Error.new(parsed["error"])
            when 300..399
              raise Dropbox::API::Error::Redirect
            when 500..599
              raise Dropbox::API::Error
            else
              options[:raw] ? response.body : MultiJson.decode(response.body)
          end
        end



        def get_raw(endpoint, path, data = {}, headers = {})
          request(:raw => true) do
            token(endpoint).get do |req|
              req.url "#{Dropbox::API::Config.prefix}#{path}"
              req.params.update(data)
              req.headers.update(headers)
            end
          end
        end

        def get(endpoint, path, data = {}, headers = {})
          request do
            token(endpoint).get do |req|
              req.url "#{Dropbox::API::Config.prefix}#{path}"
              req.params.update(data)
              req.headers.update(headers)
            end
          end
        end

        def post(endpoint, path, data = {}, headers = {})
          request do
            token(endpoint).post do |req|
              req.url "#{Dropbox::API::Config.prefix}#{path}"
              req.params.update(data)
              req.headers.update(headers)
            end
          end
        end

        def put(endpoint, path, data = '', headers = {})
          request do
            token(endpoint).put do |req|
              req.url "#{Dropbox::API::Config.prefix}#{path}"
              req.body = data
              req.headers.update(headers)
            end
          end
        end

      end

    end

  end
end
