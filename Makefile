
.PHONY: all clean show

all: output.png

output.png: input erdot
	cat input | ./erdot | dot -Tpng -ooutput.png

erdot: Erdot/Parser.pm

Erdot/Parser.pm: grammar.pl
	perl -MParse::RecDescent - grammar.pl Erdot::Parser
	mv -f Parser.pm Erdot/

clean:
	rm output.png Erdot/Parser.pm || echo Nothing to clean

show: clean all
	qiv output.png &

