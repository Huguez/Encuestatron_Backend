require 'jwt'

class JsonWebToken    
    class << self
      
        def encode( payload, exp = 90.days.from_now )
            
            payload[:exp] = exp.to_i
            JWT.encode( payload, Rails.application.secrets.secret_key_base )
        end
   
        def decode(token)
            body = JWT.decode(token, Rails.application.secrets.secret_key_base, true )[0]
            HashWithIndifferentAccess.new body 
        end
        
    end

end
   