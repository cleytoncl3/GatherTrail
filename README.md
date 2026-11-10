# ForagerOre

Complemento para o [Forager](https://github.com/jonlipin/forager) (WoW Forever / Classic). Guia você até **minérios, ervas e criaturas esfoláveis**.

O cliente Classic não deixa addons ler os pontos de tracking do minimapa, então o ForagerOre **memoriza os locais onde você coleta** (como o GatherMate). Quanto mais você coleta, mais ele sabe.

## Recursos

- **Seta direcional** na tela apontando para o ponto mais próximo que você consegue coletar, com distância.
- **Linha no minimapa** até o alvo (linha reta; o jogo não tem pathfinding para addons).
- **Ícones no minimapa e no mapa (M)**: borda **amarela** = sua skill alcança, **vermelha** = skill insuficiente.
- **Mineração, Herbalismo e Esfolamento**. Cada um pode ser ligado/desligado.
- **Esfolamento**: cadáveres esfoláveis que você lootou (ou viu pelo mouse/alvo) aparecem por alguns minutos e somem quando esfolados ou expirados.
- **Alcance ajustável** (50 a 2000 jardas) por barra de rolagem.
- Esconde um ponto recém-coletado enquanto ele renasce (tempo ajustável).

## Comandos

- `/fore` abre as opções
- `/fore range 800` define o alcance
- `/fore lock` trava/destrava a seta (destravada, arraste para mover)
- `/fore clear` apaga os pontos salvos
- `/fore debug`

## Instalação / atualização

1. Baixe o zip do repositório e coloque a pasta como `Interface/AddOns/ForagerOre`.
2. Para atualizar depois, é só dar duplo clique em **Update.bat** dentro da pasta. Ele baixa a versão mais recente do GitHub sozinho (não precisa de git). Seus pontos salvos não são apagados.
