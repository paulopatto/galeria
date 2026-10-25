require 'spec_helper'

RSpec.describe 'Documentação pública', type: :request do
  it 'serve o Swagger UI apontando para o contrato local' do
    get '/docs'

    expect(last_response.status).to eq(200)
    expect(last_response.content_type).to include('text/html')
    expect(last_response.body).to include('id="swagger-ui"')
    expect(last_response.body).to include("url: '/swagger.yaml'")
  end

  it 'serve um contrato OpenAPI com as rotas e respostas da galeria' do
    get '/swagger.yaml'

    expect(last_response.status).to eq(200)
    contract = YAML.safe_load(last_response.body)
    expect(contract.fetch('openapi')).to eq('3.0.3')
    expect(contract.dig('paths', '/', 'get', 'responses')).to have_key('200')
    expect(contract.dig('paths', '/', 'post', 'responses')).to have_key('302')
    expect(contract.dig('paths', '/photo/{id}', 'get', 'responses').keys).to contain_exactly('200', '404')
  end
end
