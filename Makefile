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
	$(DUNE) build test/example.exe
	$(LN) -sf _build/default/test/example.exe .

install:
	$(DUNE) install

clean:
	$(DUNE) clean
	$(RM) -f example.exe example.log
