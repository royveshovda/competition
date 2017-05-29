defmodule Api.Q3Controller do
  use Api.Web, :controller
  def index(conn, _params) do
    root =
      %{action: "GET",
        next_url: "ice.no"}
    json conn, root
  end
end
