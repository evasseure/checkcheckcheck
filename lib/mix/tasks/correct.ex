require Logger

defmodule Mix.Tasks.Correct do
  @moduledoc "Prints errors and their correction suggestion"
  @shortdoc "Prints errors and their correction suggestion"

  use Mix.Task

  def correct(path) do
    input = File.read(path)

    input =
      case input do
        {:ok, _} -> elem(input, 1)
        _ -> path
      end

    result = SpellChecker.check(input)

    Enum.reduce(result, "Errors in input:\n", fn error, acc ->
      acc <> "Word: #{elem(error, 1)}, Suggestions: [#{Enum.join(elem(error, 2), ", ")}]\n"
    end)
  end

  @impl Mix.Task
  def run(args) do
    cond do
      length(args) == 1 -> Logger.info(correct(hd(args)))
      true -> Logger.info("Usage: mix correct FILEPATH")
    end
  end
end
