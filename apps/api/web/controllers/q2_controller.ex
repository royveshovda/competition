defmodule Api.Q2Controller do
  use Api.Web, :controller

  def index(conn, %{"session_key" => session_key}) do
    result = case Api.Storage.is_valid_key?(session_key) do
      false -> %{result: "Invalid session-key"}
      true ->
        %{question: "What is 2+2?",
          action: "POST",
          url: "/api/quest2/" <> session_key,
          expected_content_type: "application/json",
          payload_template: %{answer: "<your answer here>"}}
    end
    json conn, result
  end

  def create(conn, %{"answer" => answer, "session_key" => session_key}) do
    correct_answer = "4"
    result = case Api.Storage.is_valid_key?(session_key) do
      false -> %{result: "Invalid session-key"}
      true ->
        case to_string(answer) == correct_answer do
          false ->
            Api.Storage.set_q2_wrong(session_key)
            %{result: "Wrong answer"}
          true ->
            Api.Storage.set_q2_correct(session_key)
            # TODO: Light red and yellow LEDs
            Leds.Leds.set_green(0)
            Leds.Leds.set_yellow(1)
            Leds.Leds.set_red(1)
            %{result: "OK",
              next_url: "/api/que3/" <> session_key,
              next_action: "GET"}
        end
    end
    # TODO: Light yellow LED
    json conn, result
  end
end
