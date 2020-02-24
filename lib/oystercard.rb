class Oystercard
  attr_accessor :balance

  def initialize
    @balance = 0
  end

  def top_up(money)
    check_max_balance(money)
    @balance += money
  end

  private
  def check_max_balance(money)
    raise "top_up exceeds maximum balance" if @balance + money > 90
  end
end