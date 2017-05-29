defmodule Api.RegisterController do
  use Api.Web, :controller
def index(conn, _params) do
    #Generate a new session
    session_key = Api.Storage.new_session()

    # TODO: Send to AWS

    template =
      %{session_key: session_key,
        email: "me@mail.com",
        name: "My Myself"}

    root =
      %{action: "POST",
        comment: "You need to register to play. Feel free to use bogus email and name, but we will contact you by email. Incorrect email == no price",
        payload_template: template,
        }
    json conn, root
  end
end
