require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do

	describe "GET #index" do
		before(:each) do
			current_user = FactoryGirl.create :user
			api_authorization_header current_user.auth_token
			4.times { FactoryGirl.create :order, user: current_user }
			get :index, user_id: current_user.id
		end

		it "returns 4 order records from the user" do
			expect_json_sizes(orders: 4)
		end

		it { should respond_with 200 }
	end

	describe "GET #show" do
		before(:each) do
			current_user = FactoryGirl.create :user
			api_authorization_header current_user.auth_token

			@product = FactoryGirl.create :product
			@order = FactoryGirl.create :order, user: current_user, product_ids: [@product.id]
			get :show, user_id: current_user.id, id: @order.id
		end

		it "returns the user order record matching the id" do
			expect_json("order", id: @order.id)
		end

		it "includes the total for the order" do
			expect_json("order", total: @order.total.to_s)
		end

		it "includes the products on the order" do
			expect_json_sizes("order.products", 1)
		end

		it { should respond_with 200 }
	end

	describe "POST #create" do
		before(:each) do
			current_user = FactoryGirl.create :user
			api_authorization_header current_user.auth_token

			product_1 = FactoryGirl.create :product
			product_2 = FactoryGirl.create :product
			order_params = { product_ids: [product_1.id, product_2.id] }
			post  :create, user_id: current_user.id, order: order_params
		end

		it "returns only users record" do
			expect_json_types('order.id', :int)
		end

		it { should respond_with 201 }
	end	
end
