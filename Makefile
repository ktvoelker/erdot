
.PHONY: all clean show

all: output.png

output.png: input erdot_pr
	cat input | ./erdot_pr | dot -Tpng -ooutput.png

erdot_pr: Erdot/Parser.pm

Erdot/Parser.pm: grammar.pl
	perl -MParse::RecDescent - grammar.pl Erdot::Parser

clean:
	rm output.png Erdot/Parser.pm

show: clean all
	qiv output.png &

