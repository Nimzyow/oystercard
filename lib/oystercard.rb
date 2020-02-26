# frozen_string_literal: true

class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MINIMUM_CHARGE = 1
  attr_accessor :balance, :journey, :journey_log

  def initialize(journey_log = Journeylog.new)
    @balance = 0
    @journey = []
    @journey_log = journey_log
  end

  def top_up(money)
    check_max_balance(money)
    @balance += money
    success_message
  end

  def touch_in(station)
    raise 'no money, bruh' if balance < MIN_BALANCE
    @journey_log.start_tracking(station)
  end

  def touch_out(station)
    deduct(MINIMUM_CHARGE)
    @exit_station = station
    @journey_log.end_tracking(station)
    @entry_station = nil
    @exit_station = nil
  end

  def in_journey
    @journey_log.in_journey?
  end

  private

  def deduct(money)
    @balance -= money
  end

  def success_message
    "Succesfully topped up. current balance is #{@balance}"
  end

  def check_max_balance(money)
    raise "top_up exceeds £#{MAX_BALANCE}" if @balance + money > MAX_BALANCE
  end
end
