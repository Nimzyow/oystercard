require "journey_calculator"

describe Journeycalculator do

  context "has attributes" do
    it "zone1" do
      expect(subject).to have_attributes(entry_zone: nil)
    end
    it "zone2" do
      expect(subject).to have_attributes(exit_zone: nil)
    end
  end

  context "has methods" do
    it "#calc_fare" do
      expect(subject).to respond_to(:calc_fare)
    end

    it "#set_entry_zone" do
      expect(subject).to respond_to(:set_entry_zone).with(1).arguments
    end

    it "#set_exit_zone" do
      expect(subject).to respond_to(:set_exit_zone).with(1).arguments
    end
  end
  context "method functionality" do
    it "#calc_fare returns minumim fare if zones are truthy" do
      subject.entry_zone = 1
      subject.exit_zone = 3
      expect(subject.calc_fare).to eq(Journeycalculator::MINIMUM_CHARGE)
    end
    it "#calc_fare returns penalty fare when either or both zones are nil" do
      subject.entry_zone = 1
      expect(subject.calc_fare).to eq(9) 
    end 
    it "#set_entry_zone sets entry_zone to 1" do
      subject.set_entry_zone(2)
      expect(subject.entry_zone).to eq(2)
    end

    it "#set_exit_zone sets exit_zone to 3" do
      subject.set_exit_zone(3)
      expect(subject.exit_zone).to eq(3)
    end
  end
end