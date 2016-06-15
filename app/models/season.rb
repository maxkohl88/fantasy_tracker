class Season < ActiveRecord::Base
	belongs_to :league
	has_one :schedule
	has_many :teams
end
