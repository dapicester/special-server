require 'active_support/concern'

module EmailValidations
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  included do
    validates :email, presence: true,
                      format: { with: EMAIL_REGEX }
  end
end
