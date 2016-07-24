class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :voucher
  has_many :placements
  has_many :products, through: :placements

  validates :total, presence: true,
  										numericality: { greater_than_or_equal_to: 0 }

  validates :user_id, presence: true

  before_validation :set_total!

  def set_total!
  	self.total = products.map(&:price).sum
  end

  def use_voucher(voucher_code)
  	voucher = Voucher.where(:code => voucher_code)
  	if !voucher.blank? && vacant
  		self.total -= voucher.nominal
  		voucher.update(vacant: false)
		end
  end
end
