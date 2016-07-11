defmodule Countdown.ArenaChannel do
  use Phoenix.Channel

  alias Countdown.Counter

  def join("arenas:lobby", _message, socket) do
    counter = Counter.value
    {:ok, %{counter: counter}, socket}
  end

  def handle_in("count", %{}, socket) do
    reply = case Counter.count do
    {:ok, counter} ->
      %{won: false, counter: counter}
    {:overflow, counter} ->
      %{won: true, counter: counter}
    end
    broadcast! socket, "update", %{counter: reply.counter}
    {:reply, {:ok, reply}, socket}
  end
end
