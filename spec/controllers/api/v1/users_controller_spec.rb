require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
	before(:each) { request.headers['Accept'] = "application/vnd.sale-sale-an.v1" }

	describe "GET #show" do
		before(:each) do
			@user = FactoryGirl.create :user
	    # sign_in
			get :show, id: @user.id, format: :json
		end

		it "returns the information about user" do
			user_response = JSON.parse(response.body, symbolize_names: true)
			expect(user_response[:email]).to eql @user.email
		end

		it { should respond_with 200 }
	end
end
