require 'rails_helper'

RSpec.describe 'PWA assets', type: :request do
  it 'serves the web app manifest' do
    get '/manifest.webmanifest'

    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq('application/manifest+json')
    expect(response.body).to include('"display": "standalone"')
  end

  it 'serves the service worker script' do
    get '/service-worker.js'

    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq('text/javascript').or eq('application/javascript')
    expect(response.body).to include('CACHE_NAME')
  end

  it 'serves the offline fallback page' do
    get '/offline.html'

    expect(response).to have_http_status(:ok)
    expect(response.body.force_encoding('UTF-8')).to include('オフラインです')
  end
end
