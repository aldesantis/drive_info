# frozen_string_literal: true

RSpec.describe DriveInfo do
  subject { described_class.new(param) }

  let(:param) do
    {
      provider: :gmaps,
      key: 'test key'
    }
  end

  context 'initializer params' do
    it 'accepts provider' do
      expect(subject.provider).to eq(param[:provider])
    end

    it 'accepts key' do
      expect(subject.key).to eq(param[:key])
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
      param[:key] = nil
    end

    after { Timecop.return }

    it 'calls' do
      result = subject.route_time(route_params)
      expect(result).not_to eq(nil)
    end
  end
end
