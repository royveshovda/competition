defmodule Api.Q3Controller do
  use Api.Web, :controller

  def index(conn, %{"session_key" => session_key}) do
    result = case Api.Storage.is_valid_key?(session_key) do
      false -> %{result: "Invalid session-key"}
      true ->
        Api.Slack.say_to_slack("("<>session_key<>") Q3 found")
        %{question: Api.Questions.q3(),
          action: "POST",
          url: "/api/que3/" <> session_key,
          expected_content_type: "application/json",
          payload_template: %{answer: "<your answer here>"}}
    end
    json conn, result
  end

  def create(conn, %{"answer" => answer, "session_key" => session_key}) do
    correct_answer = to_string(Api.Questions.a3())
    result = case Api.Storage.is_valid_key?(session_key) do
      false -> %{result: "Invalid session-key"}
      true ->
        case to_string(answer) == correct_answer do
          false ->
            Api.Storage.set_q3_wrong(session_key)
            Api.Slack.say_to_slack("("<>session_key<>") Q3 wrong: "<> to_string(answer))
            %{result: "Wrong answer"}
          true ->
            Api.Storage.set_q3_correct(session_key)
            prize_token = Api.Storage.generate_and_store_prize_token(session_key)
            Leds.Leds.blink_leds(10)
            Leds.Leds.set_3_correct()

            Api.Slack.scream_to_slack("("<>session_key<>") WE HAVE A WINNER: " <> prize_token)

            %{result: "OK",
              comment: "CONGRATULATIONS!!!!!!",
              prize_token: prize_token,
              next_action: "human interaction: Talk to a person from Ice about this."}
        end
    end
    json conn, result
  end
end
