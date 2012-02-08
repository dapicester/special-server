class User < ActiveRecord::Base

  SCREEN_NAME_MIN_LENGTH = 5
  SCREEN_NAME_MAX_LENGTH = 50
  SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH  

  PASSWORD_MIN_LENGTH = 6
  PASSWORD_MAX_LENGTH = 50
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH

  EMAIL_MAX_LENGTH = 50

  SCREEN_NAME_SIZE = 20
  PASSWORD_SIZE = 20
  EMAIL_SIZE = 20
  
  validates :screen_name, :uniqueness => true,
                          :length => { :within => SCREEN_NAME_RANGE },
                          :format => { :with => /^[A-Z0-9_]*$/i, :message => "must contains only letters, numbers and underscores" }
  validates :email, :presence => true,
                    :uniqueness => true , 
                    :length => { :maximum => EMAIL_MAX_LENGTH },
                    :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i, :message => "must be a valid address" }

  validates :password, :length => { :within => PASSWORD_RANGE }
end
