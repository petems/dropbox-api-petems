require "cgi"
require "spec_helper"

describe Dropbox::API::OAuth, vcr: true do

  describe ".consumer" do

    it "raises an error if config options are not provided" do
      Dropbox::API::Config.stub(:app_key).and_return(nil)
      lambda {
        Dropbox::API::OAuth.consumer :main
      }.should raise_error(Dropbox::API::Error::Config)
    end

    it 'provides an oauth method' do
      consumer = Dropbox::API::OAuth.consumer(:authorize)
      request_token = consumer.get_request_token

      request_token.should be_an_instance_of Dropbox::API::OAuth::RequestToken

      query  = request_token.authorize_url.split('?').last
      params = CGI.parse(query)
      token  = params['oauth_token'].first

      puts request_token.authorize_url

      access_token = request_token.get_access_token(:oauth_verifier => token)

      access_token.should be_an_instance_of Dropbox::API::OAuth::AccessToken

      access_token.token.should eql 'a2ciyl7yub973lyn'
      access_token.secret.should eql 't0fvldsdirbvhqz'
    end

  end

end

