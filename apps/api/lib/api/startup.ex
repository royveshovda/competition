defmodule Api.Startup do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    # Post delayed to make sure network is up and running
    Process.send_after(self(), :ann, 45000)
    {:ok, []}
  end

  def handle_info(:ann, state) do
    Api.Slack.say_to_slack("Starting up...I will serve the following questions:")
    Api.Slack.say_to_slack("Q1:  " <> Api.Questions.q1())
    Api.Slack.say_to_slack("A1:  " <> to_string(Api.Questions.a1()))
    Api.Slack.say_to_slack("Q2:  " <> Api.Questions.q2())
    Api.Slack.say_to_slack("A2:  " <> to_string(Api.Questions.a2()))
    Api.Slack.say_to_slack("Q3:  " <> Api.Questions.q3())
    Api.Slack.say_to_slack("A3:  " <> to_string(Api.Questions.a3()))
    {:stop, :normal, state}
  end

end
