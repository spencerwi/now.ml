let add_units (datetime: CalendarLib.Calendar.t) (n: int) (units: CalendarLib.Calendar.field) : CalendarLib.Calendar.t =
    let period_constructor = 
        match units with 
        | `Year -> CalendarLib.Calendar.Period.year
        | `Month -> CalendarLib.Calendar.Period.month
        | `Week -> CalendarLib.Calendar.Period.week
        | `Day -> CalendarLib.Calendar.Period.day
        | `Hour -> CalendarLib.Calendar.Period.hour
        | `Minute -> CalendarLib.Calendar.Period.minute
        | `Second -> CalendarLib.Calendar.Period.second
    in
    let period = period_constructor n in
    CalendarLib.Calendar.add datetime period

let parse_units = function
    | "years"   | "year"   -> `Year
    | "months"  | "month"  -> `Month
    | "days"    | "day"    -> `Day
    | "hours"   | "hour"    -> `Hour
    | "minutes" | "minute" -> `Minute
    | "seconds" | "second" -> `Second
    | anything_else -> failwith (Printf.sprintf "Unrecognized unit: \"%s\"" anything_else)

let get_target_datetime = function 
    | `Plus  (n, units) -> add_units (CalendarLib.Calendar.now()) n units 
    | `Minus (n, units) -> add_units (CalendarLib.Calendar.now()) (n * -1) units

let () =
    CalendarLib.Time_Zone.change CalendarLib.Time_Zone.Local;
    match Array.length Sys.argv with
    | 4 -> 
        let n = int_of_string Sys.argv.(2) in
        let units = parse_units Sys.argv.(3) in
        let time_shift = 
            match Sys.argv.(1) with
            | "plus"  -> `Plus (n, units)
            | "minus" -> `Minus (n, units)
            | _ -> failwith "Only plus or minus are supported"
        in
        get_target_datetime time_shift
        |> CalendarLib.Printer.Calendar.sprint "%Y-%m-%dT%H:%M:%S"
        |> print_endline
    | 1 -> 
        CalendarLib.Calendar.now()
        |> CalendarLib.Printer.Calendar.sprint "%Y-%m-%dT%H:%M:%S"
        |> print_endline
    | _ -> 
        print_endline "USAGE: now (plus|minus) n (years|months|days|hours|minutes|seconds)"
        

