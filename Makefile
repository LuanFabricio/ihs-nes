CA=ca65
LD=ld65

FILENAME=main
LD_FLAGS=-v --target nes

all:
	$(CA) $(FILENAME).asm
	$(CA) src/reset.asm
	$(CA) src/background.asm
	$(CA) src/player.asm
	$(CA) src/player2.asm
	$(CA) src/game_rules.asm
	$(LD) src/reset.o $(FILENAME).o src/background.o src/player.o src/player2.o src/game_rules.o $(LD_FLAGS) -o $(FILENAME).nes

run:
	make
	fceux --loadlua luascripts/main.lua $(FILENAME).nes

test-scripts:
	cd luascripts; busted tests/*/*
