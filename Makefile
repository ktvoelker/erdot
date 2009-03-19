
.PHONY: all clean show

all: output.png

output.png: input erdot
	cat input | ./erdot | dot -Tpng -ooutput.png

clean:
	rm output.png

show: clean all
	qiv output.png &

