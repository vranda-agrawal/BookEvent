class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :enrols, dependent: :destroy
  has_many :events, :through => :enrols
  has_many :transactions
end
