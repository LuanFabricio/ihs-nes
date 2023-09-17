CA=ca65
LD=ld65

FILENAME=main
LD_FLAGS=-v --target nes

all:
	$(CA) $(FILENAME).asm
	$(CA) src/reset.asm
	$(LD) src/reset.o $(FILENAME).o $(LD_FLAGS) -o $(FILENAME).nes

run:
	make
	fceux $(FILENAME).nes
