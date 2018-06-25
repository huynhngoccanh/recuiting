class Position::PuntReturner < ApplicationRecord
  include Positionable

  has_many :stats
  has_many :athletes, through: :stats

  validates_presence_of :season
  validates_inclusion_of :season, in: 1980..3000
  validates :punt_return_yards, :punt_return_touchdowns, {presence: true, numericality: true}
end
