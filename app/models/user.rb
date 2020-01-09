class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :following_follows, class_name: "Follow", foreign_key: "user_id"
  has_many :follower_follows, class_name: "Follow", foreign_key: "f_user_id"
  has_many :followings, through: :following_follows
  has_many :followers, through: :follower_follows
  has_many :tweets, dependent: :destroy

  def generate_jwt
    JWT.encode({ id: id, exp: 30.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end
end
