---
name: grill-me
description: Esclareça uma ideia ou decisão antes de implementá-la quando o usuário pedir uma entrevista ou houver escolhas relevantes em aberto.
disable-model-invocation: true
---

# Grill me

Adaptação de Matt Pocock; origem e licença em [SOURCES.md](../../SOURCES.md).

1. Leia o pedido e os arquivos relevantes. Descubra fatos no repositório antes
   de perguntar; respeite decisões já tomadas na conversa.
2. Organize as decisões por dependência: objetivo, usuários, comportamento,
   restrições, compatibilidade, falhas e critérios de aceitação.
3. Pergunte em rodadas curtas somente o que já pode ser decidido. Numere as
   perguntas, explique o impacto e dê uma recomendação para cada uma.
   Não pergunte na mesma rodada algo que depende de uma resposta ainda aberta.
4. Incorpore as respostas e avance para as decisões desbloqueadas. Evite
   perguntas sobre detalhes reversíveis que o agente pode resolver pelo código.
5. Encerre com objetivo, decisões, critérios de aceitação e pontos pendentes.
   Confirme as novas decisões relevantes antes de implementar; uma autorização
   anterior que já cubra o trabalho continua válida.

Na Galeria, investigue primeiro se a mudança afeta rotas HTML, estado em memória,
ERB, tracing ou execução. Não presuma persistência, Rails ou uma API JSON.
Se o próximo passo for registrar o acordo, use [to-spec](../to-spec/SKILL.md).
