all: clean deps
	ocamlbuild -use-ocamlfind src/now.native && mv now.native now

clean:
	$(RM) now
	$(RM) -rf _build/

deps: 
	@opam install calendar

