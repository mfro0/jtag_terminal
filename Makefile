LANG=C
ifeq ($(OS),Windows_NT)
	ALTPATH=c:/opt/altera/13.1/quartus/bin64
	PROJ=jtag_terminal_cy3
	ALTOPT=
else
	ALTPATH=/opt/intelFPGA_lite/18.1/quartus/bin
	PROJ=jtag_terminal
	ALTOPT=--64bit
endif
BITSTREAM=output_files/$(PROJ).sof


all: precmd synthesis fitter assembler timing_analyzer eda

precmd:
	$(ALTPATH)/quartus_sh -t precmd.tcl

synthesis:
	$(ALTPATH)/quartus_map --read_settings_files=on --write_settings_files=off $(ALTOPT) $(PROJ) -c $(PROJ)

fitter:
	$(ALTPATH)/quartus_fit --read_settings_files=off --write_settings_files=off $(ALTOPT) $(PROJ) -c $(PROJ)

assembler:
	$(ALTPATH)/quartus_asm --read_settings_files=off --write_settings_files=off $(ALTOPT) $(PROJ) -c $(PROJ)

timing_analyzer:
	$(ALTPATH)/quartus_sta $(ALTOPT) $(PROJ)

eda:
	$(ALTPATH)/quartus_eda --read_settings_files=off --write_settings_files=off $(ALTOPT) $(PROJ) -c $(PROJ)

# program the beast
p: $(BITSTREAM)
	$(ALTPATH)/quartus_pgm $(ALTOPT) -m JTAG --cable 1 -o P\;$(BITSTREAM)@1

.PHONY: clean
clean:
	rm -rf db incremental_db
