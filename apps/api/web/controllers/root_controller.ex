defmodule Api.RootController do
  use Api.Web, :controller
def index(conn, _params) do
  Api.Slack.say_to_slack("API found")
    root =
      %{action: "GET",
        next_url: "/api/register"}
    json conn, root
  end
end
