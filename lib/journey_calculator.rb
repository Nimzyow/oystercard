class Journeycalculator
  MINIMUM_CHARGE = 1
  PENALTY = 9

  attr_accessor :entry_zone, :exit_zone
  
  def initialize
    @entry_zone = nil
    @exit_zone = nil
  end

  def calc_fare
    @entry_zone && @exit_zone ? MINIMUM_CHARGE : PENALTY
  end

  def set_entry_zone(zone)
    @entry_zone = zone
  end

  def set_exit_zone(zone)
    @exit_zone = zone
  end
end