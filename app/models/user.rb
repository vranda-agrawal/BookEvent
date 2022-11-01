class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :enrols, dependent: :destroy
  has_many :events, :through => :enrols
  has_many :transactions

  validates_presence_of :fullname
  validates_presence_of :phone_number
  validates_presence_of :password

end
