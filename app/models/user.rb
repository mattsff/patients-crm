class User < ApplicationRecord
  belongs_to :clinic

  has_many :appointments, dependent: :nullify
  has_many :notes, dependent: :nullify
  has_many :activity_events, dependent: :nullify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { staff: 0, admin: 1, owner: 2 }

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def owner_or_admin?
    owner? || admin?
  end
end
