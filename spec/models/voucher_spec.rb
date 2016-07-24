require 'rails_helper'

RSpec.describe Voucher, type: :model do

	it { should respond_to (:code) }
	it { should respond_to (:vacant) }
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:nominal) }

end
