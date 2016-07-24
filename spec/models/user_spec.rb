require 'rails_helper'

describe User do
	before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_confirmation_of(:password) }
  it { should allow_value('test@gmail.com').for(:email) }
  it { should be_valid }
  it { should respond_to(:auth_token) }
  it { should validate_uniqueness_of(:auth_token)}
  it { should have_many(:products) }

  describe "generate authentication token" do
  	it "generates a unique token" do
  		allow(Devise).to receive(:friendly_token).and_return("sadsad324nf23423sssd")
  		@user.generate_authentication_token!
  		expect(@user.auth_token).to eql "sadsad324nf23423sssd"
  	end

  	it "generates another token when one already taken" do
  		existing_user = FactoryGirl.create(:user, auth_token: "sadsad324nf23423s")
  		@user.generate_authentication_token!
  		expect(@user.auth_token).not_to eql existing_user.auth_token
  	end
  end

  describe "#products association" do
    before do
      @user.save
      3.times { FactoryGirl.create :product, user: @user }
    end

    it "destroys the associated products" do
      products = @user.products
      @user.destroy
      products.each do |product|
        expect(Product.find(product)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
