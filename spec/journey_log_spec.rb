# frozen_string_literal: true

require 'journey_log'

shared_context 'common journey_log' do
  let(:station1) { double('entry_station', name: 'Oxford st', zone: 1) }
  let(:station2) { double('exit_station', name: 'Liverpool St', zone: 3) }
end

describe Journeylog do
  include_context 'common journey_log'

  context 'has attributes' do
    it 'entry_station' do
      expect(subject).to have_attributes(entry_station: nil)
    end
    it 'exit_station' do
      expect(subject).to have_attributes(exit_station: nil)
    end
    it 'journey' do
      expect(subject).to have_attributes(journey: [])
    end
  end

  context 'respond to methods' do
    it '#start_tracking' do
      expect(subject).to respond_to(:start_tracking).with(1).arguments
    end
    it '#end_tracking' do
      expect(subject).to respond_to(:end_tracking).with(1).arguments
    end
    it '#add_journey' do
      expect(subject).to respond_to(:add_journey)
    end
    it '#in_journey?' do
      expect(subject).to respond_to(:in_journey?)
    end
    it "#call_reset" do
      expect(subject).to respond_to(:call_reset)
    end
  end

  context 'method functionality' do
    it "#in_journey? returns 'You are not on a journey' if no entry station is registered" do
      expect(subject.in_journey?).to eq('You are not on a journey')
    end

    it '#in_journey? returns You are not on a GREAT journey' do
      allow(subject).to receive(:entry_station).and_return('Bank')
      expect(subject.in_journey?).to eq('You are on a GREAT journey')
    end

    it '#start_tracking' do
      subject.start_tracking(station1)
      expect(subject.entry_station).to eq(station1.name)
    end

    it '#add_journey' do
      subject.start_tracking(station1)
      subject.end_tracking(station2)
      expect(subject.journey).to include({entry_station: 'Oxford st', exit_station: 'Liverpool St'})
    end

    it "#call_reset resets stations and zones to nil" do
      subject.start_tracking(station1)
      subject.end_tracking(station2)
      subject.call_reset
      expect(subject.entry_station).to be_nil
      expect(subject.exit_station).to be_nil
      expect(subject.entry_zone).to be_nil
      expect(subject.exit_zone).to be_nil
    end
  end
end
