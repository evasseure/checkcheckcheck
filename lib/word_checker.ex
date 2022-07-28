defmodule WordChecker do
  @letters String.split("abcdefghijklmnopqrstuvwxyz", "")

  def splits(word) do
    for i <- 0..String.length(word), do: [String.slice(word, 0, i), String.slice(word, i..-1)]
  end

  def deletes(splits) do
    for [head, tail] <- splits, String.length(tail) > 0, do: head <> String.slice(tail, 1..-1)
  end

  def transposes(splits) do
    for [head, tail] <- splits,
        String.length(tail) > 1,
        do: head <> String.at(tail, 1) <> String.at(tail, 0) <> String.slice(tail, 2..-1)
  end

  def replaces(splits) do
    List.flatten(
      for c <- @letters,
          do:
            for(
              [head, tail] <- splits,
              String.length(tail) > 0,
              do: head <> c <> String.slice(tail, 1..-1)
            )
    )
  end

  def inserts(splits) do
    List.flatten(
      for c <- @letters,
          do:
            for(
              [head, tail] <- splits,
              do: head <> c <> tail
            )
    )
  end

  def variations(word) do
    splits = splits(word)
    Enum.uniq(deletes(splits) ++ transposes(splits) ++ replaces(splits) ++ inserts(splits))
  end

  def best(options, dictionnary) do
    # Doesn't do anything anymore, since all values are equal to 1
    Enum.sort(options, &(dictionnary[&1] >= dictionnary[&2])) |> Enum.slice(0..2)
  end

  def check(word, dictionnary, depth \\ 0) do
    cond do
      depth > 1 ->
        {:error, word, []}

      dictionnary[word] ->
        {:ok, word}

      Regex.match?(~r{\A\d*\z}, word) ->
        {:ok, word}

      true ->
        {:error, word,
         Enum.map(variations(word), &check(&1, dictionnary, depth + 1))
         |> Enum.filter(&match?({:ok, _}, &1))
         |> Enum.map(&elem(&1, 1))
         |> Enum.uniq()
         |> best(dictionnary)}
    end
  end
end
