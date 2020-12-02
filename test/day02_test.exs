defmodule Day02Test do
  use ExUnit.Case, aync: true
  alias Aoc2020.Day02

  test "parse_policy" do
    assert {1, 3, "a"} = Day02.parse_policy("1-3 a")
    assert {2, 9, "c"} = Day02.parse_policy("2-9 c")
  end

  test "valid_password?" do
    assert true === Day02.valid_password?("abcde", {1, 3, "a"})
    assert false === Day02.valid_password?("cdefg", {1, 3, "b"})
    assert true === Day02.valid_password?("ccccccccc", {2, 9, "c"})
  end

  test "valid_password2?" do
    assert true === Day02.valid_password2?("abcde", {1, 3, "a"})
    assert false === Day02.valid_password2?("cdefg", {1, 3, "b"})
    assert false === Day02.valid_password2?("ccccccccc", {2, 9, "c"})
  end
end
