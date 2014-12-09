class Message
  include ApplicationHelper
  include MBJConstants
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :to, :email, :additional_details, :product_ids, :products

  validates :name, :email, presence: { message: "is missing" }
  validates :products, presence: { message: "haven't been selected" }
  validates :email, format: { with: %r{.+@.+\..+}, message: "should be ___@___.___" }, :allow_blank => true
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
	self.set_products
	Rails.logger.info self.products
  end
  
  def product_checked(value)
	return false if self.product_ids.nil?
	self.product_ids.include? value
  end
  
  def set_products
	Rails.logger.info "inside set_products"
	
	return if self.product_ids.nil?
	
	product_ids.each do |id|
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
  
  def inquiry_html
	"<html>
		<div>
			Name: #{self.name}
		</div>
		<div>
			Email: #{self.email}
		</div>
		<div>
			Interested in: #{self.products}
		</div>
		<div>
			Additional Details: #{self.additional_details}
		</div>
	</html>"
  end
  
  def thank_you_html
	"
		<!DOCTYPE html>
		<html style='min-height:100%; height:auto !important; height:100%;'>
		<head>
		  <title>Madebyjessa</title>
		</head>
		<body style='min-height:100%;'>
			
			<table style='width:760px; min-height:200px;'>
				<tr>
					<td style='width:10%;'></td>
					<td style='width:10%;'></td>
					<td style='width:10%;'></td>
					<td style='width:10%;'></td>
					<td style='width:10%;'></td>
					<td style='width:10%;'></td>
					<td style='width:10%;'></td>
					<td style='width:10%;'></td>
					<td style='width:10%;'></td>
					<td style='width:10%;'></td>
				</tr>
				<tr style='height:100px'>
					<td colspan='10'><img alt='Email logo' src='http://madebyjessa.herokuapp.com/assets/email_logo-fe74a23ccbdfc858306686eeff81edab.jpg'></td>
				</tr>
				<tr>
					<td></td>
					<td colspan='8'>
						<p>
							Hi #{ self.name },
						</p>
						<p>
							Thanks so much for inquiring about made by jessa. We'll be in touch!
						</p>
						<p>
							Don't forget to check out our shop on <a href='https://www.etsy.com/shop/madebyjessa'>etsy</a>.
						</p>
						<p>
							- the team at made by jessa
						</p>						
					</td>
					<td></td>
				</tr>
				<tr style='height:30px;'>
					<td colspan='2'></td>
					<td colspan='6' style='text-align: center; border-style: dashed none none none; border-width: 1px;'>
						<span>&copy; #{ Time.now.year } made by jessa co.</span>
					</td>
					<td colspan='2'></td>
				</tr>
			</table>

		</body>
		</html>
	"
  end

end