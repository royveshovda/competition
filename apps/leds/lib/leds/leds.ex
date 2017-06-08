defmodule Leds.Leds do
  use GenServer

  def set_1_correct() do
    set_red(1)
    set_yellow(0)
    set_green(0)
    Process.send_after(self(), :light_off, 60000)
  end

  def set_2_correct() do
    set_red(1)
    set_yellow(1)
    set_green(0)
    Process.send_after(self(), :light_off, 60000)
  end

  def set_3_correct() do
    set_red(1)
    set_yellow(1)
    set_green(1)
    Process.send_after(self(), :light_off, 60000)
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def set_green(1) do
    GenServer.cast(__MODULE__, {:green, 1})
  end

  def set_green(0) do
    GenServer.cast(__MODULE__, {:green, 0})
  end

  def set_yellow(1) do
    GenServer.cast(__MODULE__, {:yellow, 1})
  end

  def set_yellow(0) do
    GenServer.cast(__MODULE__, {:yellow, 0})
  end

  def set_red(1) do
    GenServer.cast(__MODULE__, {:red, 1})
  end

  def set_red(0) do
    GenServer.cast(__MODULE__, {:red, 0})
  end

  def init([]) do
    {:ok, pid_green} = ElixirALE.GPIO.start_link(19, :output)
    {:ok, pid_yellow} = ElixirALE.GPIO.start_link(6, :output)
    {:ok, pid_red} = ElixirALE.GPIO.start_link(26, :output)
    {:ok, {pid_green, pid_yellow, pid_red}}
  end

  def handle_cast({:green, led_state}, {pid_green, pid_yellow, pid_red}) do
    ElixirALE.GPIO.write(pid_green, led_state)
    {:noreply, {pid_green, pid_yellow, pid_red}}
  end

  def handle_cast({:yellow, led_state}, {pid_green, pid_yellow, pid_red}) do
    ElixirALE.GPIO.write(pid_yellow, led_state)
    {:noreply, {pid_green, pid_yellow, pid_red}}
  end

  def handle_cast({:red, led_state}, {pid_green, pid_yellow, pid_red}) do
    ElixirALE.GPIO.write(pid_red, led_state)
    {:noreply, {pid_green, pid_yellow, pid_red}}
  end

  def handle_info(:light_off, {pid_green, pid_yellow, pid_red}) do
    ElixirALE.GPIO.write(pid_green, 0)
    ElixirALE.GPIO.write(pid_yellow, 0)
    ElixirALE.GPIO.write(pid_red, 0)
    {:noreply, {pid_green, pid_yellow, pid_red}}
  end
end
