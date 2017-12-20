# frozen_string_literal: true

RSpec.describe DriveInfo::Client do
  class CustomCache
    class << self
      def read(_); end

      def write(_, _); end
    end
  end

  class CustomProvider
    class << self
      def route_time(_)
        DriveInfo.connection.get('http://google.pt')
      end

      def parse(_, _r)
        nil
      end
    end
  end

  subject { described_class.new(params) }

  let(:params) do
    {}
  end

  it 'returns nil as a provider' do
    expect(subject.provider).to eq(nil)
  end

  it 'returns nil cache' do
    expect(subject.cache).to be_nil
  end

  it 'returns a faraday connection' do
    expect(subject.connection).to be_a(Faraday::Connection)
  end

  describe '#call' do
    subject { described_class.new(params).call(:route_time, [arguments]) }

    let(:arguments) do
      {}
    end

    before do
      allow(DriveInfo).to receive(:provider).and_return(CustomProvider)
    end

    it 'performes a single request' do
      expect(CustomProvider).to receive(:route_time)
        .once
        .and_return(OpenStruct.new(body: { status: 'OK' }))
      subject
    end

    context 'when batch requests' do
      let(:arguments) do
        {
          requests: [{}, {}, {}]
        }
      end

      it 'performes a multiples requests' do
        expect(CustomProvider).to receive(:route_time)
          .exactly(3)
          .times
          .and_return(OpenStruct.new(body: { status: 'OK' }))
        subject
      end

      it 'returns an array with responses' do
        expect(subject).to eq([
          nil,
          nil,
          nil
        ])
      end
    end
  end

  context 'when caching is provided' do
    subject { described_class.new(params).call(:route_time, [arguments]) }

    let(:arguments) do
      {}
    end

    before do
      allow(DriveInfo).to receive(:provider).and_return(CustomProvider)
      allow(DriveInfo).to receive(:cache).and_return(CustomCache)
      allow(DriveInfo.connection).to receive(:get).and_return(nil)
    end

    it 'uses read cache' do
      expect(CustomCache).to receive(:read).once
      subject
    end

    it 'write to cache' do
      expect(CustomCache).to receive(:write).once
      subject
    end

    context 'when batching requests' do
      let(:arguments) do
        {
          requests: [{}, {}, {}]
        }
      end

      it 'uses read cache' do
        expect(CustomCache).to receive(:read)
          .exactly(3)
          .times
        subject
      end

      it 'write to cache' do
        expect(CustomCache).to receive(:write)
          .exactly(3)
          .times
        subject
      end
    end
  end
end
