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
    ips = get_ips()
    Api.Slack.say_to_slack("Running on IP: " <> Enum.join(ips, " -- "))
    Api.Slack.say_to_slack("Starting up...I will serve the following questions:")
    Api.Slack.say_to_slack("Q1:  " <> Api.Questions.q1())
    Api.Slack.say_to_slack("A1:  " <> to_string(Api.Questions.a1()))
    Api.Slack.say_to_slack("Q2:  " <> Api.Questions.q2())
    Api.Slack.say_to_slack("A2:  " <> to_string(Api.Questions.a2()))
    Api.Slack.say_to_slack("Q3:  " <> Api.Questions.q3())
    Api.Slack.say_to_slack("A3:  " <> to_string(Api.Questions.a3()))
    {:stop, :normal, state}
  end

  defp get_ips() do
    {:ok, ips} = :inet.getif
    IO.inspect ips
    filter_ip_address(ips, [])
  end

  defp filter_ip_address([], acc) do
    acc
  end

  defp filter_ip_address([{{127,0,0,1}, _broadcast, _mask} | tail], acc) do
    filter_ip_address(tail, acc)
  end

  defp filter_ip_address([head | tail], acc) do
    {{oct1, oct2, oct3, oct4}, _broadcast, _mask} = head
    ip = to_string(oct1) <> "." <> to_string(oct2) <> "." <> to_string(oct3) <> "." <> to_string(oct4)
    filter_ip_address(tail, acc ++ [ip])
  end
end
