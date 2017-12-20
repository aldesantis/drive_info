# frozen_string_literal: true

RSpec.describe DriveInfo::Providers::Here do
  subject { described_class.new(options) }

  let(:options) { {} }

  it 'accepts app_id' do
    options[:app_id] = 'id'
    expect(subject.app_id).to eq('id')
  end

  it 'accepts app_code' do
    options[:app_code] = 'code'
    expect(subject.app_code).to eq('code')
  end

  context 'when authentication details are provided' do
    let(:options) do
      {
        app_id: 'id',
        app_code: 'code'
      }
    end

    before do
      allow(DriveInfo::Providers::Here::RouteTime).to receive(:request)
    end

    it 'requests with authentication details' do
      expect(DriveInfo::Providers::Here::RouteTime).to receive(:request)
        .with(a_hash_including(
          app_id: 'id',
          app_code: 'code'
        ))
      subject.route_time
    end
  end

  describe '#parse' do
    subject { described_class.new.parse(:route_time, response) }

    let(:response) do
      {
        response: {
          route: [
            {
              leg: [
                {
                  length: 4012,
                  travelTime: 584
                }
              ]
            }
          ]
        }
      }
    end

    it 'returns valid response' do
      expect(subject.error).to be_nil
    end

    it 'returns the duration' do
      expect(subject.value).to eq(584)
    end

    context 'when invalid response' do
      let(:response) do
        {
          type: 'ApplicationError',
          details: 'Longitude is missing'
        }
      end

      it 'returns an error response' do
        expect(subject.error).to be('ApplicationError')
      end
    end
  end
end
