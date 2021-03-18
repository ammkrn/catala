(** This file has been generated by the Catala compiler, do not edit! *)

open Runtime

[@@@ocaml.warning "-26-27"]

type violation_83_135 =
  | Section286_102 of unit
  | Section286_122 of unit
  | Section286_130 of unit
  | Section286_131 of unit
  | Section286_132 of unit
  | Section286_133 of unit
  | Section286_134 of unit
  | Other_83_135 of unit


type penalty_time_and_days = {
  min_fine: money;
  max_fine: money;
  max_days: duration;
}

type offense = {
  date_of: date;
  violation: violation_83_135;
}

type penalty =
  | TimeAndDays of penalty_time_and_days
  | Fine500OrLoseRightToDriveUntil18 of unit


type defendant = {
  priors: offense array;
  age: integer;
}

type penalty286_83_135_out = {
  offense_out: offense;
  defendant_out: defendant;
  max_fine_out: money;
  min_fine_out: money;
  max_days_out: duration;
  priors_same_offense_out: integer;
  paragraph_b_applies_out: bool;
  paragraph_c_applies_out: bool;
  penalty_out: penalty;
}

type penalty286_83_135_in = {
  offense_in: unit -> offense;
  defendant_in: unit -> defendant;
  max_fine_in: unit -> money;
  min_fine_in: unit -> money;
  max_days_in: unit -> duration;
  priors_same_offense_in: unit -> integer;
  paragraph_b_applies_in: unit -> bool;
  paragraph_c_applies_in: unit -> bool;
  penalty_in: unit -> penalty;
}



