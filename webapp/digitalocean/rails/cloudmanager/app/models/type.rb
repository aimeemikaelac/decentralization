class Type < ActiveRecord::Base
	has_many :machines, dependent: :destroy
	validates :name, presence: true, uniqueness: true, length: { minimum: 1 }
end
