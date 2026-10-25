require 'spec_helper'

RSpec.describe 'HTTP da galeria', type: :request do
  it 'entrega HTML com layout, formulário POST e estilos locais' do
    get '/'

    expect(last_response.status).to eq(200)
    expect(last_response.content_type).to include('text/html')
    expect(last_response.body).to include('id="header"', 'id="footer"', 'Gallery Web')
    expect(last_response.body).to match(/<form method="post"\s*>/)
    expect(last_response.body).to match(%r{<link href="(?:http://example.org)?/style.css" rel="stylesheet"})
  end

  it 'cria IDs sequenciais e preserva título e URL entre listagem e detalhe' do
    2.times do
      post '/'
      expect(last_response.status).to eq(302)
      expect(URI(last_response.location).path).to eq('/')
      follow_redirect!
      expect(last_response.status).to eq(200)
    end
    expect(photo_links).to eq(['/photo/1', '/photo/2'])
    images = image_urls
    expect(images.size).to eq(2)
    expect(images.keys).to contain_exactly('Picture number 1', 'Picture number 2')

    images.each do |title, url|
      uri = URI(url)
      expect(uri.scheme).to eq('https')
      expect(uri.host).to eq('unsplash.it')
      expect(uri.path).to eq('/600/500')
      expect(0..1084).to cover(Integer(URI.decode_www_form(uri.query).to_h.fetch('image')))

      get "/photo/#{title.split.last}"
      expect(last_response.status).to eq(200)
      expect(image_urls).to eq(title => url)
    end
  end

  it 'compartilha a coleção entre visitantes, conforme o armazenamento em memória' do
    post '/'
    clear_cookies
    get '/photo/1'

    expect(last_response.status).to eq(200)
    expect(image_urls.keys).to eq(['Picture number 1'])
  end

  %w[999 0 -1 abc 1abc 1.5].each do |id|
    it "responde 404 para a foto #{id.inspect} sem alterar a coleção" do
      post '/'
      get "/photo/#{id}"

      expect(last_response.status).to eq(404)
      expect(last_response.body).to include('Image not found')

      get '/'
      expect(photo_links).to eq(['/photo/1'])
    end
  end

  it 'responde 404 para uma rota desconhecida' do
    get '/missing'
    expect(last_response.status).to eq(404)
  end

  it 'serve o CSS usado pelo layout' do
    get '/style.css'
    expect(last_response.status).to eq(200)
    expect(last_response.content_type).to include('text/css')
    expect(last_response.body).to include('.gallery')
  end
end
