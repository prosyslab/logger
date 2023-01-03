module F = Format
module P = Printf

type formatter = { file : F.formatter; dual : F.formatter }
type level = DEBUG | INFO | WARN | ERROR

let level = ref INFO
let log_channel = ref None
let log_formatter = ref None
let set_level x = level := x

let copy_formatter f =
  let out_string, flush = F.pp_get_formatter_output_functions f () in
  let out_funs = F.pp_get_formatter_out_functions f () in
  let new_f = F.make_formatter out_string flush in
  F.pp_set_formatter_out_functions new_f out_funs;
  new_f

let dual_formatter fmt1 fmt2 =
  let out_fun1 = F.pp_get_formatter_out_functions fmt1 () in
  let out_fun2 = F.pp_get_formatter_out_functions fmt2 () in
  let fmt = copy_formatter fmt1 in
  F.pp_set_formatter_out_functions fmt
    {
      F.out_string =
        (fun s p n ->
          out_fun1.out_string s p n;
          out_fun2.out_string s p n);
      out_indent =
        (fun n ->
          out_fun1.out_indent n;
          out_fun2.out_indent n);
      out_flush =
        (fun () ->
          out_fun1.out_flush ();
          out_fun2.out_flush ());
      out_newline =
        (fun () ->
          out_fun1.out_newline ();
          out_fun2.out_newline ());
      out_spaces =
        (fun n ->
          out_fun1.out_spaces n;
          out_fun2.out_spaces n);
    };
  fmt

let from_channel oc =
  let log_file_fmt = F.formatter_of_out_channel oc in
  let log_dual_fmt = dual_formatter log_file_fmt F.err_formatter in
  log_formatter := Some { file = log_file_fmt; dual = log_dual_fmt }

let from_file filename =
  let oc = open_out filename in
  log_channel := Some oc;
  let log_file_fmt = F.formatter_of_out_channel oc in
  let log_dual_fmt = dual_formatter log_file_fmt F.err_formatter in
  log_formatter := Some { file = log_file_fmt; dual = log_dual_fmt }

let finalize () = match !log_channel with Some oc -> close_out oc | None -> ()

let flush () =
  match !log_formatter with
  | Some logger ->
      F.pp_print_flush logger.file ();
      F.pp_print_flush logger.dual ()
  | _ -> ()

let string_of_current_time () =
  Unix.time () |> Unix.localtime |> fun tm ->
  P.sprintf "%d%02d%02d-%02d:%02d:%02d" (1900 + tm.tm_year) (tm.tm_mon + 1)
    tm.tm_mday tm.tm_hour tm.tm_min tm.tm_sec

let string_of_level = function
  | DEBUG -> "DEBUG"
  | INFO -> "INFO"
  | WARN -> "WARN"
  | ERROR -> "ERROR"

let compare_level set_level level =
  match (set_level, level) with
  | DEBUG, _
  | INFO, INFO
  | INFO, WARN
  | INFO, ERROR
  | WARN, WARN
  | WARN, ERROR
  | ERROR, ERROR ->
      true
  | _, _ -> false

let log to_consol lv =
  match !log_formatter with
  | Some log_formatter when compare_level !level lv ->
      let formatter =
        if to_consol then log_formatter.dual else log_formatter.file
      in
      F.fprintf formatter "[%s][%s] "
        (string_of_current_time ())
        (string_of_level !level);
      F.kfprintf
        (fun log_formatter ->
          F.fprintf log_formatter "\n";
          F.pp_print_flush log_formatter ())
        formatter
  | Some _ -> F.ifprintf F.err_formatter
  | None -> failwith "Cannot open logfile"

let debug ?(to_consol = false) = log to_consol DEBUG
let info ?(to_consol = false) = log to_consol INFO
let warn ?(to_consol = false) = log to_consol WARN

let error ?(to_consol = false) fmt =
  match !log_formatter with
  | Some log_formatter ->
      let formatter =
        if to_consol then log_formatter.dual else log_formatter.file
      in
      let backtrace = Printexc.get_raw_backtrace () in
      F.fprintf formatter "[%s][ERROR] " (string_of_current_time ());
      F.kasprintf
        (fun msg ->
          F.fprintf formatter "%s@\n%s@." msg
            (Printexc.raw_backtrace_to_string backtrace);
          exit 1)
        fmt
  | None -> failwith "Cannot open logfile"
