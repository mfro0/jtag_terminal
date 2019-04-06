GHDL = ghdl

VPATH=.:..
MODULES= \
	../jtag_terminal.vhd \
	../jtag_uart.vhd \
	../deca_reset.vhd \
	../reset_button.vhd \
	../blinker.vhd \
   	tb.vhd

GHDLFLAGS=--std=08 -Paltera --ieee=synopsys -Wno-binding
GHDL_RUNFLAGS=--ieee-asserts=disable-at-0

.PHONY: all
all:    tb

tb: $(MODULES)
	$(GHDL) -i $(GHDLFLAGS) $(MODULES)
	$(GHDL) -m $(GHDLFLAGS) tb

run: $(MODULES)
	$(GHDL) -r $(GHDLFLAGS) tb --disp-tree $(GHDL_RUNFLAGS) --wave=tb.ghw

.PHONY: view
view:
	gtkwave tb.ghw tb.gtkw

.PHONY: clean
clean:
	rm -f *.o *.cf e*.lst *.ghw
