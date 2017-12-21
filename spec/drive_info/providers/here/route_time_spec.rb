# frozen_string_literal: true

RSpec.describe DriveInfo::Providers::Here::RouteTime do
  subject { described_class.new(params) }

  let(:params) do
    {
      from: '',
      to: '',
      depart_time: depart_time
    }
  end

  let(:depart_time) { Time.now }

  let(:connection) { instance_double('Faraday::Connection') }

  before do
    allow(DriveInfo).to receive(:connection).and_return(connection)
  end

  it 'requests with params values' do
    expect(connection).to receive(:get).with(
      an_instance_of(String),
      a_hash_including(
        waypoint0: '',
        waypoint1: '',
        departure: depart_time.iso8601
      )
    )
    subject.request
  end

  it 'requests with default mode' do
    expect(connection).to receive(:get).with(
      an_instance_of(String),
      a_hash_including(
        mode: 'fastest;car;traffic:enabled'
      )
    )
    subject.request
  end
end
