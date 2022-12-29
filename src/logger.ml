module F = Format
module P = Printf

let log_channel = ref None
let log_formatter = ref None

let from_channel oc =
  log_formatter := F.formatter_of_out_channel oc |> Option.some

let from_file filename =
  let oc = open_out filename in
  log_channel := Some oc;
  log_formatter := F.formatter_of_out_channel oc |> Option.some

let finalize () = match !log_channel with Some oc -> close_out oc | None -> ()

let string_of_current_time () =
  Unix.time () |> Unix.localtime |> fun tm ->
  P.sprintf "%d%02d%02d-%02d:%02d:%02d" (1900 + tm.tm_year) (tm.tm_mon + 1)
    tm.tm_mday tm.tm_hour tm.tm_min tm.tm_sec

let log fmt =
  match !log_formatter with
  | Some log_formatter ->
      F.fprintf log_formatter "[%s][Info] " (string_of_current_time ());
      F.kfprintf
        (fun log_formatter ->
          F.fprintf log_formatter "\n";
          F.pp_print_flush log_formatter ())
        log_formatter fmt
  | None -> failwith "Cannot open logfile"

let info = log

let warn fmt =
  match !log_formatter with
  | Some log_formatter ->
      F.fprintf log_formatter "[%s][Warn] " (string_of_current_time ());
      F.kfprintf
        (fun log_formatter ->
          F.fprintf log_formatter "\n";
          F.pp_print_flush log_formatter ())
        log_formatter fmt
  | None -> failwith "Cannot open logfile"

let error fmt =
  match !log_formatter with
  | Some log_formatter ->
      let backtrace = Printexc.get_raw_backtrace () in
      F.fprintf log_formatter "[%s][Error] " (string_of_current_time ());
      F.kasprintf
        (fun msg ->
          F.fprintf log_formatter "%s@\n%s@." msg
            (Printexc.raw_backtrace_to_string backtrace);
          exit 1)
        fmt
  | None -> failwith "Cannot open logfile"
