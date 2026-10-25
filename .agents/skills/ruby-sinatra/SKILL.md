---
name: ruby-sinatra
description: Implemente ou altere Ruby, rotas Sinatra, templates ERB e middleware Rack na Galeria preservando compatibilidade e contratos HTTP.
---

# Desenvolvimento Ruby e Sinatra

1. Leia `AGENTS.md` e os arquivos afetados. Confira `Gemfile`, lockfile e
   `.ruby-version`: o projeto declara Ruby 2.6.2 e usa Sinatra clássico.
2. Localize a rota em `app.rb`, o template correspondente em `views/` e o
   contrato em `swagger.yaml`. Confira `config.ru` para mudanças de inicialização.
3. Descreva o comportamento esperado, incluindo falhas relevantes. Não use
   convenções Rails, ActiveRecord ou comandos de ferramentas não instaladas.
4. Para comportamento novo ou bug, siga [tdd](../tdd/SKILL.md). Mantenha rotas
   curtas; extraia objetos Ruby apenas para responsabilidades concretas.
5. Preserve status e redirecionamentos, salvo quando a tarefa exigir mudança.
   Confira IDs inválidos ou ausentes quando tocar a rota de foto. Não presuma
   que declarar uma resposta no OpenAPI a implementa.
6. Ao renderizar conteúdo dinâmico, confira escape HTML e validação de entrada.
   Ao trabalhar com sessão, confira a configuração Sinatra/Rack existente.
7. Considere que imagens e IDs estão na memória do processo e se perdem no
   reinício; persistência ou isolamento por usuário exigem mudança explícita.
8. No middleware, preserve `[status, headers, body]`, iteração e fechamento do
   body quando aplicável, contexto de tracing e comportamento em exceções.
9. Execute specs relevantes e suíte completa; confira sintaxe dos arquivos Ruby
   alterados. Para HTML/CSS, confira também a renderização se houver navegador.
10. Atualize documentação de rotas ou execução quando o contrato mudar. Evite
    atualizações de dependências e reformatações sem relação com a tarefa.

O `app.rb` carrega dotenv em development/test e configura OpenTelemetry durante
o require. Defina `RACK_ENV=test` e `OTEL_TRACES_EXPORTER=none` antes de rodar os
testes. Um problema de instalação não justifica alterar o lockfile automaticamente.
