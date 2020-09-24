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

  @doc ~S"""
  Decodes a joke.

  ## Examples

  iex> # returns a map when the input is valid
  ...> Jest.Parser.decode("How do you make an egg laugh?|54656C6C206974206120796F6C6B|Ollie Tabooger")
  {
    :ok,
    %{
       body: "How do you make an egg laugh?",
       punchline: "Tell it a yolk",
       author: "Ollie Tabooger"
    }
  }

  iex> # returns an error when the punchline cannot be decoded
  ...> Jest.Parser.decode("How do you make an egg laugh?|*****************************|Ollie Tabooger")
  {:error, :invalid_input}

  iex> # returns an error when the input is not a string
  ...> Jest.Parser.decode(%{})
  {:error, :invalid_input}

  iex> # returns an error when string is invalid
  ...> Jest.Parser.decode("How do you make an egg laugh?")
  {:error, :invalid_input}

  iex> # returns an error when the input is not a string
  ...> Jest.Parser.decode(%{})
  {:error, :invalid_input}
  """
  @spec decode(String.t()) :: {:ok, map()} | {:error, :invalid_input}
  def decode(encoded_joke) when is_binary(encoded_joke) do
    with [body, encoded_punchline, author] <- split_encoded_string(encoded_joke),
         {:ok, decoded_punchline} <- Base.decode16(encoded_punchline) do
      {
        :ok,
        %{
          body: body,
          punchline: decoded_punchline,
          author: author
        }
      }
    else
      :error -> {:error, :invalid_input}
    end
  end

  def decode(_encoded_joke), do: {:error, :invalid_input}

  @spec split_encoded_string(String.t()) :: list(String.t()) | :error
  defp split_encoded_string(encoded_joke) do
    case String.split(encoded_joke, "|") do
      [body, encoded_punchline, author] -> [body, encoded_punchline, author]
      _ -> :error
    end
  end
end
