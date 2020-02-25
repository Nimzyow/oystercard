class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MINIMUM_CHARGE = 1
  attr_accessor :balance, :station_entry

  def initialize
    @balance = 0
    @station_entry = nil
  end

  def top_up(money)
    check_max_balance(money)
    @balance += money
    success_message
  end
  def in_journey
    "you are in a great journey, bruh" if @station_entry
    @station_entry ? true : false
  end

  def touch_in(station)
    raise "no money, bruh" if balance < MIN_BALANCE
    @station_entry = station
  end

  def touch_out
    deduct(MINIMUM_CHARGE)
    @station_entry = nil
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