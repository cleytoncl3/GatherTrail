# GatherTrail - Trilha do Coletor

Addon de coleta para WoW Classic / WoW Forever. Ele te guia até **minérios, ervas e criaturas esfoláveis** com uma seta na tela, uma linha no minimapa e ícones no minimapa e no mapa-múndi.

É um addon independente e funciona sozinho. Combina bem com addons de tracking, como o Forager, mas não usa nenhum código dele.

## Idiomas / Languages / Idiomas

O addon detecta o idioma do jogo e já inicia nele: **Português (ptBR)**, **English** (padrão para qualquer outro idioma) e **Español (esES/esMX)**. Menus, opções, dicas e mensagens do chat são traduzidos. / The addon detects the game client language and starts in it: Portuguese, English (default) and Spanish. / El addon detecta el idioma del juego y arranca en él: portugués, inglés (por defecto) y español.

## Autoloot só de coleta

Com a opção ligada (padrão), ao minerar, colher ervas ou esfolar o addon pega sozinho os itens da janela de loot daquela coleta, mesmo com o autoloot do jogo desligado. Drops de monstros comuns e baús não são afetados. O rastreio de cadáveres esfoláveis foi removido (o jogo não oferece como detectá-los de forma confiável); o autoloot do esfolamento continua.

## Para que serve

O cliente Classic **não deixa addons ler os pontos de tracking do minimapa** (Find Minerals, Find Herbs). Por isso o GatherTrail aprende os locais sozinho, como o GatherMate: toda vez que você coleta um recurso, a posição é gravada. Quanto mais você joga, mais ele sabe. Os recursos renascem no mesmo lugar, então os pontos continuam úteis.

## O que ele mostra

- **Seta direcional** na tela apontando para o ponto mais próximo que você consegue coletar, com o tipo e a distância em jardas.
- **Linha no minimapa** até o alvo. É uma linha reta: o jogo não oferece pathfinding para addons.
- **Ícones no minimapa e no mapa (M)** com o ícone do recurso:
  - borda **verde**: sua skill da profissão alcança;
  - borda **vermelha** (ícone cinza): skill insuficiente.
- **Alcance ajustável** de 50 a 2000 jardas, por barra de rolagem.
- **Três profissões**, cada uma liga/desliga: Mineração, Herbalismo e Esfolamento.

## Como funciona por dentro

- **Mineração e Herbalismo:** ao lançar o feitiço da profissão, guarda sua posição. Quando abre o loot de um *objeto do mundo* com o minério/erva esperado, o ponto é salvo (a identificação é pelo ID do item, então funciona em qualquer idioma). Pontos a menos de 15 jardas do mesmo tipo são unidos.
- **Aprender pelo mouse:** o jogo desenha os veios do rastreamento no minimapa e mostra o nome numa dica ao passar o mouse, mas nao entrega a posicao a nenhum addon. Quando a dica do minimapa mostra um minerio ou erva conhecido, o GatherTrail calcula a posicao pelo cursor (centro, zoom e rotacao do minimapa) e grava o ponto, sem precisar coletar. A precisao e de alguns metros.
- **Banco inicial (opcional):** se o addon de dados `GatherTrailData` estiver instalado, o GatherTrail carrega locais de minerios e ervas (Classic) ja conhecidos, uma zona por vez, e converte para as coordenadas do jogo na hora. Os dados vem do GatherMate2_Data (GPL) e ficam num addon separado para nao misturar licencas. Tudo que voce coletar ou aprender pelo mouse tem prioridade sobre o banco.
- **Respawn:** o ponto recém-coletado fica escondido por um tempo ajustável (300 s por padrão).
- **Esfolamento:** quando você lota uma criatura, ou passa o mouse/alvo em um cadáver, o addon lê a dica do jogo ("Esfolável"). Se estiver esfolável, o cadáver entra na lista por cerca de 7 minutos e sai quando você esfola ou ele expira. Esses cadáveres não ficam salvos. A posição é a sua no momento do loot (boa); se você só mirou de longe, é aproximada. Cadáveres que você nunca viu ou lotou não aparecem.
- **Skill:** lida da sua janela de habilidades. A skill necessária vem de uma tabela por item (Cobre a Titânio, Peacebloom a Mana Thistle) e, no esfolamento, do nível da criatura.
- **Posição:** usa `UnitPosition` (coordenadas do mundo) para distância e direção, e `C_Map` para os ícones do mapa-múndi.
- Os dados ficam em `WTF/.../SavedVariables/GatherTrail.lua` e **não são apagados** ao atualizar o addon.

O addon só mostra informação. Ele não automatiza nenhuma ação do personagem.

## Comandos

| Comando | O que faz |
|---|---|
| `/gt` ou `/gathertrail` | abre a janela de opções |
| `/gt range 800` | define o alcance (jardas) |
| `/gt lock` | trava/destrava a seta (destravada, arraste para mover) |
| `/gt test` | modo de teste: mostra a seta e o botao Scan mesmo sem minerio, para voce arrastar para onde quiser |
| `/gt scan` | atualiza agora e mostra no chat o que ha no alcance (minerios, ervas, cadaveres) |
| `/gt skip` | pula o ponto atual e mostra o proximo mais perto (`/gt skip always` remove para sempre) |
| `/gt unskip` | os pontos pulados voltam a aparecer |
| `/gt toggle` | ativa/desativa o addon |
| `/gt clear` | apaga todos os pontos salvos |
| `/gt debug` | mostra contagens e skills lidas |

Na janela de opções: ligar/desligar cada profissão, seta, linha, ícones do minimapa e do mapa, mostrar vermelhos, seta para vermelhos, alcance, tempo de respawn e tamanho da seta.

## Controles

- **Botao Pular** embaixo da seta (Shift+clique remove o ponto para sempre) e tecla configuravel em Teclas > AddOns > GatherTrail.
- **Botao Scan** fica sempre visivel junto da seta (ou clique do meio no icone do minimapa): atualiza na hora e lista o que existe no alcance. A lista tambem se atualiza sozinha o tempo todo (a cada 0,5 s), entao o botao e so uma conferencia manual.
- **Mover a seta:** Shift+arrastar (ou destrave com `/gt lock`).
- **Icone no minimapa:** clique esquerdo abre as opcoes, clique direito ativa/desativa, arraste para mudar de posicao.

## Instalação e atualização

1. Baixe o repositório e coloque a pasta como `Interface/AddOns/GatherTrail`.
2. Para atualizar, dê duplo clique em **Update.bat** dentro da pasta. Ele baixa a versão mais recente do GitHub (não precisa de git).

## Licença

MIT. Veja `LICENSE`.
