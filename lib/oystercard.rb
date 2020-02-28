# frozen_string_literal: true

class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  attr_reader :balance, :journey, :journey_log

  def initialize(journey_log = Journeylog.new, journey_calc = Journeycalculator.new)
    @balance = 0
    @journey = []
    @journey_log = journey_log
    @journey_calc = journey_calc
  end

  def in_journey
    @journey_log.in_journey?
  end

  def top_up(money)
    check_max_balance(money)
    @balance += money
    success_message
  end

  def touch_in(station)
    deduct(@journey_calc.calc_fare) if @journey_log.entry_station
    raise 'no money, bruh' if balance < MIN_BALANCE
    start_journey(station)
  end

  def touch_out(station)
    @journey_log.end_tracking(station)
    @journey_calc.set_exit_zone(@journey_log.exit_zone)
    deduct(@journey_calc.calc_fare)
  end

  private

  def start_journey(station)
    @journey_log.start_tracking(station)
    @journey_calc.set_entry_zone(@journey_log.entry_zone)
  end

  def deduct(money)
    @balance -= money
    reset_journey
  end

  def reset_journey
    @journey_log.call_reset
  end

  def success_message
    "Succesfully topped up. current balance is #{@balance}"
  end

  def check_max_balance(money)
    raise "top_up exceeds £#{MAX_BALANCE}" if @balance + money > MAX_BALANCE
  end
end
