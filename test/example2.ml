module L = Logger

let f3 x =
  if x = 1 then L.error "f3: %d" x else L.info "f3: %d" x;
  x

let f2 x =
  L.info "f2: %d" x;
  f3 x + 1

let f1 x =
  L.info "f1: %d" x;
  f2 x + 1

let main () =
  L.from_file "example.log";
  L.set_level L.INFO;
  L.info "Hello, %s!" "World";
  let x = f1 1 in
  L.info "Result: %d" x

let _ = main ()
