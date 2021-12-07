open System

let nums =
  Seq.initInfinite (fun _ -> Console.ReadLine())
  |> Seq.takeWhile(fun line -> line <> null)
  |> Seq.map (fun s -> s.ToCharArray() |> Seq.map (fun c -> (int c) - (int '0')) |> Seq.toList)
  |> Seq.toList
let count = double (List.length nums)
let averages = nums |> List.transpose |> List.map (fun l -> (double (List.sum l)) / count)
let gamma = averages |> List.rev |> List.mapi (fun i x -> (int (x + 0.5)) * (1 <<< i)) |> List.sum
let epsilon = ((1 <<< (List.length averages)) - 1) ^^^ gamma
printfn "part 1: %A" (gamma * epsilon)

let filter c ns i =
  let xs = (List.transpose ns)[i]
  let avg = (double (List.sum xs)) / (double (List.length xs))
  let b = (int (avg + 0.5)) ^^^ c ^^^ 1
  ns |> List.filter (fun l -> l[i] = b)

let rec rating filter ns i =
  match filter ns i with
  | [r] -> r
  | l -> rating filter l (i + 1)

let o2rating = rating (filter 1) nums 0 |> List.rev |> List.mapi (fun i x -> x <<< i) |> List.sum
let co2rating = rating (filter 0) nums 0 |> List.rev |> List.mapi (fun i x -> x <<< i) |> List.sum

printfn "part 2: %A" (o2rating * co2rating)
