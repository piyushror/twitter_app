class Follow < ApplicationRecord
  enum follow_type: [:follower]

  belongs_to :user
  belongs_to :f_user, class_name: "User", foreign_key: :f_user_id

  belongs_to :following, class_name: "User", foreign_key: :f_user_id
  belongs_to :follower, class_name: "User", foreign_key: :user_id

  validates :user_id, uniqueness: { scope: [:f_user_id], message: "Already following" }
end
