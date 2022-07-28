defmodule WordCheckerVariationsTest do
  use ExUnit.Case, async: true

  test "test splits" do
    assert WordChecker.splits("abc") == [["", "abc"], ["a", "bc"], ["ab", "c"], ["abc", ""]]
  end

  test "test deletes" do
    splits = WordChecker.splits("abc")
    assert WordChecker.deletes(splits) == ["bc", "ac", "ab"]
  end

  test "test transposes" do
    splits = WordChecker.splits("abc")
    assert WordChecker.transposes(splits) == ["bac", "acb"]
  end

  test "test replaces" do
    splits = WordChecker.splits("abc")
    assert length(WordChecker.replaces(splits)) == 84
  end

  test "test inserts" do
    splits = WordChecker.splits("abc")
    assert length(WordChecker.inserts(splits)) == 112
  end

  test "test variations" do
    assert length(WordChecker.variations("abc")) == 182
  end
end
