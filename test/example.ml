module L = Logger

let main () =
  L.from_file "example.log";
  L.set_level L.INFO;
  L.info "Hello, %s!" "World";
  L.info ~to_console:true "Hello, %s!" "World";
  L.info ~to_console:true ~new_line:false "1\r";
  L.info ~to_console:true ~new_line:false "2\n"

let _ = main ()
