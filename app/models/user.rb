# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  activation_token       :string(255)
#  activation_sent_at     :datetime
#  active                 :boolean
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id",
                           dependent: :destroy
  has_many :followed_users, through: :relationships,
                            source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships,
                       source: :follower

  before_save :create_remember_token

  scope :active, where(active: true)
  # TODO admin scope

  NAME_MAX_LEN = 50
  validates :name, presence: true,
                   length: { maximum: NAME_MAX_LEN }

  include EmailValidations
  validates :email, uniqueness: { case_sensitive: false }

  include PasswordValidations

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def send_password_reset
    token_for :password_reset_token
    self.password_reset_sent_at = Time.zone.now
    save! validate: false
    UserMailer.password_reset(self).deliver
  end

  def send_activation
    token_for :activation_token
    self.activation_sent_at = Time.zone.now
    save! validate: false
    UserMailer.activation(self).deliver
  end

  def activate!
    self.active = true
    self.activation_token = nil
    self.activation_sent_at = nil
    save! validate: false
  end

  def active?
    self.active
  end

private

  def create_remember_token
    token_for :remember_token
  end

  def token_for(field)
    self[field] = SecureRandom.urlsafe_base64
  end

end
