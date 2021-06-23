defmodule CowinWeb.RequestController do
  use CowinWeb, :controller
  import HTTPoison

  @url "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?"
  @token "1814386693:AAGvaWhW92LnXJrwfHvb7iYZNoCjfL7vqdA"

  def index(conn, _opts) do
    Telegram.Api.request(@token, "sendMessage",
        chat_id: 1_559_385_772,
        text: "checking...",
        disable_notification: true
      )
    Enum.each(1..6, fn _ -> check_three_days() end)
    conn
  end

  defp check_three_days() do
    Enum.each([0, 1, 2], fn x ->
      append_values(@url, x)
      |> get()
      |> parse_op()
      |> notify(x)
    end)
  end

  defp append_values(url, inc) do
    url <> "district_id=303&" <> "date=" <> get_date(inc)
  end

  defp parse_op({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    find_avail_centre(Jason.decode!(body))
  end

  defp find_avail_centre(%{"sessions" => list}) do
    Enum.find(list, fn
      %{
        "vaccine" => "COVISHIELD",
        "available_capacity_dose1" => dose1,
        "min_age_limit" => al
      } ->
        dose1 > 0 && check_al(al)

      _ ->
        false
    end)
    |> IO.inspect(label: "----------------------------OUTPUT------------------------------")
  end

  defp check_al(age) when age >= 15 and age < 40, do: true
  defp check_al(_), do: false

  defp get_date(inc) do
    inc =
      case inc do
        0 -> 0
        1 -> 86400
        2 -> 172_800
      end

    {:ok, date} = DateTime.now("Etc/UTC")
    date = DateTime.add(date, inc + 19800, :second) |> DateTime.to_date() |> Date.to_string()
    list = String.split(date, ["-"])
    year = Enum.at(list, 0)
    month = Enum.at(list, 1)
    day = Enum.at(list, 2)
    # "08-06-2021 ->  format"
    day <> "-" <> month <> "-" <> year
  end

  defp notify(nil, x),
    do: nil
      # Telegram.Api.request(@token, "sendMessage",
      #   chat_id: 1_559_385_772,
      #   text: "#{x}: nil",
      #   disable_notification: false
      # )

  # File.open("result.txt", [:read, :append], fn file ->
  #   IO.inspect(file, "#{x}: nil", [])
  # end)

  defp notify(val, x) do
    string =
      Map.keys(val)
      |> Enum.map(fn key -> "#{key}:#{val[key]}" end)
      |> Enum.join("||")

    Telegram.Api.request(@token, "sendMessage",
      chat_id: 1_559_385_772,
      text: "#{x}:#{string}",
      disable_notification: false
    )

    # File.open("result.txt", [:read, :append], fn file ->
    #   IO.inspect(file, val, label: x)
    # end)
  end
end
