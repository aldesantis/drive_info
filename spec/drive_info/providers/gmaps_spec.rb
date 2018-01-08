# frozen_string_literal: true

RSpec.describe DriveInfo::Providers::Gmaps do
  subject { described_class.new }

  describe '#parse' do
    subject { described_class.new.parse(:route_time, response) }

    let(:response) do
      {
        status: status,
        routes: [
          {
            legs: [
              {
                duration_in_traffic: {
                  value: 1
                }
              }
            ]
          }
        ]
      }
    end

    context 'when a valid response is returned' do
      let(:status) { 'OK' }

      it 'returns valid response' do
        expect(subject.error).to be_nil
      end

      it 'returns the duration' do
        expect(subject.value).to eq(1)
      end
    end

    context 'when the NOT_FOUND status is returned' do
      let(:status) { 'NOT_FOUND' }

      it 'returns an error response' do
        expect(subject.error).to be('NOT_FOUND')
      end
    end

    context 'when a generic error with no error message is returned' do
      let(:status) { 'UNKNOWN' }

      it 'returns an error response' do
        expect(subject.error).to be('UNKNOWN')
      end
    end

    context 'when a generic error with an error message is returned' do
      let(:status) { 'UNKNOWN' }

      before do
        response[:error_message] = 'test'
      end

      it 'returns an error response' do
        expect(subject.error).to be('UNKNOWN')
      end

      it 'returns the error message' do
        expect(subject.error_message).to be('test')
      end
    end
  end
end
