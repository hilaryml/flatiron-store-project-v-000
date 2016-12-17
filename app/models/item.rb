class Item < ActiveRecord::Base
  has_many :line_items
  belongs_to :category

  def self.available_items
    where("inventory > ?", 0)
  end
end
