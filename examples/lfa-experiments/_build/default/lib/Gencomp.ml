open Printf
open LfaSpecs


(* 10 is for large LoC *)
let max_num_basics = 10 
(* da probamo da ostavimo ovo isto *)

let () = Random.self_init ()

let print_to_file file str0 =
  let oc = open_out file in
  Printf.fprintf oc "%s" str0;
  close_out oc

let change_extension file_path extension =
  let split = String.split_on_char '.' file_path in
  List.hd split ^ "." ^ extension

let get_file file_path =
  let split = String.split_on_char '/' file_path in
  let len = List.length split in
  List.nth split (len - 1)


let add_suffix file_path suffix =
  let split = String.split_on_char '.' file_path in
  let fp = List.hd split in
  let fps = fp ^ suffix in
  fps ^ "." ^ List.hd (List.tl split)

let get_name file_path =
  let split = String.split_on_char '.' file_path in
  let fp = List.hd split in
  String.sub fp 0 (String.length fp - 4)

let get_random_list_element l1 =
  let random_int = Random.int (List.length l1) in
  let el = List.nth l1 random_int in
  el

let annons2set lta label =
  let ltas_opt = LtaDefMap.find_opt label lta in
  match ltas_opt with None -> empty_ltas | Some ltas -> ltas

let gen_call_method foo_var lta_method =
  let string_list = String.split_on_char '.' lta_method in
  let s2 = List.nth string_list 1 in
  String.concat "" [ foo_var; "."; s2; ";\n" ]

