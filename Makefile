PARAMSETS != cat params.json | jq -r '.parameterSets | keys[] | select(length > 0)'
OUTPUTS = $(PARAMSETS:%=%.3mf)

all: $(OUTPUTS)

clean:
	rm -f $(OUTPUTS) *.bare.3mf *.log

targets:
	@for i in $(PARAMSETS); do echo $$i.3mf; done

%.bare.3mf %.log: temp-tower.scad params.json
	openscad -o $*.bare.3mf -P $* -p params.json temp-tower.scad 2>$*.log

%.3mf: %.bare.3mf %.log postprocess.sh
	./postprocess.sh $@ $*.bare.3mf $*.log
