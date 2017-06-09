defmodule Firmware.Application do
  use Application
  @interface :wlan0
  @target "#{System.get_env("MIX_TARGET")}"

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = build_children(@target)

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp build_children("host") do
    import Supervisor.Spec, warn: false
    IO.puts("HOST")
    []
  end

  defp build_children(_target) do
    import Supervisor.Spec, warn: false
    [worker(Task, [fn -> init_network() end], restart: :transient, id: Nerves.Init.Network)]
  end

  def init_network() do
    opts = Application.get_env(:firmware, @interface)
    Nerves.InterimWiFi.setup(@interface, opts)
  end

  def send_startup_message() do
    # TODO: Send message when starting up
  end
end
