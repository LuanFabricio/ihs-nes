# IHS NES

# O que é?
Um jogo de xadrez feito para o Nintendo Entertainment System (NES). Esse jogo não só utiliza o código **Assemly 6502** da ROM para rodar, ele também utiliza scripts feitos em **Lua** para controlar o tabuleiro e **Python** como inteligência artificial.

# Demo
https://github.com/LuanFabricio/ihs-nes/assets/47309921/a1ef7bc5-3bec-4b7a-aa6f-41c0c84e57bf

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

Caso ocorra algum erro e o emulador crashe tente uma das seguintes opções:
1. Abrir o emulador no terminal com os scripts carregados.
    1. Abra o terminal e acesse a pasta do projeto.
    2. Inicie o emulador com os scripts de Lua carregados, executando o comando `fceux --loadlua luascripts/main.lua`
2. Abrir o emulador no terminal.
    1. Abra o terminal e acesse a pasta do projeto.
    2. Abra o emulador utilizando o comando `fceux`.
    3. Carregue os scripts de Lua acessando `File -> Load Lua Script`, depois clique em Browse e procure a pasta do projeto, acesse o arquivo `luascripts/main.lua` e clique no botão **Start**.
    4. Carregue a ROM acessando `File -> Open ROM`.

# Desenvolvimento
Caso você queria contribuir para o projeto, é necessário instalar algumas dependências que são utilizadas na execução dos testes.

## Dependências
- `bitop`
    - Para instalar o pacote basta seguir as instruções do [site](https://luarocks.org/modules/luarocks/luabitop) **luarocks**.
- `busted`
    - Para instalar o pacote basta seguir as instruções do [repositório](https://github.com/lunarmodules/busted) do projeto.
    - Caso você queria instalar com o **luarocks** basta usar o comando `luarocks install busted`.
    - Observação! Se o `busted` não ficar no seu `PATH`
        1. Procure o caminho do binário utilizando o comando `luarocks show busted`.
        2. Adicione o caminho do binário no `PATH`, utilizando o comando `export PATH=/caminho/do/busted:$PATH`.
        3. Caso você queira que o último comando persista, o adicione no seu `.zshrc` ou `.bashrc`.

## Testando o projeto
Atualmente o projeto só possui testes para o código feito em lua, então o único comando de teste que ele possui é o
```sh
make test-scripts
```
que irá rodar todos os testes feitos na pasta `luascripts/tests`.

# Todas as dependências do projeto
- `cc65`
- `AI-Chess`
    - Utilizando a versão `3.9.18` do python.
- `bitop`
    - Utilizando a versão `5.1.5` do Lua.
- `busted`
    - Utilizando a versão `5.1.5` do Lua.

Atenção! Caso você utilize o gerenciador de versões `asdf-vm`, por favor, verifique se todas as versões das linguagens listadas no arquivo `.tool-versions` estão instaladas.

# Referências
Todas as referências utilizadas estão no arquivo [REFERENCES.md](https://github.com/LuanFabricio/ihs-nes/blob/main/REFERENCES.md).
