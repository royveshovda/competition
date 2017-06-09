defmodule Api.Slack do
  def scream_to_slack(message) do
    msg = ":loudspeaker: <!channel>  --  " <> message
    post(msg)
  end

  def say_to_slack(message) do
    post(message)
  end

  defp post(message) do
    webhook_url = Application.get_env(:api, :slack)[:url]
    payload = Poison.encode!(%{text: message})
    HTTPoison.post webhook_url, payload, ["Content-Type": "application/json"]
  end
end
