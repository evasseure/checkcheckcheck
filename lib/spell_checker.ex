require Logger

defmodule SpellChecker do
  defp cleaned(word) do
    Regex.replace(~r/[\W]*/, String.downcase(word), "")
  end

  defp check_sentence(sentence, dictionnary) do
    Enum.map(String.split(sentence), &WordChecker.check(cleaned(&1), dictionnary, 0))
    |> Enum.filter(&match?({:error, _, _}, &1))
  end

  def check(text) do
    Logger.info("Loading dictionnary...")
    dictionnary_file = File.read!("./data/dictionnary.txt")
    names_file = File.read!("./data/names.txt")
    Logger.info("Loaded!")

    dictionnary =
      (String.split(dictionnary_file) ++ String.split(names_file))
      |> Enum.filter(& &1)
      |> Enum.map(&Regex.replace(~r/[\W]*/, String.downcase(&1), ""))
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)

    run_checker = fn ->
      tasks = for(sentence <- String.split(text, "."), do: Task.async(fn -> check_sentence(sentence, dictionnary) end))
      Task.await_many(tasks, 100_000) |> List.flatten()
    end

    {u_secs, result} = :timer.tc(run_checker)
    word_count = length(String.split(text))
    Logger.info("Total time: #{u_secs / 1_000_000}s")
    Logger.info("Words: #{word_count}")
    Logger.info("Words per second: #{(word_count / (u_secs / 1_000_000)) |> Float.ceil(2)} word/s")
    result
  end
end
