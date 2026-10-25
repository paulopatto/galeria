# Projeto e arquitetura

Galeria é uma aplicação de demonstração de deploy em Ruby e Sinatra clássico
(`Sinatra::Application`), com páginas HTML em ERB. Não é uma aplicação Rails.

| Caminho | Responsabilidade |
| --- | --- |
| `app.rb` | Rotas, sessões e coleção de imagens em memória |
| `config.ru` | Entrada Rack; execute os comandos a partir da raiz do projeto |
| `views/`, `public/style.css` | Templates, parciais e estilos |
| `config/otel-middleware.rb` | SDK, instrumentação e middleware OpenTelemetry |
| `spec/spec_helper.rb` | RSpec, Rack::Test e configuração da aplicação de teste |
| `spec/features/home_spec.rb` | Testes HTTP existentes da página inicial |
| `swagger.yaml`, `docs.html` | Contrato OpenAPI e página de documentação |
| `Dockerfile`, `Procfile`, `Makefile` | Empacotamento e execução |
| `.github/workflows/` | Release Drafter e publicação de imagens |

`POST /` adiciona uma imagem aleatória e redireciona para `/`; `GET /` lista
as imagens; `GET /photo/:id` mostra uma imagem. `/docs` e `/swagger.yaml`
servem a documentação. A coleção e o contador vivem no processo: não há banco,
persistência entre reinícios ou isolamento por sessão. Não pressuponha que o
404 declarado no OpenAPI já seja implementado para uma foto inexistente.
