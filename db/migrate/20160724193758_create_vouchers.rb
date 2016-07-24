class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.string :code
      t.boolean :vacant, default: false
      t.decimal :nominal, default: 0.0
      t.date :end_date

      t.timestamps null: false
    end
    add_index :vouchers, :code, unique: true
  end
end
