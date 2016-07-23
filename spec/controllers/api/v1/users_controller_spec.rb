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

	describe "POST #create" do
		context "when successfully created" do
			before(:each) do
				@user_attributes = FactoryGirl.attributes_for :user
				post :create, { user: @user_attributes }, format: :json
			end

			it "renders the new user" do
				expect_json(email: @user_attributes[:email])
			end

			it { should respond_with 201}
		end

		context "when not create" do
			before(:each) do
				@invalid_user_attributes = { password: "12341234", 
																		 password_confirmation: "12341234" }
				post :create, { user: @invalid_user_attributes }, format: :json
			end

			it "renders errors json" do
				expect_json_keys('errors', [:email])
			end

			it "renders errors and reasons" do
				expect_json('errors', email: ["can't be blank"])
			end

			it { should respond_with 422 }
		end
	end

	describe "PUT/PATCH #update" do
		context "when successfully updated" do
			before(:each) do
				@user = FactoryGirl.create :user
				patch :update, { id: @user.id, 
												 user: { email: "new_email@gmail.com"} }, format: :json
			end

			it "renders json with updated data" do
				expect_json(email: "new_email@gmail.com")
			end

			it { should respond_with 200 }
		end

		context "when is not created" do
			before(:each) do
				@user = FactoryGirl.create :user
				patch :update, { id: @user.id, 
												 user: { email: "new_emailgmail.com"} }, format: :json
			end

			it "renders errors json" do
				expect_json_keys('errors', [:email])
			end

			it "renders errors json and reasons" do
				expect_json('errors', email: ["is invalid"])
			end

			it { should respond_with 422 }
		end
	end
end