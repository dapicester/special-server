require 'active_support/concern'

module PasswordValidations
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  PASSWORD_MIN_LEN = 6

  included do
    validates :password, length: { minimum: PASSWORD_MIN_LEN }
  end
end
