class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MINIMUM_CHARGE = 1
  attr_accessor :balance, :entry_station, :exit_station, :journey

  def initialize
    @balance = 0
    @entry_station = nil
    @exit_station = nil
    @journey = []
  end

  def top_up(money)
    check_max_balance(money)
    @balance += money
    success_message
  end
  def in_journey
    "you are in a great journey, bruh" if @entry_station
    @entry_station ? true : false
  end

  def touch_in(station)
    raise "no money, bruh" if balance < MIN_BALANCE
    @entry_station = station
  end

  def touch_out(station)
    deduct(MINIMUM_CHARGE)
    @exit_station = station
    add_journey
    @entry_station = nil
    @exit_station = nil
  end

  def add_journey
    journey << {entry_station: @entry_station, exit_station: @exit_station}
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