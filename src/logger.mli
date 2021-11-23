val from_channel : Stdlib.out_channel -> unit

val from_file : string -> unit

val finalize : unit -> unit

val log : ('a, Format.formatter, unit, unit) Stdlib.format4 -> 'a
