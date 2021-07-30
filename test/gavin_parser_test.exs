defmodule GavinParserTest do
  use ExUnit.Case
  doctest GavinParser

  test "Hi `Alex` how are _you_?" do
    assert {:ok,
            [
              %{text: "Hi "},
              %{text: "Alex", classes: ["highlight"]},
              %{text: " how are "},
              %{text: "you", classes: ["underline"]},
              %{text: "?"}
            ], _, _, _, _} = GavinParser.parse("Hi `Alex` how are _you_?")
  end

  test "hello " do
    assert {:ok, [%{text: "hello "}], _, _, _, _} = GavinParser.parse("hello ")
  end

  test "hello `Sophie`" do
    assert {:ok, [%{text: "hello "}, %{text: "Sophie", classes: ["highlight"]}], _, _, _, _} =
             GavinParser.parse("hello `Sophie`")
  end

  test "hello _Ben_ and _Sophie_!" do
    assert {:ok,
            [
              %{text: "hello "},
              %{text: "Ben", classes: ["underline"]},
              %{text: " and "},
              %{text: "Sophie", classes: ["underline"]},
              %{text: "!"}
            ], _, _, _, _} = GavinParser.parse("hello _Ben_ and _Sophie_!")
  end

  test "single ` and single _ are just plain text" do
    assert {:ok, [%{text: "single ` and single _ are just plain text"}], _, _, _, _} =
             GavinParser.parse("single ` and single _ are just plain text")
  end

  test "Hé `Aléx`!" do
    assert {:ok,
            [
              %{text: "Hé "},
              %{text: "Aléx", classes: ["highlight"]},
              %{text: "!"}
            ], _, _, _, _} = GavinParser.parse("Hé `Aléx`!")
  end
end
