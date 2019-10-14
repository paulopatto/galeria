require 'spec_helper'

describe 'GET /' do
  before do
    get '/'
  end

  it 'response :success' do
    expect(last_response.status).to eq 200
  end

  it 'display new upload buttom' do
    expect(last_response.body).to include('New Art Piece')
  end
end
