require 'spec_helper'

RSpec.describe 'Jornada do visitante na galeria', type: :acceptance do
  it 'encontra uma galeria vazia e cria a primeira peça pelo formulário' do
    get '/'

    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('<title>Gallery Web</title>', 'High Art')
    expect(last_response.body).to match(/<form method="post"\s*>/)
    expect(last_response.body).to include('value="New Art Piece" type="submit"')
    expect(photo_links).to be_empty

    # The form has no action: submit to the current URL, like a browser.
    post last_request.path
    expect(last_response.status).to eq(302)
    follow_redirect!

    expect(last_request.path).to eq('/')
    expect(last_response.status).to eq(200)
    expect(photo_links).to eq(['/photo/1'])
    expect(image_urls.keys).to eq(['Picture number 1'])
  end

  it 'cria duas peças, segue o link de uma foto e volta à coleção preservada' do
    get '/'
    2.times do
      post last_request.path
      follow_redirect!
    end
    expect(photo_links).to eq(['/photo/1', '/photo/2'])
    first_image_url = image_urls.fetch('Picture number 1')

    get photo_links.first

    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/photo/1')
    expect(image_urls).to eq('Picture number 1' => first_image_url)
    expect(last_response.body).to include('Wow, so evocative.')
    back_link = last_response.body.match(%r{<a href="([^"]+)"><input value="Back"})
    expect(back_link).not_to be_nil

    get back_link[1]

    expect(last_request.path).to eq('/')
    expect(last_response.status).to eq(200)
    expect(photo_links).to eq(['/photo/1', '/photo/2'])
  end

  it 'recarrega a listagem sem criar novas peças' do
    post '/'
    follow_redirect!
    original_images = image_urls
    get last_request.path

    expect(last_response.status).to eq(200)
    expect(image_urls).to eq(original_images)
    expect(photo_links.size).to eq(1)
  end
end