let penalty286_83_135 =
  fun (penalty286_83_135_in: penalty286_83_135_in) ->
    let offense_ : unit -> offense = (penalty286_83_135_in.offense_in)
    in
    let defendant_ : unit -> defendant = (penalty286_83_135_in.defendant_in)
    in
    let max_fine_ : unit -> money = (penalty286_83_135_in.max_fine_in)
    in
    let min_fine_ : unit -> money = (penalty286_83_135_in.min_fine_in)
    in
    let max_days_ : unit -> duration = (penalty286_83_135_in.max_days_in)
    in
    let priors_same_offense_ : unit -> integer =
      (penalty286_83_135_in.priors_same_offense_in)
    in
    let paragraph_b_applies_ : unit -> bool =
      (penalty286_83_135_in.paragraph_b_applies_in)
    in
    let paragraph_c_applies_ : unit -> bool =
      (penalty286_83_135_in.paragraph_c_applies_in)
    in
    let penalty_ : unit -> penalty = (penalty286_83_135_in.penalty_in)
    in
    let offense_ : offense =
      ((try
          (handle_default ([|(fun (_: _) -> offense_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError))) with EmptyError ->
          raise NoValueProvided))
    in
    let defendant_ : defendant =
      ((try
          (handle_default ([|(fun (_: _) -> defendant_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default ([||]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError))) with EmptyError ->
          raise NoValueProvided))
    in
    let max_fine_ : money =
      ((try
          (handle_default ([|(fun (_: _) -> max_fine_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) -> money_of_cents_string "100000"))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))
          with EmptyError -> raise NoValueProvided))
    in
    let paragraph_c_applies_ : bool =
      ((try
          (handle_default ([|(fun (_: _) -> paragraph_c_applies_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((defendant_.age) <! (integer_of_string "18")))
                          (fun (_: _) -> true))|]) (fun (_: _) -> true)
                  (fun (_: _) -> false))) with EmptyError ->
          raise NoValueProvided))
    in
    let priors_same_offense_ : integer =
      ((try
          (handle_default ([|(fun (_: _) -> priors_same_offense_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||]) (fun (_: _) -> true)
                          (fun (_: _) ->
                             Array.fold_left
                               (fun (acc_: integer) (prior_: _) ->
                                   if
                                    (((prior_.violation) =
                                        (offense_.violation)) &&
                                       (((prior_.date_of) +@
                                           (duration_of_numbers 5 0 0)) >=@
                                          (offense_.date_of))) then
                                    (acc_ +! (integer_of_string "1")) else
                                    acc_) (integer_of_string "0")
                               (defendant_.priors)))|]) (fun (_: _) -> false)
                  (fun (_: _) -> raise EmptyError))) with EmptyError ->
          raise NoValueProvided))
    in
    let paragraph_b_applies_ : bool =
      ((try
          (handle_default ([|(fun (_: _) -> paragraph_b_applies_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default ([||])
                          (fun (_: _) ->
                             ((not (match (offense_.violation)
                                 with
                                 Section286_102 _ -> false
                                 | Section286_122 _ -> false
                                 | Section286_130 _ -> false
                                 | Section286_131 _ -> false
                                 | Section286_132 _ -> false
                                 | Section286_133 _ -> false
                                 | Section286_134 _ -> false
                                 | Other_83_135 _ -> true)) &&
                                ((priors_same_offense_ >=! (integer_of_string
                                    "2")) && (not paragraph_c_applies_))))
                          (fun (_: _) -> true))|]) (fun (_: _) -> true)
                  (fun (_: _) -> false))) with EmptyError ->
          raise NoValueProvided))
    in
    let max_days_ : duration =
      ((try
          (handle_default ([|(fun (_: _) -> max_days_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default
                          ([|(fun (_: _) ->
                                handle_default
                                  ([|(fun (_: _) ->
                                        handle_default ([||])
                                          (fun (_: _) -> paragraph_b_applies_)
                                          (fun (_: _) ->
                                             duration_of_numbers 1 0 0))|])
                                  (fun (_: _) ->
                                     ((match (offense_.violation)
                                        with
                                        Section286_102 _ -> true
                                        | Section286_122 _ -> false
                                        | Section286_130 _ -> false
                                        | Section286_131 _ -> false
                                        | Section286_132 _ -> false
                                        | Section286_133 _ -> false
                                        | Section286_134 _ -> false
                                        | Other_83_135 _ -> false) ||
                                        ((match (offense_.violation)
                                           with
                                           Section286_102 _ -> false
                                           | Section286_122 _ -> true
                                           | Section286_130 _ -> false
                                           | Section286_131 _ -> false
                                           | Section286_132 _ -> false
                                           | Section286_133 _ -> false
                                           | Section286_134 _ -> false
                                           | Other_83_135 _ -> false) ||
                                           ((match (offense_.violation)
                                              with
                                              Section286_102 _ -> false
                                              | Section286_122 _ -> false
                                              | Section286_130 _ -> true
                                              | Section286_131 _ -> false
                                              | Section286_132 _ -> false
                                              | Section286_133 _ -> false
                                              | Section286_134 _ -> false
                                              | Other_83_135 _ -> false) ||
                                              ((match (offense_.violation)
                                                 with
                                                 Section286_102 _ -> false
                                                 | Section286_122 _ ->
                                                  false
                                                 | Section286_130 _ ->
                                                  false
                                                 | Section286_131 _ ->
                                                  true
                                                 | Section286_132 _ ->
                                                  false
                                                 | Section286_133 _ ->
                                                  false
                                                 | Section286_134 _ ->
                                                  false
                                                 | Other_83_135 _ -> false)
                                                 ||
                                                 ((match (offense_.violation)
                                                    with
                                                    Section286_102 _ ->
                                                     false
                                                    | Section286_122 _ ->
                                                     false
                                                    | Section286_130 _ ->
                                                     false
                                                    | Section286_131 _ ->
                                                     false
                                                    | Section286_132 _ ->
                                                     true
                                                    | Section286_133 _ ->
                                                     false
                                                    | Section286_134 _ ->
                                                     false
                                                    | Other_83_135 _ ->
                                                     false) ||
                                                    ((match
                                                        (offense_.violation)
                                                       with
                                                       Section286_102 _ ->
                                                        false
                                                       | Section286_122 _ ->
                                                        false
                                                       | Section286_130 _ ->
                                                        false
                                                       | Section286_131 _ ->
                                                        false
                                                       | Section286_132 _ ->
                                                        false
                                                       | Section286_133 _ ->
                                                        true
                                                       | Section286_134 _ ->
                                                        false
                                                       | Other_83_135 _ ->
                                                        false) ||
                                                       (match
                                                          (offense_.violation)
                                                       with
                                                       Section286_102 _ ->
                                                        false
                                                       | Section286_122 _ ->
                                                        false
                                                       | Section286_130 _ ->
                                                        false
                                                       | Section286_131 _ ->
                                                        false
                                                       | Section286_132 _ ->
                                                        false
                                                       | Section286_133 _ ->
                                                        false
                                                       | Section286_134 _ ->
                                                        true
                                                       | Other_83_135 _ ->
                                                        false))))))))
                                  (fun (_: _) -> duration_of_numbers 0 0 30))|])
                          (fun (_: _) -> true)
                          (fun (_: _) -> duration_of_numbers 0 0 0))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))
          with EmptyError -> raise NoValueProvided))
    in
    let min_fine_ : money =
      ((try
          (handle_default ([|(fun (_: _) -> min_fine_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default
                          ([|(fun (_: _) ->
                                handle_default ([||])
                                  (fun (_: _) -> paragraph_b_applies_)
                                  (fun (_: _) -> money_of_cents_string
                                     "50000"))|]) (fun (_: _) -> true)
                          (fun (_: _) -> money_of_cents_string "0"))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))
          with EmptyError -> raise NoValueProvided))
    in
    let penalty_ : penalty =
      ((try
          (handle_default ([|(fun (_: _) -> penalty_ ())|])
             (fun (_: _) -> true)
             (fun (_: _) ->
                handle_default
                  ([|(fun (_: _) ->
                        handle_default
                          ([|(fun (_: _) ->
                                handle_default ([||])
                                  (fun (_: _) -> paragraph_c_applies_)
                                  (fun (_: _) ->
                                     Fine500OrLoseRightToDriveUntil18 ()))|])
                          (fun (_: _) -> true)
                          (fun (_: _) ->
                             TimeAndDays
                               {min_fine = min_fine_; max_fine = max_fine_;
                                  max_days = max_days_}))|])
                  (fun (_: _) -> false) (fun (_: _) -> raise EmptyError)))
          with EmptyError -> raise NoValueProvided))
    in
    {offense_out = offense_; defendant_out = defendant_;
       max_fine_out = max_fine_; min_fine_out = min_fine_;
       max_days_out = max_days_;
       priors_same_offense_out = priors_same_offense_;
       paragraph_b_applies_out = paragraph_b_applies_;
       paragraph_c_applies_out = paragraph_c_applies_; penalty_out = penalty_}