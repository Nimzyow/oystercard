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
  context "method functionality" do
    it "tops up the balance by given amount" do
      subject.top_up(3)
      expect(subject.balance).to eq(3)
    end
    it "raises error if #top_up exceeds max balance" do
      subject.top_up(50)
      expect{subject.top_up(50)}.to raise_error("top_up exceeds maximum balance")
    end
  end
  
end