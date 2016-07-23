require 'rails_helper'

describe User do
	before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_confirmation_of(:password) }
  it { should allow_value('test@gmail.com').for(:email) }

  it { should be_valid }
end
