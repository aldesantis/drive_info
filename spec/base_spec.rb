# frozen_string_literal: true

RSpec.describe DriveInfo do
  subject { described_class.new(param) }

  let(:param) do
    {
      provider: :gmaps,
      provider_options: {
        key: 'test key'
      },
      debug: false,
      cache: nil
    }
  end

  before do
    described_class.configure do |config|
      config.provider = :gmaps
      config.provider_options = { key: 'test key' }
      config.cache = nil
      config.debug = false
    end
  end

  context 'initializer params' do
    it 'accepts provider' do
      expect(subject.provider).to eq(param[:provider])
    end

    it 'accepts provider options' do
      expect(subject.provider_options).to eq(param[:provider_options])
    end

    it 'accepts cache' do
      expect(subject.cache).to eq(param[:cache])
    end
  end

  describe '#route_time' do
    let(:route_params) do
      {
        from: '91256 Overseas Hwy, Tavernier, FL 33070, EUA',
        to: '593 NW 82nd Ave, Hialeah Gardens, FL 33016, EUA',
      }
    end

    before do
      Timecop.freeze(Time.now + 10 * 60 * 60)
      param[:provider_options][:key] = nil
    end

    after { Timecop.return }

    it 'calls' do
      result = subject.route_time(route_params)
      expect(result).not_to eq(nil)
    end
  end

  describe '#batch_route_time' do
    let(:route_params) do
      {
        from: '91256 Overseas Hwy, Tavernier, FL 33070, EUA',
        to: '593 NW 82nd Ave, Hialeah Gardens, FL 33016, EUA',
      }
    end

    let(:requests) do
      [
        route_params,
        route_params,
        {
          from: 'invalid',
          to: 'invalid',
          depart_time: Time.now - 2 * 60 * 60
        }
      ]
    end

    before do
      Timecop.freeze(Time.now + 10 * 60 * 60)
      param[:provider_options][:key] = nil
    end

    after { Timecop.return }

    it 'calls' do
      result = subject.batch_route_time(requests)
      expect(result).not_to eq(nil)
    end
  end
end
