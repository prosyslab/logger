type level = DEBUG | INFO | WARN | ERROR

val from_channel : out_channel -> unit
val from_file : string -> unit
val set_level : level -> unit
val flush : unit -> unit
val finalize : unit -> unit

val debug :
  ?to_console:bool ->
  ?new_line:bool ->
  ('a, Format.formatter, unit, unit) format4 ->
  'a

val info :
  ?to_console:bool ->
  ?new_line:bool ->
  ('a, Format.formatter, unit, unit) format4 ->
  'a

val warn :
  ?to_console:bool ->
  ?new_line:bool ->
  ('a, Format.formatter, unit, unit) format4 ->
  'a

val error : ?to_console:bool -> ('a, Format.formatter, unit, 'b) format4 -> 'a
