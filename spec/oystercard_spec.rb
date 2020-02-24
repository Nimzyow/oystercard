require "oystercard"

describe Oystercard do
  context "has attributes" do
    it "balance" do
      expect(subject).to have_attributes(balance: 0)
    end
  end
  context "method responds to" do
    it "#top_up" do
    expect(subject).to respond_to(:top_up).with(1).arguments
    end
  end
  
end