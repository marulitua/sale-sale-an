require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

	describe "POST #create" do
		before(:each) do
			@user = FactoryGirl.create :user
		end

		context "when the credentials are correct" do
			before(:each) do
				credentials = { email: @user.email, password: "12345678" }
				post :create, { session: credentials }
			end

			it "returns the user record corresponding to the given credentials" do
				@user.reload
				expect_json('user', auth_token: @user.auth_token)
			end

			it { should respond_with 200 }
		end

		context "when the credentials are incorenct" do
			before(:each) do
				credentials = { email: @user.email, password: "123412345" }
				post :create, { session: credentials }
			end

			it "returns json with error message" do
				expect_json('errors', "Invalid email or password")
			end

			it { should respond_with 422 }
		end
	end

	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			sign_in @user
			delete :destroy, id: @user.auth_token
		end

		it { should respond_with 204 }
	end
end
