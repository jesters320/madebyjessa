module ApplicationHelper

	def format_hash_key(key)
		key.to_s.gsub(/_/, ' ')
	end
	
end
