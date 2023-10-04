# IHS NES

# O que é?
Um jogo de xadrez feito para o Nintendo Entertainment System (NES). Esse jogo não só utiliza o código assemly 6502 da ROM para rodar, ele também utiliza scripts feitos em Lua para controlar o tabuleiro e Python como inteligência artificial.

# Como rodar o jogo?
Primeiro, é necessário instalar as dependências, para apenas rodar o jogo basta instalar o pacote `AI-Chess` e o `cc65`. Depois basta instalar o emulador `fceux` e executá-lo.

## Dependências
- `cc65`
    - Para instalar é só seguir as instruções da aba **Getting Started** do [site](https://cc65.github.io/getting-started.html) deles.
- `AI-Chess`
    - Para instalar é só seguir a instrução de instalação no [site](https://pypi.org/project/AI-Chess/) do pip.

Depois disso compile a ROM e a carregue com os scripts de lua.

## Compilando o projeto
Depois de baixar e instalar o compilador `cc65`. Basta executar o comando `make` no terminal, para compilar o projeto.

Depois disso você deverá ter um arquivo que se chama `main.nes` na pasta do projeto.

## Rodando o jogo
Antes de tentar rodar o jogo você deve ter certeza que o emulador está instalando. Caso não esteja procure o nome do pacote na sua distribuição linux ou baixe a versão do próprio [site](https://fceux.com/web/download.html) do `fceux`.

Para rodar o jogo basta utilizar o comando `make run`.

# Desenvolvimento
Caso você queria contribuir para o projeto, é necessário instalar algumas dependências que são utilizadas na execução dos testes.

## Dependências
- `bitop`
    - Para instalar o pacote basta seguir as instruções do [site](https://luarocks.org/modules/luarocks/luabitop) **luarocks**.
- `busted`
    - Para instalar o pacote basta seguir as instruções do [repositório](https://github.com/lunarmodules/busted) do projeto.
    - Caso você queria instalar com o **luarocks** basta usar o comando `luarocks install busted`.

## Testando o projeto
Atualmente o projeto só possui testes para o código feito em lua, então o único comando de teste que ele possui é o
```sh
make test-scripts
```
que irá rodar todos os testes feitos na pasta `luascripts/tests`.

# Todas as dependências do projeto
- `AI-Chess`
- `cc65`
- `bitop`
- `busted`
