defmodule Api.Q2Controller do
  use Api.Web, :controller
  def index(conn, _params) do
    root =
      %{action: "POST",
        next_url: "/api/que3",
        payload_template: "TODO"}
    json conn, root
  end
end