let gen_foos_lta_branch_multiple ~foo_vars ~lta ~max_number ~init_lta ~pre () =
  let rec add_inv len (str0, { enable = enabled; disable = disabled }) =
    let enabled_pre = LtaSet.union enabled pre in
    let enabled_pre' = LtaSet.diff enabled_pre disabled in
    if len == 0 || LtaSet.is_empty enabled_pre' then
      (str0, { enable = enabled; disable = disabled })
    else
      let enabled_list = set_to_list_s enabled_pre' in
      let method_lta = get_random_list_element enabled_list in
      let str_list =
        List.map (fun x -> gen_call_method x method_lta) foo_vars
      in
      let str' = String.concat "" str_list in
      let str' = str0 ^ str' in
      let ltas = annons2set lta method_lta in
      let enabled' = LtaSet.union enabled ltas.enable in
      let enabled'' = LtaSet.diff enabled' ltas.disable in
      let disabled' = LtaSet.union disabled ltas.disable in
      let disabled'' = LtaSet.diff disabled' ltas.enable in
      add_inv (len - 1) (str', { enable = enabled''; disable = disabled'' })
  in
  let str0 = "" in
  add_inv max_number (str0, init_lta)

let gen_if_lta_random_multiple ~foo_vars ~conds ~lta ~pre_lta ~pre ~max_number
    () =
  let gen_if_lta_rec cond (str0, post_lta) =
    let str1 = "if (" ^ cond ^ ") {\n" in
    let how_many = Random.int max_number + 1 in
    let str2, post_state1 =
      gen_foos_lta_branch_multiple ~foo_vars ~lta ~max_number:how_many
        ~init_lta:pre_lta ~pre ()
    in
    let enable1 = LtaSet.inter post_lta.enable post_state1.enable in
    let disable1 = LtaSet.union post_lta.disable post_state1.disable in
    let enable1 = LtaSet.diff enable1 disable1 in
    let post_lta1 = { enable = enable1; disable = disable1 } in
    let str1 = str1 ^ str2 ^ "} else {\n" in
    let str1 = str1 ^ str0 ^ "\n}\n" in
    (str1, post_lta1)
  in
  let how_many = Random.int max_number + 1 in
  let str1, post_lta =
    gen_foos_lta_branch_multiple ~foo_vars ~lta ~max_number:how_many
      ~init_lta:pre_lta ~pre ()
  in
  let str2, post_lta2 = List.fold_right gen_if_lta_rec conds (str1, post_lta) in
  (str2, post_lta2)

let gen_foos_lta_branch foo_var lta max_number init_lta () =
  let rec add_inv len (str0, { enable = enabled; disable = disabled }) =
    if len == 0 || LtaSet.is_empty enabled then
      (str0, { enable = enabled; disable = disabled })
    else
      let enabled_list = set_to_list_s enabled in
      let method_lta = get_random_list_element enabled_list in
      let str' = str0 ^ gen_call_method foo_var method_lta in
      let ltas = annons2set lta method_lta in
      let enabled' = LtaSet.union enabled ltas.enable in
      let enabled'' = LtaSet.diff enabled' ltas.disable in
      let disabled' = LtaSet.union disabled ltas.disable in
      let disabled'' = LtaSet.diff disabled' ltas.enable in
      add_inv (len - 1) (str', { enable = enabled''; disable = disabled'' })
  in
  let str0 = "" in
  add_inv max_number (str0, init_lta)

let gen_foos_branch_from_file_pre_multiple ~lta ~foo:foo_vars ~pre ~conds
    ~len:(max_number, len) =
  let str0 = "" in
  let pre_lta = { enable = LtaSet.empty; disable = LtaSet.empty } in
  let str1, post_lta =
    gen_foos_lta_branch_multiple ~foo_vars ~lta ~max_number ~init_lta:pre_lta
      ~pre ()
  in
  let rec gen1 len (str1, post_lta) =
    if len == 0 || LtaSet.is_empty post_lta.enable then (str1, post_lta)
    else
      let b = Random.bool () in
      let if_max_number = max_number / List.length conds in
      let str2, post_lta2 =
        if b then
          gen_if_lta_random_multiple ~foo_vars ~conds ~lta ~pre_lta:post_lta
            ~pre ~max_number:if_max_number ()
        else
          gen_foos_lta_branch_multiple ~foo_vars ~lta ~max_number
            ~init_lta:post_lta ~pre ()
      in
      gen1 (len - 1) (str1 ^ "\n" ^ str2, post_lta2)
  in
  let str2, post_lta2 = gen1 len (str1, post_lta) in
  (str2, post_lta2)

let gen_if_lta_random foo_var conds lta pre_lta max_number () =
  let gen_if_lta_rec cond (str0, post_lta) =
    let str1 = "if (" ^ cond ^ ") {\n" in
    let how_many = Random.int max_number + 1 in
    let str2, post_state1 =
      gen_foos_lta_branch foo_var lta how_many pre_lta ()
    in
    let enable1 = LtaSet.inter post_lta.enable post_state1.enable in
    let enable1 = LtaSet.diff enable1 post_state1.disable in
    let disable1 = LtaSet.union post_lta.disable post_state1.disable in
    let post_lta1 = { enable = enable1; disable = disable1 } in
    let str1 = str1 ^ str2 ^ "} else {\n" in
    let str1 = str1 ^ str0 ^ "\n}\n" in
    (str1, post_lta1)
  in
  let how_many = Random.int max_number + 1 in
  let str1, post_lta = gen_foos_lta_branch foo_var lta how_many pre_lta () in
  let str2, post_lta2 = List.fold_right gen_if_lta_rec conds (str1, post_lta) in
  (str2, { enable = post_lta2.enable; disable = LtaSet.empty })

let get_random_list_element l1 =
  let random_int = Random.int (List.length l1) in
  let el = List.nth l1 random_int in
  el

let gen_foos_lta foo_var lta max_number () =
  let init_pn = "void Foo.init()" in
  let enabled_init = annons2set lta init_pn in
  let rec add_inv len (str0, enabled) =
    if len == 0 || LtaSet.is_empty enabled then (str0, enabled)
    else
      let enabled_list = set_to_list_s enabled in
      let method_lta = get_random_list_element enabled_list in
      let str' = str0 ^ gen_call_method foo_var method_lta in
      let ltas = annons2set lta method_lta in
      let enabled' = LtaSet.union enabled ltas.enable in
      let enabled'' = LtaSet.diff enabled' ltas.disable in
      add_inv (len - 1) (str', enabled'')
  in
  let str0 = gen_call_method foo_var init_pn in
  add_inv max_number (str0, enabled_init.enable)

let gen_foos_from_file path foo_var max_numbers =
  let _class_name, lta = get_lta_from_file [ path ] in
  gen_foos_lta foo_var lta max_numbers ()

let gen_foos_branch_from_file3_pre ~in_path:path ~foo:foo_var ~pre ~conds
    ~len:(max_number, len) =
  let _class_name, lta = get_lta_from_file [ path ] in
  let str0 = "" in
  let pre_lta = pre in
  let str1, post_lta = gen_foos_lta_branch foo_var lta max_number pre_lta () in
  let rec gen1 len (str1, post_lta) =
    if len == 0 || LtaSet.is_empty post_lta.enable then (str1, post_lta)
    else
      let b = Random.bool () in
      let str2, post_lta2 =
        if b then gen_if_lta_random foo_var conds lta post_lta max_number ()
        else gen_foos_lta_branch foo_var lta max_number post_lta ()
      in
      gen1 (len - 1) (str1 ^ "\n" ^ str2, post_lta2)
  in
  let str2, post_lta2 = gen1 len (str1, post_lta) in
  (str2, post_lta2)

let gen_fun_signature_comp if_comp fun_id num_foos cond_strs =
  let str = "void useFoo" ^ string_of_int fun_id ^ "(" in
  let str_foos = "" in
  let f1 str x =
    let foo = "Foo foo" ^ string_of_int x ^ ", " in
    str ^ foo
  in
  let foos_nums = 0 -- (num_foos - 1) in
  let foos_strs = List.fold_left f1 str_foos foos_nums in
  let f cond_str str0 =
    let b = "boolean " ^ cond_str ^ ", " in
    str0 ^ b
  in
  let str1 = List.fold_right f cond_strs "" in
  let str1 = String.sub str1 0 (String.length str1 - 2) in
  let str = if if_comp then str else str ^ foos_strs in
  let str = str ^ str1 in
  let str = str ^ ")" in
  str

let gen_fun_signature_comp_base fun_name num_foos cond_strs =
  let str = "void " ^ fun_name in
  let str_foos = "(" in
  let f1 str x =
    let foo = "Foo foo" ^ string_of_int x ^ ", " in
    str ^ foo
  in
  let foos_nums = 0 -- (num_foos - 1) in
  let foos_strs = List.fold_left f1 str_foos foos_nums in
  let f cond_str str0 =
    let b = "boolean " ^ cond_str ^ ", " in
    str0 ^ b
  in
  let str1 = List.fold_right f cond_strs "" in
  let str1 = String.sub str1 0 (String.length str1 - 2) in
  let str = str ^ foos_strs in
  let str = str ^ str1 in
  let str = str ^ ")" in
  str

let gen_fun_call_i_comp if_comp fun_id_i num_foos num_cond () =
  let cond_strs_i = 0 -- num_cond in
  let cond_strs = List.map (fun x -> "a" ^ string_of_int x) cond_strs_i in
  let f cond_str str0 = cond_str ^ ", " ^ str0 in
  let str_foos = "" in
  let f1 str x =
    let foo = "foo" ^ string_of_int x ^ ", " in
    str ^ foo
  in
  let foos_nums = 0 -- (num_foos - 1) in
  let foos_strs = List.fold_left f1 str_foos foos_nums in
  let strcond = List.fold_right f cond_strs "" in
  let strcond = String.sub strcond 0 (String.length strcond - 2) in
  let str =
    if if_comp then
      "useFoo" ^ string_of_int fun_id_i ^ "(" ^ strcond ^ ")" ^ ";\n"
    else
      "useFoo" ^ string_of_int fun_id_i ^ "(" ^ foos_strs ^ strcond ^ ")"
      ^ ";\n"
  in
  str

let init_foos num_foos () =
  let foos_nums = 0 -- (num_foos - 1) in
  let f1 str x =
    let foo = "foo" ^ string_of_int x ^ ".init();" in
    str ^ foo
  in
  let foos_strs = List.fold_left f1 "" foos_nums in
  foos_strs

let rec sublist b e l =
  match l with
  | [] -> failwith "sublist"
  | h :: t ->
      let tail = if e = 0 then [] else sublist (b - 1) (e - 1) t in
      if b > 0 then tail else h :: tail

(* let _gen_fun_and_summary ~sum_map:sum_map ~foo_id:foo_id ~in_path:path ~foo:foo_var
                          ~pre:pre ~conds:conds ~len:(max_number, len) () =
   let (str, post_lta) =
      gen_foos_branch_from_file3_pre ~in_path:path
           ~foo:foo_var ~pre:pre ~conds:conds ~len:(max_number, len) in
      let sum_map' = MapInt.add foo_id (post_lta, pre) sum_map  in
   (str, sum_map') *)

let gen_fun_and_summary_mult ~lta ~foo:foo_vars ~pre ~conds
    ~len:(max_number, len) () =
  let foo_id = 0 in
  let sum_map = MapInt.empty in
  let str, post_lta =
    gen_foos_branch_from_file_pre_multiple ~lta ~foo:foo_vars ~pre ~conds
      ~len:(max_number, len)
  in
  let sum_map' = MapInt.add foo_id (post_lta, pre) sum_map in
  (str, sum_map')

let add_fun_signature_comp if_comp fun_id num_foos conds fun_body =
  let signature = gen_fun_signature_comp if_comp fun_id num_foos conds in
  let body = fun_body in
  let str = signature ^ " {\n" in
  let str = str ^ body in
  let str = str ^ "\n" in
  let str = str ^ "}\n" in
  str

let gen_fun_body_comp_mult ~fun_id ~num_foos ~lta ~pre ~conds
    ~len:(max_number, len) () =
  let foo_nums = 0 -- (num_foos - 1) in
  let str = "" in
  let foo_vars = List.map (fun x -> "foo" ^ string_of_int x) foo_nums in
  let str1, sum_map_fun =
    gen_fun_and_summary_mult ~lta ~foo:foo_vars ~pre ~conds
      ~len:(max_number, len) ()
  in
  (str1, sum_map_fun)

let print_set set =
  let l = set_to_list_s set in
  let () = List.iter (printf "%s, ") l in
  ()

let get_elems_from_list elems list =
  let f el = List.nth list el in
  List.map f elems

let get_random_list_elems len list =
  if List.length list < len then list
  else
    let r_list = random_list len (List.length list - 1) in
    get_elems_from_list r_list list

let gen_foos_lta_mult_comp gen_calls if_comp basic_bias num_foos num_cond 
  foo_vars lta init_lta sum_map_basics (max_number, len) () =
  (* let num_trials =  *)
  let count = ref 0 in
  let num_basics = MapInt.cardinal sum_map_basics in
  (* if num_basics > 3 then  *)
  let rec add_inv len1 (str0, { enable = enabled; disable = disabled }) =
    if len1 == 0 || LtaSet.is_empty enabled then
      (str0, { enable = enabled; disable = disabled })
    else
      let random_basic = Random.int 100 in
      (* if random_basic < basic_bias then *)
      (* if true then  *)
        (* f generates call to basic function *)
        (* let num_basics = MapInt.cardinal sum_map_basics in *)
        if num_basics > max_num_basics then 
        let f fun_id (str, { enable = enabled; disable = disabled }) =
          if (!count >= max_number) then 
            (str, { enable = enabled; disable = disabled })
        else 
          let sum_map_fun = MapInt.find fun_id sum_map_basics in
          let ltas, pre = MapInt.find 0 sum_map_fun in
          if LtaSet.subset pre enabled then
            let () = count := !count + 1 in
            let str_call =
              gen_fun_call_i_comp if_comp fun_id num_foos num_cond ()
            in
            let str' = str ^ str_call in
            (* join function summary to current state *)
            let enabled' = LtaSet.union enabled ltas.enable in
            let enabled'' = LtaSet.diff enabled' ltas.disable in
            let disabled' = LtaSet.union disabled ltas.disable in
            let disabled'' = LtaSet.diff disabled' ltas.enable in
            (str', { enable = enabled''; disable = disabled'' })
          else (str, { enable = enabled; disable = disabled })
        in
        (* let num_basics = MapInt.cardinal sum_map_basics in *)
        (* let random_basics_ids = random_list num_basics num_basics in *)
        (* let random_basics_ids = 
          if num_basics == 0 then 
            [] 
        else 
          random_list max_number num_basics in  *)
        (* let random_basics_ids = random_list max_number num_basics in  *)
        let random_basics_ids = random_list num_basics num_basics in 
        let str1, ltas1 =
          List.fold_right f random_basics_ids
            (str0, { enable = enabled; disable = disabled })
        in
        if String.equal str0 str1 then 
          (* stop here *)
          (* (str1, ltas1) *)
          let gen_calls1 = !count == 0 && gen_calls in 
          (* if (!count > 0 && Bool.not gen_calls) then  *)
          if (Bool.not gen_calls1) then 
            (str1, ltas1) 
        else 
            let enabled_list = set_to_list_s enabled in
            let method_lta = get_random_list_element enabled_list in
            let str_list =
              List.map (fun x -> gen_call_method x method_lta) foo_vars
            in
            let str' = String.concat "" str_list in
            let str' = str0 ^ str' in
            let ltas = annons2set lta method_lta in
            let enabled' = LtaSet.union enabled ltas.enable in
            let enabled'' = LtaSet.diff enabled' ltas.disable in
            let disabled' = LtaSet.union disabled ltas.disable in
            let disabled'' = LtaSet.diff disabled' ltas.enable in
              (str',  { enable = enabled''; disable = disabled'' })
            (* add_inv (len1 - 1) (str', { enable = enabled''; disable = disabled'' }) *)
          (* add_inv len (str1, ltas1) *)
        else add_inv (len1 - 1) (str1, ltas1)
      else
        let enabled_list = set_to_list_s enabled in
        let method_lta = get_random_list_element enabled_list in
        let str_list =
          List.map (fun x -> gen_call_method x method_lta) foo_vars
        in
        let str' = String.concat "" str_list in
        let str' = str0 ^ str' in
        let ltas = annons2set lta method_lta in
        let enabled' = LtaSet.union enabled ltas.enable in
        let enabled'' = LtaSet.diff enabled' ltas.disable in
        let disabled' = LtaSet.union disabled ltas.disable in
        let disabled'' = LtaSet.diff disabled' ltas.enable in
        add_inv (len1 - 1) (str', { enable = enabled''; disable = disabled'' })
  in
  let str0 = "" in
  let max_number1 = 
    if num_basics > max_num_basics then
      max_number 
    else 
      3 in  
  let str_out, post_lta_out = add_inv max_number1 (str0, init_lta) in
  (str_out, post_lta_out, !count)



let gen_foos_lta_mult_comp2 if_comp basic_bias num_foos num_cond foo_vars lta
  init_lta sum_map_basics (max_number, len) () =
let count = ref 0 in
let rec add_inv len (str0, { enable = enabled; disable = disabled }) =
  if len == 0 || LtaSet.is_empty enabled then
    (str0, { enable = enabled; disable = disabled })
  else
    (* let random_basic = Random.int 100 in
       if (random_basic < basic_bias) then
         let f fun_id sum_map_fun (str, {enable=enabled; disable=disabled})=
           let (ltas, pre) =
             MapInt.find 0 sum_map_fun in
             if (LtaSet.subset pre enabled)  then
               let () = count := !count + 1 in
               let str_call = gen_fun_call_i_comp if_comp fun_id num_foos num_cond () in
               let str' = str^str_call in
               let enabled' = LtaSet.union enabled ltas.enable in
               let enabled'' = LtaSet.diff enabled' ltas.disable in
               let disabled' = LtaSet.union disabled ltas.disable in
               let disabled'' = LtaSet.diff disabled' ltas.enable in
               (str', {enable=enabled'';disable=disabled''})
             else (str, {enable=enabled;disable=disabled}) in
         let (str1, ltas1) =
           MapInt.fold f sum_map_basics  (str0, {enable=enabled; disable=disabled}) in
           if (String.equal str0 str1) then
             add_inv (len) (str1, ltas1) else
               add_inv (len-1) (str1, ltas1)
         else *)
    (* RANDOM BELOW *)
    let random_basic = Random.int 100 in
    if random_basic < basic_bias then
      (* f generates call to basic function *)
      let f fun_id (str, { enable = enabled; disable = disabled }) =
        let sum_map_fun = MapInt.find fun_id sum_map_basics in
        let ltas, pre = MapInt.find 0 sum_map_fun in
        if LtaSet.subset pre enabled then
          let () = count := !count + 1 in
          let str_call =
            gen_fun_call_i_comp if_comp fun_id num_foos num_cond ()
          in
          let str' = str ^ str_call in
          (* join function summary to current state *)
          let enabled' = LtaSet.union enabled ltas.enable in
          let enabled'' = LtaSet.diff enabled' ltas.disable in
          let disabled' = LtaSet.union disabled ltas.disable in
          let disabled'' = LtaSet.diff disabled' ltas.enable in
          (str', { enable = enabled''; disable = disabled'' })
        else (str, { enable = enabled; disable = disabled })
      in
      let num_basics = MapInt.cardinal sum_map_basics in
      let random_basics_ids = random_list num_basics num_basics in
      let str1, ltas1 =
        List.fold_right f random_basics_ids
          (str0, { enable = enabled; disable = disabled })
      in
      if String.equal str0 str1 then add_inv len (str1, ltas1)
      else add_inv (len - 1) (str1, ltas1)
    else
      let enabled_list = set_to_list_s enabled in
      let method_lta = get_random_list_element enabled_list in
      let str_list =
        List.map (fun x -> gen_call_method x method_lta) foo_vars
      in
      let str' = String.concat "" str_list in
      let str' = str0 ^ str' in
      let ltas = annons2set lta method_lta in
      let enabled' = LtaSet.union enabled ltas.enable in
      let enabled'' = LtaSet.diff enabled' ltas.disable in
      let disabled' = LtaSet.union disabled ltas.disable in
      let disabled'' = LtaSet.diff disabled' ltas.enable in
      add_inv (len - 1) (str', { enable = enabled''; disable = disabled'' })
in
let str0 = "" in
let str_out, post_lta_out = add_inv max_number (str0, init_lta) in
(str_out, post_lta_out, !count)

let gen_if_lta_random_mult_comp gen_calls if_comp basic_bias sum_map_basics foo_vars conds
    lta pre_lta (max_number, len) () =
  let num_foos = List.length foo_vars in
  let num_conds = List.length conds - 1 in
  let count = ref 0 in
  let gen_if_lta_rec cond (str0, post_lta) =
    let str1 = "if (" ^ cond ^ ") {\n" in
    let how_many = Random.int max_number + 1 in
    let gen_calls1 = gen_calls && (!count == 0) in 
    let str2, post_state1, count_in =
      gen_foos_lta_mult_comp gen_calls1 if_comp basic_bias num_foos num_conds foo_vars lta
        pre_lta sum_map_basics (max_number, len) ()
    in
    let () = count := !count + count_in in
    let enable1 = LtaSet.inter post_lta.enable post_state1.enable in
    let disable1 = LtaSet.union post_lta.disable post_state1.disable in
    let enable1 = LtaSet.diff enable1 disable1 in
    let post_lta1 = { enable = enable1; disable = disable1 } in
    let str1 = str1 ^ str2 ^ "} else {\n" in
    let str1 = str1 ^ str0 ^ "\n}\n" in
    (str1, post_lta1)
  in
  let how_many = Random.int max_number + 1 in
  let str1, post_lta, count_in =
    gen_foos_lta_mult_comp gen_calls if_comp basic_bias num_foos num_conds foo_vars lta
      pre_lta sum_map_basics (max_number, len) ()
  in
  let () = count := !count + count_in in
  let str2, post_lta2 = List.fold_right gen_if_lta_rec conds (str1, post_lta) in
  (* (str2, {enable=post_lta2.enable;disable=LtaSet.empty}, !count) *)
  (str2, { enable = post_lta2.enable; disable = post_lta2.disable }, !count)


  let gen_for_lta_mult_comp gen_calls if_comp basic_bias num_foos num_cond foo_vars 
    lta post_lta sum_map_basics (max_number, len) () =
  (* let num_trials =  *)
    let str2, post_lta2, count_in = 
      gen_foos_lta_mult_comp gen_calls if_comp basic_bias num_foos num_cond
        foo_vars lta post_lta sum_map_basics (max_number, len) () in 
    (* wrap in while construct *)
    (* there must be at least one cond *)
    let wrap str = 
      let str1 = "while (a0) {\n" in 
      let str2 = str1 ^ str in 
       str2 ^ "\n}\n" in 
    (wrap str2, post_lta2, count_in)


let gen_body_lta_mult_comp if_comp basic_bias if_bias sum_map_basics num_foos
    lta num_conds conds foo_vars pre_lta (max_number, len) () =
  let str0 = "" in
  let str1, post_lta = (str0, pre_lta) in
  let count = ref 0 in
  (* debug begin *)
  (* let () = Printf.printf "gen_body_lta_mult_comp: max_number is: %i; len is: %i\n"
    max_number len in  *)
  (* debug end *)
  let num_basics = MapInt.cardinal sum_map_basics in 
  let len = if (num_basics > max_num_basics) then 
    len 
else 
  1 in 
  let rec gen1 len (str1, post_lta) =
    if len == 0 || LtaSet.is_empty post_lta.enable then (str1, post_lta)
    else
      let if_random = Random.int 100 in
      let gen_calls = (!count == 0) in 
      let str2, post_lta2, count_in =
        if if_random < if_bias then
          let while_random = Random.int 100 in 
          if (while_random < 50) then 
            (* if (true) then  *)
            (* GENERATE IF *)
            let max_number_if = 
              if (max_number == 1) then 
                1 
              else 
                max_number / (List.length conds + 1) in 
            (* let max_number_if = max_number / (List.length conds + 1) in *)
            gen_if_lta_random_mult_comp gen_calls if_comp basic_bias 
              sum_map_basics 
              foo_vars conds lta post_lta (max_number_if, len) ()
            (* GENERATE WHILE *)
          else 
            gen_for_lta_mult_comp gen_calls if_comp basic_bias num_foos 
              num_conds 
              foo_vars lta post_lta sum_map_basics (max_number, len) ()
        else
          gen_foos_lta_mult_comp gen_calls if_comp basic_bias num_foos 
            num_conds 
            foo_vars lta post_lta sum_map_basics (max_number, len) ()
      in
      let () = count := !count + count_in in
      (* FIX begin *)
      if (count_in == 0) then 
        (* stop here *)
        (str1 ^ str2, post_lta2)
      else 
      (* FIX end *)
      (* gen1 (len - 1) (str1 ^ "\n" ^ str2, post_lta2) *)
      gen1 (len - 1) (str1 ^ str2, post_lta2)
  in
  let str2, post_lta2 = gen1 len (str1, pre_lta) in
  (str2, post_lta2, !count)




  
let gen_fun_comp ~fun2_id ~if_comp ~if_bias ~num_foos ~init_lta ~basic_bias
    ~sum_map_basics ~foo_vars ~num_conds ~conds ~lta ~len:(max_number, len) () =
  let str_fun_body, post_lta, count =
    gen_body_lta_mult_comp if_comp basic_bias if_bias sum_map_basics num_foos
      lta num_conds conds foo_vars init_lta (max_number, len) ()
  in
  let str_fun1 =
    add_fun_signature_comp if_comp fun2_id num_foos conds str_fun_body
  in
  let foo_id = 0 in
  let sum_map = MapInt.empty in
  (* CHECK THIS PRE *)
  let pre = init_lta.enable in
  let sum_map' = MapInt.add foo_id (post_lta, pre) sum_map in
  (str_fun1, sum_map', count)

let java_preamb_i_comp num_foos =
  let str =
    "class Foo {\n\
    \      public static Foo getFoo() {\n\
    \          return new Foo();\n\
    \      }\n\
    \  \n\
    \      void init() {}\n"
  in
  let is = 0 -- num_foos in
  let f id str0 =
    let str1 = "void foo" ^ string_of_int id ^ "() {}\n" in
    str1 ^ str0
  in
  let foos = List.fold_right f is "" in
  let str = str ^ foos in
  let str = str ^ "}" ^ "\n" in
  str

let gen_foo_members num_foos =
  let is = 0 -- (num_foos-1) in
  let f id str0 =
    let str1 = "Foo foo" ^ string_of_int id ^ ";" ^ "\n" in
    str1 ^ str0
  in
  let foos = List.fold_right f is "" in
  foos

let java_context_comp if_comp  num_foos num_methods lines =
  let header = java_preamb_i_comp num_methods in
  let test = "class Test{\n" in
  let test = if if_comp then test ^ gen_foo_members num_foos ^ "\n" else test in
  let str = header ^ test ^ lines in
  let str = str ^ "\n}\n" in
  str

let gen_init_fun ~conds:cond_strs ~foo_vars () =
  let num_foos = List.length foo_vars in
  let num_conds = List.length cond_strs in
  let fun_name = "init" in
  (* let num_foos = 0 in  *)
  let signature = gen_fun_signature_comp_base fun_name 0 cond_strs in
  let f1 str foo_var =
    let str_foo = foo_var ^ " = new Foo();\n" in
    let str_foo = str_foo ^ foo_var ^ ".init();\n" in
    str ^ str_foo
  in
  let body = List.fold_left f1 "" foo_vars in
  let signature = signature ^ "{" in
  let str = signature ^ "\n" ^ body in
  let str = str ^ "}" ^ "\n" in
  str

let gen_test_fun ~comp:if_comp ~conds:cond_strs ~foo_vars ~fun_id () =
  let num_foos = List.length foo_vars in
  let num_conds = List.length cond_strs in
  let fun_name = "test" in
  (* let num_foos = 0 in  *)
  let signature = gen_fun_signature_comp_base fun_name 0 cond_strs in
  let f1 str foo_var =
    let str_foo = "Foo" ^ " " ^ foo_var ^ " = new Foo();\n" in
    let str_foo = str_foo ^ foo_var ^ ".init();\n" in
    str ^ str_foo
  in
  let body = List.fold_left f1 "" foo_vars in
  let signature = signature ^ "{" in
  let str = signature ^ "\n" ^ body in
  let str_call =
    gen_fun_call_i_comp if_comp fun_id num_foos (num_conds - 1) ()
  in
  let str = str ^ "\n" in
  let str = str ^ str_call in
  let str = str ^ "\n}" in
  str

let gen_java_nested_comp2 ~comp:if_comp ~num_methods ~basic_bias ~in_path:path
    ~num_basic_fun ~num_fun ~num_conds ~num_foos ~num_lines ~num_body_ifs
    ~num_repeats ~funs_in_if ~if_branch ~if_bias
    ~len_basics:(max_basics, len_basics) ~len:(max_number, len) () =
  let _class_name, lta = get_lta_from_file [ path ] in
  let foo_var = "foo" in
  let sum_map = MapInt.empty in
  let init_pn = "void Foo.init()" in
  let basic_nums = 0 -- (num_basic_fun - 1) in
  let enabled_set = annons2set lta init_pn in
  let enabled_init_list = set_to_list_s enabled_set.enable in
  (* TODO: try with more enabled, max possible *)
  (* actually it should be fewer so that we can call
     more functions *)
  (* let how_many_enabled = 3 in *)
  let how_many_enabled = 2 in 
  let cond_strs_i = 0 -- num_conds in
  let conds = List.map (fun x -> "a" ^ string_of_int x) cond_strs_i in
  let sum_map = MapInt.empty in
  let fold_basic (str, sum_map) fun_id =
    let pre_list = get_random_list_elems how_many_enabled enabled_init_list in
    let pre = LtaSet.of_list pre_list in
    let fun_body, sum_map_per_fun =
      gen_fun_body_comp_mult ~fun_id ~num_foos ~lta ~pre ~conds
        ~len:(max_basics, len_basics) ()
    in
    let str1 = add_fun_signature_comp if_comp fun_id num_foos conds fun_body in
    let sum_map' = MapInt.add fun_id sum_map_per_fun sum_map in
    (str ^ "\n" ^ str1, sum_map')
  in
  let str, sum_map_basics =
    List.fold_left fold_basic ("", sum_map) basic_nums
  in
  let foo_nums = 0 -- (num_foos - 1) in
  let foo_vars = List.map (fun x -> "foo" ^ string_of_int x) foo_nums in
  let init_lta = annons2set lta init_pn in
  let str_fun_body, sum_map', count =
    gen_body_lta_mult_comp if_comp basic_bias if_bias sum_map_basics num_foos
      lta num_conds conds foo_vars init_lta (max_number, len) ()
  in
  let fun2_id = num_basic_fun in
  let str_fun1 =
    add_fun_signature_comp if_comp fun2_id num_foos conds str_fun_body
  in
  let str'' = str ^ "\n" ^ str_fun1 in
  let str'' =
    str'' ^ "\n"
    ^ gen_test_fun ~comp:if_comp ~conds ~foo_vars ~fun_id:fun2_id ()
  in
  let str'' = str'' ^ "\n" in
  let str'' =
    if if_comp then gen_init_fun ~conds ~foo_vars () ^ str'' else str''
  in
  let str = java_context_comp if_comp num_methods num_methods str'' in
  let ss = String.split_on_char '\n' str in
  let num_lines = List.length ss in
  let out_path = change_extension (get_file path) "java" in
  let suffix = "-foos-" ^ string_of_int num_foos in
  let suffix = suffix ^ "-num-" ^ string_of_int num_lines in
  let suffix = suffix ^ "-count-" ^ string_of_int count in
  let out_path = add_suffix out_path suffix in
  (num_lines, count, str, out_path)

let gen_java_nested_comp ~comp:if_comp ~num_methods ~basic_bias ~in_path:path
    ~num_basic_fun ~num_fun ~num_conds ~num_foos ~num_lines ~num_body_ifs
    ~num_repeats ~funs_in_if ~if_branch ~if_bias
    ~len_basics:(max_basics, len_basics) ~len:(max_number, len) () =
  let _class_name, lta = get_lta_from_file [ path ] in
  let foo_var = "foo" in
  let sum_map = MapInt.empty in
  let init_pn = "void Foo.init()" in
  let num_basic_fun1 = 1 in
  (* let basic_nums = 0--(num_basic_fun - 1) in  *)
  let basic_nums = 0 -- num_basic_fun in
  let basic_nums1 = 0 -- (num_basic_fun1 - 1) in
  let enabled_set = annons2set lta init_pn in
  let enabled_init_list = set_to_list_s enabled_set.enable in
  (* TODO: try with more enabled, max possible *)
  (* actually it should be fewer so that we can call
     more functions *)
  let how_many_enabled = 1 in
  (* let how_many_enabled = 3 in  *)
  let cond_strs_i = 0 -- num_conds in
  let conds = List.map (fun x -> "a" ^ string_of_int x) cond_strs_i in
  let sum_map = MapInt.empty in
  (* FOLD BASIC *)
  let fold_basic (str, sum_map) fun_id =
    let pre_list = get_random_list_elems how_many_enabled enabled_init_list in
    let pre = LtaSet.of_list pre_list in
    let fun_body, sum_map_per_fun =
      gen_fun_body_comp_mult ~fun_id ~num_foos ~lta ~pre ~conds
        ~len:(max_basics, len_basics) ()
    in
    let str1 = add_fun_signature_comp if_comp fun_id num_foos conds fun_body in
    let sum_map' = MapInt.add fun_id sum_map_per_fun sum_map in
    (str ^ "\n" ^ str1, sum_map')
  in
  (* BASIC_NUMS SHOULD BE JUST ONE *)
  let str, sum_map_basics =
    List.fold_left fold_basic ("", sum_map) basic_nums1
  in
  let foo_nums = 0 -- (num_foos - 1) in
  let foo_vars = List.map (fun x -> "foo" ^ string_of_int x) foo_nums in
  (* let init_lta = annons2set lta init_pn in  *)
  (* let (str_fun_body, sum_map', count) =
       gen_body_lta_mult_comp if_comp basic_bias if_bias sum_map_basics num_foos
         lta num_conds conds foo_vars init_lta (max_number, len) () in
     let fun2_id = num_basic_fun in
     let str_fun1 = add_fun_signature_comp if_comp fun2_id num_foos conds str_fun_body in *)
  (* m *)
  let _how_many_comp_fun = num_basic_fun in
  let fold_non_basic (str, sum_map, count) fun_id =
    (* how_many enabled should be random here *)
    let pre_list = get_random_list_elems how_many_enabled enabled_init_list in
    let pre = LtaSet.of_list pre_list in
    let init_lta = { enable = pre; disable = LtaSet.empty } in
    let fun_str, sum_map_per_fun, count1 =
      gen_fun_comp ~fun2_id:fun_id ~if_comp ~if_bias ~num_foos ~init_lta
        ~basic_bias ~sum_map_basics:sum_map ~foo_vars ~num_conds ~conds ~lta
        ~len:(max_number, len) ()
    in
    let sum_map' = MapInt.add fun_id sum_map_per_fun sum_map in
    (str ^ "\n" ^ fun_str, sum_map', count + count1)
  in
  let str'', sum_map_basics, count =
    List.fold_left fold_non_basic ("", sum_map, 0) basic_nums
  in
  let fun2_id = num_basic_fun in
  let str'' =
    str'' ^ "\n"
    ^ gen_test_fun ~comp:if_comp ~conds ~foo_vars ~fun_id:fun2_id ()
  in
  let str'' = str'' ^ "\n" in
  let str'' =
    if if_comp then gen_init_fun ~conds ~foo_vars () ^ str'' else str''
  in
  let str = java_context_comp if_comp num_foos num_methods str'' in
  let ss = String.split_on_char '\n' str in
  let ss_noblank = List.filter (fun x -> (String.length x) != 0) ss in 
  (* let num_lines = List.length ss in *)
  let num_lines = List.length ss_noblank in
  let out_path = change_extension (get_file path) "java" in
  let suffix = "-foos-" ^ string_of_int num_foos in
  let suffix = suffix ^ "-num-" ^ string_of_int num_lines in
  let suffix = suffix ^ "-count-" ^ string_of_int count in
  let out_path = add_suffix out_path suffix in
  (num_lines, count, str, out_path)

(*
   (* generate flat *)
   let gen_foos_branch_from_file_topl ~in_path:path  ~foo:foo_var ~conds:conds
   ~if_bias:if_bias
   ~len:(max_number, len) =
   let (_class_name, lta) = get_lta_from_file [path] in
   let init_call = foo_var^".init()" in
   let init_pn = "void Foo.init()" in
   let str0 = init_call^";\n" in
   let pre_lta = annons2set lta init_pn in
   let (str1, post_lta) = gen_foos_lta_branch foo_var lta max_number pre_lta () in
   let rec gen1 len (str1, post_lta) =
               (* random bool *)
     if (len == 0 || LtaSet.is_empty post_lta.enable) then
       (str1, post_lta)
   else
     (* let b = Random.bool () in  *)
     let random_int = Random.int 100 in
     let b = (random_int < if_bias) in
     let (str2, post_lta2) = if (b) then
       (* gen_if_lta_random foo_var conds lta post_lta 2 ()   *)
       gen_if_lta_random foo_var conds lta post_lta max_number ()
     else
       gen_foos_lta_branch foo_var lta max_number post_lta () in
     gen1 (len - 1) (str1^"\n"^str2, post_lta2) in
   let (str2, post_lta2) = gen1 len (str1, post_lta) in
   (* let out_path = change_extension (get_file path) "java" in
   let suffix = "-"^"topl"^"-"^(string_of_int max_number) in
   let out_path = add_suffix out_path suffix in *)
   let str = java_context 40 str2 in
   (* let str = java_context_comp 40 str'' in  *)
   let ss = String.split_on_char '\n' str in
   let num_lines = List.length ss in
   let out_path = change_extension (get_file path) "java" in
   let suffix="" in
   (* let suffix = "-foos-"^(string_of_int num_foos) in  *)
   let suffix = suffix^"-num-"^(string_of_int num_lines) in
   (* let suffix = suffix^"-count-"^(string_of_int count) in  *)
   let out_path = add_suffix out_path suffix in
   let out_path' = "flat-"^out_path in
   (num_lines, 0, str, out_path') *)
