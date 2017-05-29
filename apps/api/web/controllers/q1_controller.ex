defmodule Api.Q1Controller do
  use Api.Web, :controller
def index(conn, %{"session_key" => session_key}) do
    # TODO: Verify session-key

    IO.puts "Session key: " <> session_key
    url = "/api/q1/" <> session_key
    result =
      %{question: "What is 1+1?",
        action: "POST",
        url: url,
        expected_content_type: "application/json",
        payload_template: %{answer: "<your answer here>"}}
    json conn, result
  end

  def create(conn, %{"answer" => answer, "session_key" => session_key}) do
    # TODO: Verify session-key
    # TODO: Verify answer

    # TODO: Light red LED

    IO.puts "Answer: " <> answer
    IO.puts "Session key: " <> session_key
    next_url = "/api/quest2/" <> session_key
    result = %{result: "OK", next_url: next_url, next_action: "GET"}
    json conn, result
  end

end
