module L = Logger

let main () =
  L.from_file "example.log";
  L.set_level L.INFO;
  L.info "Hello, %s!" "World";
  L.info ~to_consol:true "Hello, %s!" "World"

let _ = main ()
