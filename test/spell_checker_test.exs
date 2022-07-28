defmodule SpellCheckerTest do
  use ExUnit.Case

  setup_all do
    input = File.read!("data/inputs/ashford-short.txt")
    result = SpellChecker.check(input)
    # Not sure why, but I can't return the result by itself
    %{"r" => result}
  end

  test "no numbers corrected", result do
    for error <- result["r"],
        do: assert(!Regex.match?(~r{\A\d*\z}, elem(error, 1)), "Number corrected: #{elem(error, 1)}")
  end

  test "errors count", result do
    assert(length(result["r"]) == 29)
  end
end
