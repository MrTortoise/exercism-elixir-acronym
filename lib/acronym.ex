defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """

  @punctuation "!&@$%^&:,'"

  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.split([" ", "-"])
    |> Enum.map(fn s -> String.trim(s, "_") end)
    |> Enum.reduce([], &inconsistent_case_check/2)
    |> Enum.reject(&is_punctuation/1)
    |> Enum.join()
    |> String.upcase()
  end

  defp is_upper(string), do: String.upcase(string) == string

  defp is_punctuation(char), do: String.contains?(@punctuation, char)

  defp inconsistent_case_check("", existing), do: existing
  defp inconsistent_case_check(string, existing) do
     [first | rest] = String.graphemes(string)
     existing ++ [first | get_upper_chars_if_case_change(rest, is_upper(first))]
  end

  defp get_upper_chars_if_case_change([], _), do: []
  defp get_upper_chars_if_case_change([h | t], false) do
    upper = is_upper(h)
    if (upper) do
      [h | get_upper_chars_if_case_change(t, true)]
    else
      get_upper_chars_if_case_change(t, false)
    end
  end

  defp get_upper_chars_if_case_change([h | t], true) do
    get_upper_chars_if_case_change(t, is_upper(h))
  end
end
