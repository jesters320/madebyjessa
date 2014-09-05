class Message
  include ApplicationHelper
  include MBJConstants
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :to, :email, :additional_details, :products

  validates :name, :email, presence: { message: "is missing" }
  validates :email, format: { with: %r{.+@.+\..+}, message: "should be ___@___.___" }, :allow_blank => true
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def set_products(ids)
	Rails.logger.debug "inside set_products"
	
	return if ids.nil?
	
	ids.each do |id|
		Rails.logger.debug format_hash_key(MBJConstants::PRODUCTS_LIST.invert[id.to_i])
		
		if self.products.nil?
			self.products = ""
		else
			self.products = self.products + ", "
		end
		
		self.products = self.products + format_hash_key(MBJConstants::PRODUCTS_LIST.invert[id.to_i])
	end
  end

  def persisted?
    false
  end

end