defmodule Api.Q3Controller do
  use Api.Web, :controller
  def index(conn, %{"session_key" => session_key}) do
    # TODO: Verify session-key

    IO.puts "Session key: " <> session_key
    url = "/api/que3/" <> session_key
    result =
      %{question: "What is 3+3?",
        action: "POST",
        url: url,
        expected_content_type: "application/json",
        payload_template: %{answer: "<your answer here>"}}
    json conn, result
  end

  def create(conn, %{"answer" => answer, "session_key" => session_key}) do
    # TODO: Verify session-key
    # TODO: Verify answer(s)

    # TODO: Light red, yellow and green LED

    # TODO: Generate winner code

    IO.puts "Answer: " <> answer
    IO.puts "Session key: " <> session_key
    result = %{result: "OK", comment: "CONGRATULATIONS!!!!!!", next_action: "human interaction: Talk to a person from Ice about this."}
    json conn, result
  end
end
