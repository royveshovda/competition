defmodule Api.Slack do
  def post_to_slack(message) do
    webhook_url = Application.get_env(:api, :slack)[:url]
    message = ":loudspeaker: <!channel>  --  " <> message
    payload = Poison.encode!(%{text: message})
    IO.puts payload
    HTTPoison.post webhook_url, payload, ["Content-Type": "application/json"]

  end
end
