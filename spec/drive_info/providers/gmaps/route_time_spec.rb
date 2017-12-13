# frozen_string_literal: true

RSpec.describe DriveInfo::Providers::Gmaps::RouteTime do
  subject { described_class.new(params) }

  let(:params) do
    {
      from: '',
      to: '',
      depart_time: ''
    }
  end

  let(:connection) { instance_double('Faraday::Connection') }

  before do
    allow(DriveInfo).to receive(:connection).and_return(connection)
  end

  it 'requests with params values' do
    expect(connection).to receive(:get).with(
      an_instance_of(String),
      a_hash_including(
        origin: '',
        destination: '',
        departure_time: 0
      )
    )
    subject.request
  end

  it 'requests with traffic mode best guess' do
    expect(connection).to receive(:get).with(
      an_instance_of(String),
      a_hash_including(
        traffic_model: :best_guess
      )
    )
    subject.request
  end

  it 'requests with mode as driving' do
    expect(connection).to receive(:get).with(
      an_instance_of(String),
      a_hash_including(
        mode: :driving
      )
    )
    subject.request
  end

  context 'when api key is provided' do
    before do
      params[:key] = 'test_api_key'
    end

    it 'requests with api key' do
      expect(connection).to receive(:get).with(
        an_instance_of(String),
        a_hash_including(
          key: 'test_api_key'
        )
      )
      subject.request
    end
  end

  context 'when location is coordinates' do
    before do
      params[:from] = [0, 0]
    end

    it 'requests with params values' do
      expect(connection).to receive(:get).with(
        an_instance_of(String),
        a_hash_including(
          origin: '0,0',
          destination: '',
          departure_time: 0
        )
      )
      subject.request
    end
  end

  context 'when providing custom options' do
    before do
      params[:traffic_model] = 'nothing'
      params[:mode] = 'walking'
    end

    it 'requests with provided params' do
      expect(connection).to receive(:get).with(
        an_instance_of(String),
        a_hash_including(
          traffic_model: 'nothing',
          mode: 'walking'
        )
      )
      subject.request
    end
  end
end
