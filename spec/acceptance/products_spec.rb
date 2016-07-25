require 'rails_helper'
require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "User", acceptance: true do
	before do
		10.times { FactoryGirl.create :user }
		100.times { FactoryGirl.create :product, user: User.offset(rand(User.count)).first }
  end

  get "http://api.sale-sale-an.tk/products" do
    example_request "Listing Products" do
      explanation "List all the products in the shop"
      expect(status).to eq 200
    end

    parameter :keyword, "Search products by title"
    parameter :min_price, "Search products with minimum price"
    parameter :max_price, "Search products with maximum price"
    parameter :product_ids, "Search products by its ID"
    parameter :recent, "Order by last update"
    parameter :page, "Page to view"
    parameter :per_page, "Number of products per page"
    example "Get products by params" do
      explanation "Get products by params"

      do_request(:keyword => 'System')
      expect(status).to eq 200

      do_request(:min_price => 300)
      expect(status).to eq 200

      do_request(:max_price => 300, :keyword => 'Digital')
      expect(status).to eq 200
    end
  end

  # get "/api/users/:id" do
  #   let(:id) { user.id }
  #   example_request "Getting a specific user" do
  #     expect(status).to eq(200)
  #   end
  # end
end
