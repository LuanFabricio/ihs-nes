CA=ca65
LD=ld65

FILENAME=main
LD_FLAGS=-v --target nes

all:
	$(CA) $(FILENAME).asm
	$(CA) src/reset.asm
	$(CA) src/background.asm
	$(CA) src/player.asm
	$(LD) src/reset.o $(FILENAME).o src/background.o src/player.o $(LD_FLAGS) -o $(FILENAME).nes

run:
	make
	fceux $(FILENAME).nes
