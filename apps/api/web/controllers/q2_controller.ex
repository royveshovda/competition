defmodule Api.Q2Controller do
  use Api.Web, :controller
  def index(conn, %{"session_key" => session_key}) do
    IO.puts "Session key: " <> session_key
    root =
      %{action: "POST",
        next_url: "/api/que3",
        payload_template: "TODO"}
    json conn, root
  end
end
