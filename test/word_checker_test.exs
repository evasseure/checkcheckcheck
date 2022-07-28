defmodule WordCheckerTest do
  use ExUnit.Case, async: true

  setup_all do
    dictionnary_file = File.read!("./data/dictionnary.txt")
    names_file = File.read!("./data/names.txt")

    (String.split(dictionnary_file) ++ String.split(names_file))
    |> Enum.filter(& &1)
    |> Enum.map(&Regex.replace(~r/[\W]*/, String.downcase(&1), ""))
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  test "correct word", dictionnary do
    assert WordChecker.check("hello", dictionnary) == {:ok, "hello"}
  end

  test "missing letter", dictionnary do
    result = WordChecker.check("hllo", dictionnary)
    assert match?({:error, "hllo", _}, result)
    assert length(elem(result, 2)) > 0
  end

  test "extra letter", dictionnary do
    result = WordChecker.check("supervisore", dictionnary)
    assert match?({:error, _, _}, result)
    assert length(elem(result, 2)) > 0
  end

  test "unknown word", dictionnary do
    result = WordChecker.check("pimpampoum", dictionnary)
    assert match?({:error, _, []}, result)
    assert length(elem(result, 2)) == 0
  end

  test "check suggestions", dictionnary do
    result = WordChecker.check("superflous", dictionnary)
    assert match?({:error, _, ["superfluous"]}, result)
  end

  test "ignore numbers", dictionnary do
    result = WordChecker.check("42", dictionnary)
    assert match?({:ok, _}, result)
  end

  test "speed check", dictionnary do
    {u_secs, result} = :timer.tc(WordChecker, :check, ["extroardinary", dictionnary])
    assert match?({:error, _, _}, result)
    # Completely arbitrary magic number, sue me
    assert u_secs < 1_000_000
  end
end
