defmodule Api.Q1Controller do
  use Api.Web, :controller

  def index(conn, %{"session_key" => session_key}) do
    result = case Api.Storage.is_valid_key?(session_key) do
      false -> %{result: "Invalid session-key"}
      true ->
        Api.Slack.say_to_slack("("<>session_key<>") Q1 found")
        %{question: Api.Questions.q1(),
          action: "POST",
          url: "/api/q1/" <> session_key,
          expected_content_type: "application/json",
          payload_template: %{answer: "<your answer here>"}}
    end
    json conn, result
  end

  def create(conn, %{"answer" => answer, "session_key" => session_key}) do
    correct_answer = to_string(Api.Questions.a1())
    result = case Api.Storage.is_valid_key?(session_key) do
      false -> %{result: "Invalid session-key"}
      true ->
        case to_string(answer) == correct_answer do
          false ->
            Api.Storage.set_q1_wrong(session_key)
            Api.Slack.say_to_slack("("<>session_key<>") Q1 wrong: "<> to_string(answer))
            %{result: "Wrong answer"}
          true ->
            Api.Storage.set_q1_correct(session_key)

            Leds.Leds.set_1_correct()

            Api.Slack.say_to_slack("("<>session_key<>") Q1 correct")

            %{result: "OK",
              next_url: "/api/quest2/" <> session_key,
              next_action: "GET"}
        end
    end
    json conn, result
  end
end
