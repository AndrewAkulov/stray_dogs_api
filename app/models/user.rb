class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  validates_presence_of :first_name, :last_name

  has_many :favorites, dependent: :destroy
  has_many :dogs, dependent: :delete_all
  has_one :subscribe, dependent: :destroy
end
