defmodule Firmware.Application do
  use Application
  @interface :wlan0

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # worker(Firmware.Worker, [arg1, arg2, arg3]),
      worker(Task, [fn -> init_network() end], restart: :transient, id: Nerves.Init.Network),
      #worker(Nerves.Ntp.Worker, [], restart: :permanent)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children, opts)
  end


  def init_network() do
    opts = Application.get_env(:firmware, @interface)
    Nerves.InterimWiFi.setup(@interface, opts)
  end
end
