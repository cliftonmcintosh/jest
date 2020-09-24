defmodule Jest.Parser do
  @moduledoc """
  Functions for parsing jokes.
  """

  @doc ~S"""
  Encodes a joke.

  ## Examples

  iex> # returns an encoded joke when the input is valid
  ...> Jest.Parser.encode(
  ...>   %{
  ...>      body: "How do you make an egg laugh?",
  ...>      punchline: "Tell it a yolk",
  ...>      author: "Ollie Tabooger"
  ...>   }
  ...> )
  {:ok, "How do you make an egg laugh?|54656C6C206974206120796F6C6B|Ollie Tabooger"}

  iex> # returns an error when the input is invalid
  ...> Jest.Parser.encode(
  ...>   %{
  ...>      body: nil,
  ...>      punchline: nil,
  ...>      author: nil
  ...>   }
  ...> )
  {:error, :invalid_input}
  """
  @spec encode(map()) :: {:ok, String.t()} | {:error, :invalid_input}
  def encode(%{body: body, punchline: punchline, author: author})
      when is_binary(body) and is_binary(punchline) and is_binary(author) do
    {:ok, body <> "|" <> Base.encode16(punchline) <> "|" <> author}
  end

  def encode(_joke), do: {:error, :invalid_input}
end
