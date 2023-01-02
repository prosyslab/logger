type level = DEBUG | INFO | WARN | ERROR

val from_channel : out_channel -> unit
val from_file : string -> unit
val set_level : level -> unit
val flush : unit -> unit
val finalize : unit -> unit
val info : ?to_consol:bool -> ('a, Format.formatter, unit, unit) format4 -> 'a
val warn : ?to_consol:bool -> ('a, Format.formatter, unit, unit) format4 -> 'a
val error : ?to_consol:bool -> ('a, Format.formatter, unit, 'b) format4 -> 'a
