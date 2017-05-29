defmodule Api.Q3Controller do
  use Api.Web, :controller
  def index(conn, %{"session_key" => session_key}) do
    IO.puts "Session key: " <> session_key
    root =
      %{action: "GET",
        next_url: "ice.no"}
    json conn, root
  end
end
