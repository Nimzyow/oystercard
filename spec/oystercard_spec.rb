require "oystercard"

shared_context "common" do
  let(:station) {double("station", {station_name: "bank"})}
  let(:station2) {double("station2", {station_name: "oxford street"})}
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
    it "entry_station" do
      expect(subject).to have_attributes(entry_station: nil)
    end
    it "exit_station" do
      expect(subject).to have_attributes(exit_station: nil)
    end
    it "journey" do
      expect(subject).to have_attributes(journey: [])
    end
  end

  context "station change" do
    
    it "entry_station stores entry station" do
      top_up_and_enter
      expect(subject.entry_station).to eq(station.station_name)
    end

    # it "exit_station stores exit station" do
    #   top_up_and_enter
    #   subject.touch_out("Liverpool Street")
    #   expect(subject.exit_station).to eq("Liverpool Street")
    # end
  end

  context "journey tests" do
    it "#in_journey to false" do
      expect(subject.in_journey).to be false
    end

    it "#in_journey to false" do
      top_up_and_enter
      subject.touch_out(station2.station_name)
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
      expect(subject).to respond_to(:touch_out).with(1).arguments
    end
    it "#in_journey" do
      expect(subject).to respond_to(:in_journey)
    end

    it "#add_journey" do
      expect(subject).to respond_to(:add_journey)
    end
    
  end

  context "method functionality" do
    it "#top_up tops up the balance by given amount" do
      subject.top_up(3)
      expect(subject.balance).to eq(3)
    end

    it "#touch_out deducts given amount from balance" do
      subject.top_up(10)
      expect{subject.touch_out(station2.station_name)}.to change{subject.balance}.by(-Oystercard::MINIMUM_CHARGE)
    end

    it "raises error if #top_up exceeds max balance" do
      subject.top_up(50)
      expect{subject.top_up(50)}.to raise_error("top_up exceeds £90")
    end

    it "#top_up gives user message of successful top up" do
      expect(subject.top_up(50)).to eq("Succesfully topped up. current balance is #{subject.balance}")
    end

    it "adds entry and exit stations to journey" do
      subject.entry_station = "Stratford"
      subject.exit_station = "Heathrow Airport"
      subject.add_journey
      expect(subject.journey).to include({entry_station: "Stratford", exit_station: "Heathrow Airport"})
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
        expect{subject.touch_out(station2.station_name)}.to change{subject.balance}.by(-Oystercard::MINIMUM_CHARGE)
      end

      it "creates the journey" do
        top_up_and_enter
        subject.touch_out("Heathrow Airport")
        expect(subject.journey).to include({entry_station: "bank", exit_station: "Heathrow Airport"})
      end
    end
  end
  
end