defmodule Countdown.Counter do
   @limit 100
   @initial_value 0
   @timeout 2000

  def start_link do
    Agent.start_link(fn -> @initial_value end, name: __MODULE__)
  end

  def reset do
    Agent.get_and_update( __MODULE__, fn(_current_state) -> {@initial_value, @initial_value} end, @timeout)
  end

  def value do
    Agent.get(__MODULE__, fn(current_state) -> current_state end, @timeout)
  end

  def limit do
    @limit
  end

  def count do
    Agent.get_and_update( __MODULE__, fn(state) -> increment(state) end, @timeout)
  end

  def set(new_state) do
    Agent.update(__MODULE__, fn(_current_state) -> new_state end, @timeout)
  end

  defp increment(current_state) do
    new_state = current_state + 1
    cond do
      new_state >= @limit -> {{:overflow, @initial_value}, @initial_value}
      true -> {{:ok, new_state}, new_state}
    end
  end

end
