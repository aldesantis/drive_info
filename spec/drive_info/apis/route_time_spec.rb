# frozen_string_literal: true

RSpec.describe DriveInfo::Apis::RouteTime do
  subject { described_class.new(params) }

  let(:params) do
    {
      from: '',
      to: '',
      depart_time: ''
    }
  end

  it 'requires from param' do
    params[:from] = nil
    expect { subject }.to raise_error(ArgumentError, 'from is required')
  end

  it 'requires to param' do
    params[:to] = nil
    expect { subject }.to raise_error(ArgumentError, 'to is required')
  end

  it 'requires depart time param' do
    params[:depart_time] = nil
    expect { subject }.to raise_error(ArgumentError, 'depart_time is required')
  end

  context 'with custom options' do
    let(:params) do
      {
        from: '',
        to: '',
        depart_time: '',
        custom_option: 1
      }
    end

    it 'returns options with extra options only' do
      expect(subject.options).to eq(custom_option: 1)
    end
  end
end
