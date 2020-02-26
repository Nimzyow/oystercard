# frozen_string_literal: true

require 'oystercard'

shared_context 'common' do
  let(:station) { double('station', name: 'bank', zone: 1) }
  let(:station2) { double('station2', name: 'oxford street', zone: 3) }
  let(:top_up_and_enter) do
    subject.top_up(10)
    subject.touch_in(station)
  end
end

describe Oystercard do
  include_context 'common'

  context 'stores' do
    it 'balance' do
      expect(subject).to have_attributes(balance: 0)
    end

    it 'journey' do
      expect(subject).to have_attributes(journey: [])
    end

    it 'Journeylog' do
      expect(subject).to respond_to(:journey_log)
    end
  end

  context 'station change' do
    # it "exit_station stores exit station" do
    #   top_up_and_enter
    #   subject.touch_out("Liverpool Street")
    #   expect(subject.exit_station).to eq("Liverpool Street")
    # end
  end

  context 'journey tests' do
    it '#in_journey to return "You are not on a journey"' do
      top_up_and_enter
      subject.touch_out(station2)
      expect(subject.in_journey).to eq('You are not on a journey')
    end

    it '#in_journey to return "You are on a GREAT journey"' do
      top_up_and_enter
      expect(subject.in_journey).to eq('You are on a GREAT journey')
    end
  end

  context 'method responds to' do
    it '#top_up' do
      expect(subject).to respond_to(:top_up).with(1).arguments
    end
    it '#touch_in' do
      expect(subject).to respond_to(:touch_in).with(1).arguments
    end
    it '#touch_out' do
      expect(subject).to respond_to(:touch_out).with(1).arguments
    end
    it '#in_journey' do
      expect(subject).to respond_to(:in_journey)
    end
  end

  context 'method functionality' do
    it '#top_up tops up the balance by given amount' do
      subject.top_up(3)
      expect(subject.balance).to eq(3)
    end

    it '#touch_out deducts given amount from balance' do
      subject.top_up(10)
      expect { subject.touch_out(station2) }.to change { subject.balance }.by(-Oystercard::MINIMUM_CHARGE)
    end

    it 'raises error if #top_up exceeds max balance' do
      subject.top_up(50)
      expect { subject.top_up(50) }.to raise_error('top_up exceeds £90')
    end

    it '#top_up gives user message of successful top up' do
      expect(subject.top_up(50)).to eq("Succesfully topped up. current balance is #{subject.balance}")
    end

      context '#touch_in' do
        it 'in_journey returns "You are on a GREAT journey"' do
          top_up_and_enter
          expect(subject.in_journey).to eq("You are on a GREAT journey")
        end

        it 'raises error when balance is < 1' do
          expect { subject.touch_in(station) }.to raise_error('no money, bruh')
        end
      end

      context '#touch_out' do
        it "deducts minimum charge of -#{Oystercard::MINIMUM_CHARGE}" do
          top_up_and_enter
          expect { subject.touch_out(station2) }.to change { subject.balance }.by(-Oystercard::MINIMUM_CHARGE)
        end

        it 'creates the journey' do
          top_up_and_enter
          subject.touch_out(station2)
          expect(subject.journey_log.journey).to include({entry_station: 'bank', exit_station: 'oxford street'})
        end
      end
  end
end
