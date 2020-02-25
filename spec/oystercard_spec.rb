require "oystercard"

shared_context "common" do
  let(:top_up_and_enter) {
    subject.top_up(10)
    subject.touch_in
  }
end

describe Oystercard do
  include_context "common"
  
  context "has attributes" do
    it "balance" do
      expect(subject).to have_attributes(balance: 0)
    end
    it "in_journey" do
      expect(subject).to have_attributes(in_journey: false)
    end
  end

  context "method responds to" do
    it "#top_up" do
      expect(subject).to respond_to(:top_up).with(1).arguments
    end
    it "touch_in" do
      expect(subject).to respond_to(:touch_in)
    end
    it "touch_out" do
      expect(subject).to respond_to(:touch_out)
    end
    
  end

  context "method functionality" do
    it "#top_up tops up the balance by given amount" do
      subject.top_up(3)
      expect(subject.balance).to eq(3)
    end
    it "#touch_out deducts given amount from balance" do
      subject.top_up(10)
      subject.touch_out
      expect{subject.touch_out}.to change{subject.balance}.by(-Oystercard::MINIMUM_CHARGE)
    end
    it "raises error if #top_up exceeds max balance" do
      subject.top_up(50)
      expect{subject.top_up(50)}.to raise_error("top_up exceeds £90")
    end
    it "#top_up gives user message of successful top up" do
      expect(subject.top_up(50)).to eq("Succesfully topped up. current balance is #{subject.balance}")
    end

    it "#touch_in switches in_journey to true" do
      top_up_and_enter
      expect(subject.in_journey).to be true 
    end
    it "#touch_in raises error when balance is < 1" do
      expect{subject.touch_in}.to raise_error("no money, bruh")
    end
    it "#touch_out switched in_journey to false" do
      top_up_and_enter
      subject.touch_out
      expect(subject.in_journey).to be false
    end
    it "#touch_out deducts minimum charge of -5" do
      top_up_and_enter
      subject.touch_out
      expect{subject.touch_out}.to change{subject.balance}.by(-Oystercard::MINIMUM_CHARGE)
    end
  end
  
end