---
name: to-spec
description: Transforme requisitos e decisões já discutidos em uma especificação implementável para este projeto.
disable-model-invocation: true
---

# Da conversa à especificação

Adaptação de Matt Pocock; origem e licença em [SOURCES.md](../../SOURCES.md).

Sintetize o contexto existente, sem iniciar outra entrevista. Consulte o código
para separar comportamento atual de comportamento desejado. Registre decisões
pendentes como pendentes, sem inventar requisitos.

Use uma estrutura proporcional ao trabalho:

1. **Problema e objetivo:** quem é afetado e qual resultado espera.
2. **Comportamento esperado:** cenários concretos, entradas, respostas HTTP,
   redirecionamentos, erros e conteúdo visível quando aplicável.
3. **Critérios de aceitação:** condições observáveis e verificáveis.
4. **Decisões técnicas:** compatibilidade Ruby/Sinatra, responsabilidades,
   estado e possíveis mudanças de contrato.
5. **Validação:** fronteiras públicas testadas, specs existentes relevantes e
   comandos. Prefira HTTP com Rack::Test; explique limites da cobertura.
6. **Fora de escopo e dúvidas:** exclua melhorias não solicitadas.
7. **Fatias de implementação:** entregas verificáveis e suas dependências,
   quando a complexidade justificar.

Entregue na conversa ou em `docs/specs/<tema>.md` se o pedido incluir um arquivo.
Não coloque especificações de produto em `spec/`, reservado aos testes.
Publicar uma issue requer que isso esteja no escopo autorizado.
Use [implement-spec](../implement-spec/SKILL.md) para executar o acordo.
