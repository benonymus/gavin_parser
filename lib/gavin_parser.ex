defmodule GavinParser do
  @moduledoc """
  Documentation for `GavinParser`.
  """
  import NimbleParsec

  highlight_char = string("`")

  underline_char = string("_")

  basic_string = utf8_string([not: ?_, not: ?`], min: 1)

  highlight =
    ignore(highlight_char)
    |> concat(basic_string)
    |> ignore(highlight_char)
    |> tag(:highlight)
    |> post_traverse({:post_wrapped, ["highlight"]})

  underline =
    ignore(underline_char)
    |> concat(basic_string)
    |> ignore(underline_char)
    |> tag(:underline)
    |> post_traverse({:post_wrapped, ["underline"]})

  normal_text =
    times(
      utf8_char([])
      |> lookahead_not(highlight)
      |> lookahead_not(underline),
      min: 1
    )
    |> choice([eos(), utf8_char([])])
    |> post_traverse(:post_plain)

  defp post_wrapped(_rest, parsed, context, _line, _offset, class) do
    {Enum.map(parsed, fn
       {:highlight, [text]} -> %{text: text, classes: [class]}
       {:underline, [text]} -> %{text: text, classes: [class]}
     end), context}
  end

  defp post_plain(_rest, parsed, context, _line, _offset) do
    {[%{text: parsed |> Enum.reverse() |> List.to_string()}], context}
  end

  parse =
    repeat(
      choice([
        highlight,
        underline,
        normal_text
      ])
    )

  defparsec(:parse, parse)
end
