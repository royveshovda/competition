defmodule Api.Q1Controller do
  use Api.Web, :controller

  def index(conn, %{"session_key" => session_key}) do
    result = case Api.Storage.is_valid_key?(session_key) do
      false -> %{result: "Invalid session-key"}
      true ->
        %{question: "What is 1+1?",
          action: "POST",
          url: "/api/q1/" <> session_key,
          expected_content_type: "application/json",
          payload_template: %{answer: "<your answer here>"}}
    end
    json conn, result
  end

  def create(conn, %{"answer" => answer, "session_key" => session_key}) do
    correct_answer = "2"
    result = case Api.Storage.is_valid_key?(session_key) do
      false -> %{result: "Invalid session-key"}
      true ->
        case to_string(answer) == correct_answer do
          false ->
            Api.Storage.set_q1_wrong(session_key)
            %{result: "Wrong answer"}
          true ->
            Api.Storage.set_q1_correct(session_key)
            # TODO: Light red LED
            %{result: "OK",
              next_url: "/api/quest2/" <> session_key,
              next_action: "GET"}
        end
    end
    json conn, result
  end
end
