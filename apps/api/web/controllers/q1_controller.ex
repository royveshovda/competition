defmodule Api.Q1Controller do
  use Api.Web, :controller
def index(conn, _params) do
    root =
      %{action: "POST",
        next_url: "/api/quest2",
        payload_template: "TODO"}
    json conn, root
  end
end
