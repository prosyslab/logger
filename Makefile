DUNE=@dune
RM=@rm
CP=@cp
LN=@ln

all:
	$(DUNE) build @doc
	$(RM) -rf docs
	$(CP) -rf _build/default/_doc/_html docs
	@make test

.PHONY: test
test:
	$(DUNE) build test/example1.exe
	$(LN) -sf _build/default/test/example1.exe .
	$(DUNE) build test/example2.exe
	$(LN) -sf _build/default/test/example2.exe .

install:
	$(DUNE) install

clean:
	$(DUNE) clean
	$(RM) -f example.exe example.log
