---
name: code-review
description: Revise um diff ou PR da Galeria contra os requisitos solicitados e os padrões Ruby, Sinatra, Rack e RSpec do repositório.
---

# Revisão de código

Adaptação de Matt Pocock; origem e licença em [SOURCES.md](../../SOURCES.md).

## Fixar o que será revisado

Use a referência ou PR solicitado. Para uma branch, confirme a base e leia
`git diff <base>...HEAD` e `git log <base>..HEAD --oneline`; para mudanças
locais, leia também `git diff` e `git diff --cached`. Inclua arquivos novos
relevantes que ainda não estejam no diff. A base padrão do projeto é `master`.
Se o escopo não puder ser determinado pelo contexto, esclareça antes de revisar.

Leia o pedido, spec ou issue associada e `AGENTS.md`. Se não houver spec formal,
use os critérios da conversa e informe essa fonte; não invente requisitos.

## Revisar por dois eixos

**Requisitos:** verifique critérios ausentes, implementação incorreta, cenários
de falha e alterações de escopo. Relacione cada achado ao requisito correspondente.

**Padrões:** confira compatibilidade Ruby 2.6, Sinatra clássico, contrato Rack,
ERB, estado em memória, tracing e testes independentes da ordem. Procure
regressões demonstráveis, exposição de segredos, falta de validação e abstrações
sem necessidade. Separe falhas concretas de sugestões de estilo.

Leia o código ao redor das mudanças antes de concluir. Confirme se os testes
executados cobrem o comportamento alterado e se seus resultados foram reportados
com precisão. Em skills e documentação, confira links, metadados, comandos,
referências de origem e possíveis instruções contraditórias.

Faça os dois eixos sequencialmente; revisão paralela só quando autorizada e
suportada pela ferramenta.

## Relatar

Liste achados por eixo, com severidade, arquivo/linha, cenário, impacto e correção
sugerida. Não publique comentários no GitHub nem altere código quando o pedido
for apenas revisar. Se não houver achados, diga isso e informe os limites da
validação. Não bloqueie a entrega com preferências de estilo sem impacto.
