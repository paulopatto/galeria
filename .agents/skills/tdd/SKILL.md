---
name: tdd
description: Desenvolva funcionalidades ou corrija bugs Ruby e Sinatra com ciclos de teste falhando, implementação mínima e refatoração com RSpec e Rack::Test.
---

# TDD com RSpec e Rack::Test

Adaptação de Matt Pocock; origem e licença em [SOURCES.md](../../SOURCES.md).

## Escolher o comportamento

Leia `AGENTS.md`, o spec próximo e os critérios de aceitação. Use a fronteira
HTTP existente como padrão para rotas: um usuário envia uma requisição e observa
status, cabeçalhos, redirecionamento e HTML. Para um objeto Ruby com lógica
própria, teste sua interface pública quando isso trouxer cobertura útil.
Explicite decisões de teste que mudem o escopo acordado.

## Um ciclo de cada vez

1. **Red:** escreva um exemplo que reproduza o bug ou comportamento necessário.
   Execute-o e confirme que falha pelo motivo esperado. Erro de dependência,
   sintaxe ou configuração não comprova a ausência do comportamento.
2. **Green:** escreva apenas o código necessário para o exemplo passar e execute
   novamente. Não escreva todos os testes e toda a implementação em dois lotes.
3. **Refactor:** com os testes verdes, simplifique duplicações ou nomes que
   surgiram nesta mudança e execute os specs afetados outra vez.
4. Repita para o próximo cenário; ao terminar, execute a suíte completa.

```sh
RACK_ENV=test OTEL_TRACES_EXPORTER=none bundle exec rspec spec/features/home_spec.rb
RACK_ENV=test OTEL_TRACES_EXPORTER=none bundle exec rspec
# Reproduza falhas de ordem com o seed reportado pelo RSpec:
RACK_ENV=test OTEL_TRACES_EXPORTER=none bundle exec rspec --seed 1234
```

## Testes que valem manter

Este exemplo usa a configuração Rack::Test já presente em `spec_helper.rb`:

```ruby
require 'spec_helper'

describe 'POST /' do
  it 'redireciona para a galeria' do
    post '/'

    expect(last_response.status).to eq(302)
    expect(last_response.headers['Location']).to end_with('/')
  end
end
```

- Use resultados independentes da implementação e nomes que descrevam o
  comportamento. Não recalcule o valor esperado com o mesmo algoritmo do código.
- Prepare dados pela interface pública. A coleção de imagens é compartilhada
  no processo: não pressuponha ID 1, lista vazia ou ordem dos exemplos. Para
  testar uma foto, crie-a e obtenha seu link pela resposta HTTP.
- Não leia variáveis internas da aplicação nem teste chamadas a métodos privados.
- Use doubles nas fronteiras externas quando necessário, como relógio,
  aleatoriedade ou clientes remotos; mantenha os verificadores de doubles do
  RSpec ativos. Não substitua toda a aplicação por mocks.
- Não baixe imagens remotas para verificar o HTML e não exija coletor OTEL.
- Mudanças somente documentais não precisam de exemplos RSpec sem comportamento.

Registre o red observado, o green e o comando final. Se não for possível executar,
informe o bloqueio; não apresente testes escritos como testes aprovados.
