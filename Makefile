
.PHONY: all clean show

all: output.png

output.png: input erdot Erdot/Parser.pm
	cat input | ./erdot | neato -Tpng -ooutput.png

Erdot/Parser.pm: grammar.pl
	perl -MParse::RecDescent - grammar.pl Erdot::Parser
	mkdir -p Erdot
	mv -f Parser.pm Erdot/

clean:
	rm output.png Erdot/Parser.pm || echo Nothing to clean

show: clean all
	qiv output.png &

