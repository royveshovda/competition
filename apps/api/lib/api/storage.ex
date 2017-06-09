defmodule Api.Storage do
  use GenServer

  defstruct state: :not_registered,
            q1: nil,
            q2: nil,
            q3: nil,
            name: nil,
            email: nil,
            prize_token: nil,
            closed: false

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

  def is_valid_key?(key) do
    GenServer.call(__MODULE__, {:valid, key})
  end

  def set_q1_wrong(session_key) do
    GenServer.cast(__MODULE__, {:q1, session_key, "wrong"})
  end

  def set_q1_correct(session_key) do
    GenServer.cast(__MODULE__, {:q1, session_key, "correct"})
  end

  def set_q2_wrong(session_key) do
    GenServer.cast(__MODULE__, {:q2, session_key, "wrong"})
  end

  def set_q2_correct(session_key) do
    GenServer.cast(__MODULE__, {:q2, session_key, "correct"})
  end

  def set_q3_wrong(session_key) do
    GenServer.cast(__MODULE__, {:q3, session_key, "wrong"})
  end

  def set_q3_correct(session_key) do
    GenServer.cast(__MODULE__, {:q3, session_key, "correct"})
  end

  def set_name_and_email(session_key, name, email) do
    GenServer.cast(__MODULE__, {:name_and_email, session_key, name, email})
  end

  def generate_and_store_prize_token(session_key) do
    GenServer.call(__MODULE__, {:prize, session_key})
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

  def handle_cast({:q1, session_key, new_result}, sessions) do
    [{session_key, state}] = :dets.lookup(sessions, session_key)
    new_state = %Api.Storage{state | q1: new_result}
    :dets.insert(sessions, {session_key, new_state})
    {:noreply, sessions}
  end

  def handle_cast({:q2, session_key, new_result}, sessions) do
    [{session_key, state}] = :dets.lookup(sessions, session_key)
    new_state = %Api.Storage{state | q2: new_result}
    :dets.insert(sessions, {session_key, new_state})
    {:noreply, sessions}
  end

  def handle_cast({:q3, session_key, new_result}, sessions) do
    [{session_key, state}] = :dets.lookup(sessions, session_key)
    new_state = %Api.Storage{state | q3: new_result}
    :dets.insert(sessions, {session_key, new_state})
    {:noreply, sessions}
  end

  def handle_cast({:name_and_email, session_key, name, email}, sessions) do
    [{session_key, state}] = :dets.lookup(sessions, session_key)
    new_state = %Api.Storage{state | state: :registered, name: name, email: email}
    :dets.insert(sessions, {session_key, new_state})
    {:noreply, sessions}
  end

  def handle_call(:new, _from, sessions) do
    key = ensure_unique_key(sessions, 32)
    session_state = %Api.Storage{state: :not_registered}
    :dets.insert(sessions, {key, session_state})
    {:reply, key, sessions}
  end

  def handle_call({:get, key}, _from, sessions) do
    result = :dets.lookup(sessions, key)
    {:reply, result, sessions}
  end

  def handle_call(:get_all, _from, sessions) do
    result = []
    {:noreply, result, sessions}
  end

  def handle_call({:valid, key}, _from, sessions) do
    result = case :dets.lookup(sessions, key) do
      [] -> false
      [{key, session}] -> !session.closed
      _ -> false
    end
    {:reply, result, sessions}
  end

  def handle_call({:prize, session_key}, _from, sessions) do
    token = random_string(4) |> String.downcase
    [{session_key, state}] = :dets.lookup(sessions, session_key)
    new_state = %Api.Storage{state | prize_token: token, closed: true}
    :dets.insert(sessions, {session_key, new_state})
    {:reply, token, sessions}
  end

  defp ensure_unique_key(sessions, length) do
    candidate = random_string(length)
    case :dets.lookup(sessions, candidate) do
      [] -> candidate
      _ ->
        IO.puts("Not unique")
        ensure_unique_key(sessions, length)
    end
  end

  def terminate(_reason, sessions) do
    :dets.close(sessions)
    :ok
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
