defmodule Api.Q2Controller do
  use Api.Web, :controller

  def index(conn, %{"session_key" => session_key}) do
    result = case Api.Storage.is_valid_key?(session_key) do
      false -> %{result: "Invalid session-key"}
      true ->
        Api.Slack.say_to_slack("("<>session_key<>") Q2 found")
        %{question: Api.Questions.q2(),
          action: "POST",
          url: "/api/quest2/" <> session_key,
          expected_content_type: "application/json",
          payload_template: %{answer: "<your answer here>"}}
    end
    json conn, result
  end

  def create(conn, %{"answer" => answer, "session_key" => session_key}) do
    correct_answer = to_string(Api.Questions.a2())
    result = case Api.Storage.is_valid_key?(session_key) do
      false -> %{result: "Invalid session-key"}
      true ->
        case to_string(answer) == correct_answer do
          false ->
            Api.Storage.set_q2_wrong(session_key)
            Api.Slack.say_to_slack("("<>session_key<>") Q2 wrong: "<> to_string(answer))
            %{result: "Wrong answer"}
          true ->
            Api.Storage.set_q2_correct(session_key)

            Leds.Leds.set_2_correct()

            Api.Slack.say_to_slack("("<>session_key<>") Q2 correct")

            %{result: "OK",
              next_url: "/api/que3/" <> session_key,
              next_action: "GET"}
        end
    end
    json conn, result
  end
end
