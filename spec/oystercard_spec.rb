require "oystercard"

shared_context "common" do
  let(:station) {double("station", {station_name: "bank"})}
  let(:top_up_and_enter) {
    subject.top_up(10)
    subject.touch_in(station.station_name)
  }
end

describe Oystercard do
  include_context "common"
  
  context "stores" do
    it "balance" do
      expect(subject).to have_attributes(balance: 0)
    end
    it "in_journey" do
      expect(subject).to have_attributes(in_journey: false)
    end
    it "station_entry" do
      expect(subject).to have_attributes(station_entry: nil)
    end
  end

  context "station change" do
    
    it "station_entry stores station" do
      subject.top_up(10)
      subject.touch_in(station)
      expect(subject.station_entry).to eq(station)
    end
  end

  context "journey tests" do
    it "#in_journey to false" do
      expect(subject.in_journey).to be false
    end

    it "#in_journey to false" do
      top_up_and_enter
      subject.touch_out
      expect(subject.in_journey).to be false
    end

    it "#in_journey to true" do
      top_up_and_enter
      expect(subject.in_journey).to be true
    end

  end

  context "method responds to" do
    it "#top_up" do
      expect(subject).to respond_to(:top_up).with(1).arguments
    end
    it "#touch_in" do
      expect(subject).to respond_to(:touch_in).with(1).arguments
    end
    it "#touch_out" do
      expect(subject).to respond_to(:touch_out)
    end
    it "#in_journey" do
      expect(subject).to respond_to(:in_journey)
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

    context "#touch_in" do
      it "switches in_journey to true" do
        top_up_and_enter
        expect(subject.in_journey).to be true 
      end

      it "raises error when balance is < 1" do
        expect{subject.touch_in(station.station_name)}.to raise_error("no money, bruh")
      end
    end
  
    context "#touch_out" do
      
  
      it "deducts minimum charge of -5" do
        top_up_and_enter
        subject.touch_out
        expect{subject.touch_out}.to change{subject.balance}.by(-Oystercard::MINIMUM_CHARGE)
      end
    end
  end
  
end