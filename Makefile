
.PHONY: all clean

all: output.png

output.png: input erdot
	cat input | ./erdot | neato -Tpng -ooutput.png

clean:
	rm output.png

