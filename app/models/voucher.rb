class Voucher < ActiveRecord::Base
	validates :code, :end_date, :nominal, presence: true
  validates :code, uniqueness: true

end
