defmodule Api.Q3Controller do
  use Api.Web, :controller

  def index(conn, %{"session_key" => session_key}) do
    result = case Api.Storage.is_valid_key?(session_key) do
      false -> %{result: "Invalid session-key"}
      true ->
        %{question: "What is 3+3?",
          action: "POST",
          url: "/api/que3/" <> session_key,
          expected_content_type: "application/json",
          payload_template: %{answer: "<your answer here>"}}
    end
    json conn, result
  end

  def create(conn, %{"answer" => answer, "session_key" => session_key}) do
    correct_answer = "6"
    result = case Api.Storage.is_valid_key?(session_key) do
      false -> %{result: "Invalid session-key"}
      true ->
        case to_string(answer) == correct_answer do
          false ->
            Api.Storage.set_q2_wrong(session_key)
            %{result: "Wrong answer"}
          true ->
            Api.Storage.set_q2_correct(session_key)
            Leds.Leds.set_green(1)
            Leds.Leds.set_yellow(1)
            Leds.Leds.set_red(1)
            # TODO: Light red, yellow and green LEDs
            # TODO: Generate winner code
            # TODO: Post to slack
            %{result: "OK",
              comment: "CONGRATULATIONS!!!!!!",
              next_action: "human interaction: Talk to a person from Ice about this."}
        end
    end
    json conn, result
  end
end
