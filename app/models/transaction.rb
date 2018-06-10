class Transaction < ApplicationRecord
  belongs_to :user

  validates :description, :company, :price, :date, presence: :true
  validates :description, uniqueness: { scope: :date, message: "should be just once" }
end
