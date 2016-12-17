class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders
  has_many :carts

  has_one :current_cart, class: Cart

  def create_current_cart
    self.current_cart = self.carts.create
    self.save
  end

  def checkout_current_cart
    self.current_cart = nil
    self.save
  end

end
