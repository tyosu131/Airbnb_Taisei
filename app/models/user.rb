class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :properties, dependent: :destroy
  has_many :reservations, foreign_key: :guest_id, inverse_of: :guest, dependent: :restrict_with_error
end
