
.PHONY: all clean show

all: output.pdf

output.pdf: input erdot Erdot/Parser.pm
	cat input | ./erdot | twopi -Tps -ooutput.ps
	ps2pdf output.ps output.pdf
	rm output.ps

Erdot/Parser.pm: grammar.pl
	perl -MParse::RecDescent - grammar.pl Erdot::Parser
	mkdir -p Erdot
	mv -f Parser.pm Erdot/

clean:
	rm output.pdf Erdot/Parser.pm || echo Nothing to clean

show: all
	xpdf output.pdf &

