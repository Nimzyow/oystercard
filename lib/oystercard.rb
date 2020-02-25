class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MINIMUM_CHARGE = 5
  attr_accessor :balance, :in_journey

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(money)
    check_max_balance(money)
    @balance += money
    success_message
  end


  def touch_in
    raise "no money, bruh" if balance < MIN_BALANCE
    @in_journey = true
  end

  def touch_out
    deduct(MINIMUM_CHARGE)
    @in_journey = false
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