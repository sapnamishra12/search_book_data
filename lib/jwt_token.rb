module JwtToken
	
  def encode(payload)
	  JWT.encode(payload, Rails.application.secrets.secret_key_base,'HS256')
	end

  def decode(token)
	  return HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.secret_key_base,true, { algorithm: 'HS256' })[0])
	  rescue
	  nil
  end

end