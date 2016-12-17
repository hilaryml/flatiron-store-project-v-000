class Cart < ActiveRecord::Base
  has_many :line_items
  has_many :items, through: :line_items
  belongs_to :user

  def total
    self.line_items.map {|line_item| line_item.item.price * line_item.quantity }.reduce(:+)
  end

  def add_item(item_id)
    line_item = LineItem.find_by(cart_id: self.id, item_id: item_id)
    if line_item
      line_item.quantity += 1
      line_item.save
      line_item
    else
      LineItem.new(cart_id: self.id, item_id: item_id)
    end
  end

  def checkout_cart
    update_inventory
    self.line_items.clear
    self.user.checkout_current_cart
    self.status = "submitted"
    self.save
  end

  def update_inventory
    self.line_items.each do |line_item|
      line_item.item.inventory -= line_item.quantity
      line_item.item.save
    end
  end
end
