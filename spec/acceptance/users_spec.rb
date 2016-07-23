require 'rails_helper'
require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do
	get "http://api.sale-sale-an.tk/users/:id" do
	# get "/users/:id" do
    parameter :id, "user ID"

    let(:user) { FactoryGirl.create :user }
    let(:id) { user.id }

    example "Get an user", :document => :public do
	  	# request = stub(host: 'local.example.com', port: 3000)

      do_request

      expect(status).to eql 200
    end
  end
end