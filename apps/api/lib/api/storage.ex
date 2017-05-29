defmodule Api.Storage do
  use GenServer
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def new_session() do
    GenServer.call(__MODULE__, :new)
  end

  def save_session(key, value) do
    GenServer.cast(__MODULE__, {:save, key, value})
    :ok
  end

  def get_session(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def get_all() do
    GenServer.call(__MODULE__, :get_all)
  end

  def delete() do
    GenServer.cast(__MODULE__, :delete)
  end


  # Server callbacks

  def init([]) do
    filename = Application.fetch_env!(:api, :sessions_filename)
    {:ok, sessions} = :dets.open_file(:sessions, [file: filename, type: :set])
    {:ok, sessions}
  end

  def handle_cast({:save, key, value}, sessions) do
    :dets.insert(sessions, {key, value})
    {:noreply, sessions}
  end

  def handle_cast(:delete, sessions) do
    :dets.delete_all_objects(sessions)
    {:noreply, sessions}
  end

  def handle_call(:new, _from, sessions) do
    session_key = random_string(32)

    # TODO: Check if existing

    session_state = %{state: :not_registered, q1: :blocked, q2: :blocked, q3: :blocked, name: "?", email: "?"}
    :dets.insert(sessions, {session_key, session_state})
    {:reply, session_key, sessions}
  end

  def handle_call({:get, key}, _from, sessions) do
    result = :dets.lookup(:sessions, key)
    {:reply, result, sessions}
  end

  def handle_call(:get_all, _from, sessions) do
    result = []
    {:noreply, result, sessions}
  end

  def terminate(_reason, sessions) do
    :dets.close(sessions)
    :ok
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
