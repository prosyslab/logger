val from_channel : out_channel -> unit
val from_file : string -> unit
val finalize : unit -> unit
val log : ('a, Format.formatter, unit, unit) format4 -> 'a
val info : ('a, Format.formatter, unit, unit) format4 -> 'a
val warn : ('a, Format.formatter, unit, unit) format4 -> 'a
val error : ('a, Format.formatter, unit, 'b) format4 -> 'a
