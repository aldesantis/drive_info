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
        from: 'avenida joão crisostomo',
        to: 'lx factory'
      }
    end

    before do
      Timecop.freeze(Time.local(1990))
      param[:provider_options][:key] = nil
    end

    after { Timecop.return }

    it 'calls' do
      result = subject.route_time(route_params)
      expect(result).not_to eq(nil)
    end
  end
end
