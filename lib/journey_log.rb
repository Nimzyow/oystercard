# frozen_string_literal: true

class Journeylog
  attr_reader :entry_station, :exit_station, :journey, :entry_zone, :exit_zone
  def initialize
    @entry_station = nil
    @entry_zone = nil
    @exit_station = nil
    @exit_zone = nil
    @journey = []
  end

  def start_tracking(station)
    @entry_station = station.name
    @entry_zone = station.zone
  end

  def end_tracking(station)
    @exit_station = station.name
    @exit_zone = station.zone
    add_journey
  end

  def add_journey
    journey.push({entry_station: entry_station, exit_station: exit_station})
  end

  def in_journey?
    entry_station ? 'You are on a GREAT journey' : 'You are not on a journey'
  end

  def call_reset
    reset_journey
  end

  private
  def reset_journey
    @entry_station = nil
    @entry_zone = nil
    @exit_station = nil
    @exit_zone = nil
  end

end
