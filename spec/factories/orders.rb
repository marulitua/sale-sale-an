FactoryGirl.define do
  factory :order do
    user
    voucher nil
    total 0
  end
end
