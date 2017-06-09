defmodule Api.PageController do
  use Api.Web, :controller

  def index(conn, _params) do
    Api.Slack.say_to_slack("Web found")
    render conn, "index.html"
  end
end
