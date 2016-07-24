require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do

	describe "GET #show" do
		before(:each) do
			@product = FactoryGirl.create :product
			get :show, id: @product.id
		end

		it "returns the information about a product" do
			expect_json('product', title: @product.title)
		end

		it "has embeded user" do
			expect_json("product.user.email", @product.user.email)
		end

		it { should respond_with 200 }
	end

	describe "GET #index" do
		before(:each) do
			4.times { FactoryGirl.create :product }
			get :index
		end

		context "when not receiving any product_ids parameter" do
			before(:each) do
				get :index
			end

			it "returns  4 recornds from the database" do
				expect_json_sizes(products: 4)
			end

			it "products containt user object" do
				expect_json_types('products.*', user: :object)
			end
		end

		context "when products_ids parameter is sent" do
			before(:each) do
				@user = FactoryGirl.create :user
				3.times { FactoryGirl.create :product, user: @user }
				get :index, product_ids: @user.product_ids
			end

			it "returns just the products that belong to the user" do
				expect_json('products.*.user', email: @user.email)
			end
		end

		it { should respond_with 200 }
	end

	describe "POST #create" do
		context "when is created" do
			before(:each) do
				user = FactoryGirl.create :user
				@product_attributes = FactoryGirl.attributes_for :product
				api_authorization_header user.auth_token
				post :create, { user_id: user.id, product: @product_attributes }
			end

			it "renders json with product" do
				expect_json('product', title: @product_attributes[:title])
			end

			it { should respond_with 201 }
		end
		
		context "when is not created" do
			before(:each)	do
				user = FactoryGirl.create :user
				@invalid_product_attributes = { title: "Handuk", price: "sepuluh ribu" }
				api_authorization_header user.auth_token
				post :create, { user_id: user.id, product: @invalid_product_attributes }
			end

			it "renders error" do
				expect_json_keys('errors', [:price])
			end

			it "renders the errors message" do
				expect_json('errors', price: ["is not a number"])
			end

			it { should respond_with 422 }
		end
	end

  describe "PUT/PATCH #update" do
  	before(:each) do
    	@user = FactoryGirl.create :user
    	@product = FactoryGirl.create :product, user: @user
    	api_authorization_header @user.auth_token 
  	end

  	context "when is successfully updated" do
    	before(:each) do
      	patch :update, { user_id: @user.id, id: @product.id, product: { title: "Handuk Basah" } }
    	end

    	it "renders the json representation for the updated user" do
      	expect_json('product', title: "Handuk Basah")
    	end

    	it { should respond_with 200 }
  	end

  	context "when is not updated" do
    	before(:each) do
      	patch :update, { user_id: @user.id, id: @product.id, product: { price: "two hundred" } }
    	end

    	it "renders an errors json" do
				expect_json_keys('errors', [:price])
    	end

    	it "renders the json errors on whye the user could not be created" do
				expect_json('errors', price: ["is not a number"])
    	end

    	it { should respond_with 422 }
  	end
	end

	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			@product = FactoryGirl.create :product, user: @user
			api_authorization_header @user.auth_token
			delete :destroy, { user_id: @user.id, id: @product.id }
		end

		it { should respond_with 204 }
	end
end
