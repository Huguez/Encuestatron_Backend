class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable :rememberable, 
  
  has_secure_password

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable
  

end
