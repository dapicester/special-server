class PasswordReset
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :email

  include EmailValidations

  def initialize(email = '')
    self.email = email
  end

  def persisted?
    false
  end
end
