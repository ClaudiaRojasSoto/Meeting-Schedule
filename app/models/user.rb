class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[member admin].freeze

  validates :role, inclusion: { in: ROLES }

  def admin?
    role == "admin"
  end

  def member?
    role == "member"
  end
end
