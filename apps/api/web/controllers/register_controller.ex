defmodule Api.RegisterController do
  use Api.Web, :controller
def index(conn, _params) do
    #Generate a new session
    session_key = Api.Storage.new_session()

    # TODO: Send to AWS

    template =
      %{email: "me@mail.com", name: "My Myself"}
    url = "/api/register/" <> session_key

    root =
      %{action: "POST",
        url: url,
        payload_template: template,
        expected_content_type: "application/json",
        comment: "You need to register to play. Feel free to use bogus email and name, but we will contact you by email. Incorrect email == no price"
        }
    json conn, root
  end

  def create(conn, %{"email" => email, "name" => name, "session_key" => session_key}) do
    IO.puts "Name: " <> name
    IO.puts "Email: " <> email
    IO.puts "Session key: " <> session_key
    next_url = "/api/q1/" <> session_key
    result = %{result: "OK", next_url: next_url, next_action: "GET"}
    json conn, result
  end
end
