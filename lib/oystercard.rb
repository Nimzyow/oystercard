class Oystercard
  MAX_BALANCE = 90
  attr_accessor :balance

  def initialize
    @balance = 0
  end

  def top_up(money)
    check_max_balance(money)
    @balance += money
    success_message
  end

  private
  def success_message
    "Succesfully topped up. current balance is #{@balance}"
  end
  def check_max_balance(money)
    raise "top_up exceeds £#{MAX_BALANCE}" if @balance + money > MAX_BALANCE
  end
end