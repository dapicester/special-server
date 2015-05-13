# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  default_scope order: 'microposts.created_at DESC'

  # Returns microposts from the users being followed by the given user.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  include Tire::Model::Search
  include Tire::Model::Callbacks

  index_name "#{Tire::Model::Search.index_prefix}_microposts"

  tire.mapping do
    indexes :content
  end

  def self.search(params)
    tire.search(load: true, page: params[:page]||1) do
      query { string params[:query] } if params[:query].present?
      highlight :content, options: { tag: "<em class='highlight'>" }
    end
  end

private

  # Returns an SQL condition for users folloew by the given user.
  # We include the user's own id as well.
  def self.followed_by(user)
    followed_user_ids = %(SELECT followed_id FROM relationships
                          WHERE follower_id = :user_id)
    where("user_id IN (#{followed_user_ids})
        OR user_id = :user_id", user_id: user) # automatically uses user.id
  end
end
