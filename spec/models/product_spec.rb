require 'rails_helper'

RSpec.describe Product, type: :model do
	let(:product) { FactoryGirl.build :product }
	subject { product }

	it { should respond_to (:title) }
	it { should respond_to (:price) }
	it { should respond_to (:published) }
	it { should respond_to (:user_id) }
	it { should_not be_published }
	it { should validate_presence_of :title }
	it { should validate_presence_of :price }
	it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
	it { should validate_presence_of :user_id }
	it { should belong_to :user }
	it { should have_many(:placements) }
	it { should have_many(:orders).through(:placements) }

	describe ".filter_by_title" do
		before(:each) do
      @product1 = FactoryGirl.create :product, title: "Ikan Asin"
      @product2 = FactoryGirl.create :product, title: "Garam Manis"
      @product3 = FactoryGirl.create :product, title: "Air Cuka Asem"
      @product4 = FactoryGirl.create :product, title: "Ikan Pahit"
      @product5 = FactoryGirl.create :product, title: "Air Bening"

    end

    context "when a 'TV' title pattern is sent" do
      it "returns the 2 products matching" do
        expect(Product.filter_by_title("ikan").count).to  eql 2
      end

      it "returns the products matching" do
        expect(Product.filter_by_title("ikan").sort).to match_array([@product1, @product4])
      end
    end
	end

	describe ".above_or_equal_to_price" do
		before(:each) do
			@product1 = FactoryGirl.create :product, price: 1000
			@product2 = FactoryGirl.create :product, price:  400
			@product3 = FactoryGirl.create :product, price:  500
			@product4 = FactoryGirl.create :product, price:   60
			@product5 = FactoryGirl.create :product, price:  340
		end

		it "returns the products which are above or equal to the filter" do
			expect(Product.above_or_equal_to_price(500).sort).to match_array([@product1, @product3])
		end
	end

	describe ".below_or_equal_to_price" do
		before(:each) do
			@product1 = FactoryGirl.create :product, price: 1000
			@product2 = FactoryGirl.create :product, price:  400
			@product3 = FactoryGirl.create :product, price:  500
			@product4 = FactoryGirl.create :product, price:   60
			@product5 = FactoryGirl.create :product, price:  340
		end

		it "returns the products which are below or equal to the price" do
			expect(Product.below_or_equal_to_price(350).sort).to match_array([@product4, @product5])
		end
	end

	describe ".recent" do
		before(:each) do
			@product1 = FactoryGirl.create :product, price: 1000
			@product2 = FactoryGirl.create :product, price:  400
			@product3 = FactoryGirl.create :product, price:  500
			@product4 = FactoryGirl.create :product, price:   60
			@product5 = FactoryGirl.create :product, price:  340

			@product1.touch
			@product2.touch
		end

		it "returns the most updated records" do
			expect(Product.recent).to match_array([@product1, @product2, @product5, @product4, @product3])
		end
	end

	describe ".search" do
		before(:each) do
			@product1 = FactoryGirl.create :product, price: 1000, title: "Permen Bonbon"
			@product2 = FactoryGirl.create :product, price:  400, title: "Ikan Asin"
			@product3 = FactoryGirl.create :product, price:  500, title: "Permen Karet"
			@product4 = FactoryGirl.create :product, price:   60, title: "Sikat Gigi"
			@product5 = FactoryGirl.create :product, price:  340, title: "Pasta Gigi Odol"
		end

		context "when tile 'permen' and max price '50'" do
			it "returns an empty array" do
				search_hash = { keyword: "permen", max_price: 50 }
				expect(Product.search(search_hash)).to be_empty
			end
		end

		context "when title 'permen', max_price '500', and min_price '100'"
		it "returns the product3" do
			search_hash = { keyword: "permen", min_price: 100, max_price: 500 }
			expect(Product.search(search_hash)).to match_array([@product3])
		end

		context "when an empty hash is sent" do
			it "returns all the products" do
				expect(Product.search({})).to match_array([@product1, @product2, @product3, @product4, @product5])
			end
		end

		context "when product_ids is present" do
			it "returns the product from the ids" do
				search_hash = { product_ids: [@product3.id, @product4.id] }
				expect(Product.search(search_hash)).to match_array([@product3, @product4])
			end
		end
	end
end
