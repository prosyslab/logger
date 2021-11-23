DUNE=@dune
RM=@rm
CP=@cp

all:
	$(DUNE) build @doc
	$(RM) -rf docs
	$(CP) -rf _build/default/_doc/_html docs

install:
	$(DUNE) install

clean:
	$(DUNE) clean
