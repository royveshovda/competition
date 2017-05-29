defmodule Api.Q2Controller do
  use Api.Web, :controller
  def index(conn, %{"session_key" => session_key}) do
    # TODO: Verify session-key

    IO.puts "Session key: " <> session_key
    url = "/api/quest2/" <> session_key
    result =
      %{question: "What is 2+2?",
        action: "POST",
        url: url,
        expected_content_type: "application/json",
        payload_template: %{answer: "<your answer here>"}}
    json conn, result
  end

  def create(conn, %{"answer" => answer, "session_key" => session_key}) do
    # TODO: Verify session-key
    # TODO: Verify answer

    # TODO: Light red and yellow LED

    IO.puts "Answer: " <> answer
    IO.puts "Session key: " <> session_key
    next_url = "/api/que3/" <> session_key
    result = %{result: "OK", next_url: next_url, next_action: "GET"}
    json conn, result
  end
end
