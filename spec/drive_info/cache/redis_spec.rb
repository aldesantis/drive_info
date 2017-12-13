# frozen_string_literal: true

RSpec.describe DriveInfo::Cache::Redis do
  subject { described_class.new(params) }

  let(:params) do
    {
      redis_url: redis_url,
      ttl: ttl
    }
  end

  let(:redis_url) { 'test' }
  let(:ttl) { 20 }
  let(:redis) { instance_double('Redis') }

  before do
    allow(Redis).to receive(:new).with(url: redis_url).and_return(redis)
  end

  it 'connects to redis' do
    expect(Redis).to receive(:new)
    subject
  end

  it 'connects to redis url' do
    expect(Redis).to receive(:new)
      .with(url: redis_url)
    subject
  end

  context 'when providing a connection' do
    let(:connection) { instance_double('Redis') }

    before do
      params[:connection] = connection
    end

    it 'accepts a connection' do
      expect(subject.connection).to eq(connection)
    end
  end

  describe '#write' do
    let(:key) { 'key' }
    let(:value) { {} }
    let(:cached_value) do
      {
        status: nil,
        body: nil,
        response_headers: nil
      }
    end

    it 'writes to redis instance' do
      expect(redis).to receive(:setex).with(
        key,
        ttl,
        JSON.generate(cached_value)
      )
      subject.write(key, value)
    end
  end

  describe '#read' do
    let(:key) { 'key' }
    let(:value) { {} }

    it 'reads from redis instance' do
      expect(redis).to receive(:get).with(
        key
      )
      subject.read(key)
    end

    context 'when value is cached' do
      before do
        allow(redis).to receive(:get).with(key).and_return('{}')
      end

      it 'returns a faraday response' do
        expect(subject.read(key)).to be_a(Faraday::Response)
      end
    end
  end
end
