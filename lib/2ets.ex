defmodule ETS do
  def create_table() do
    :ets.new(:compiled_actor_table, [:named_table, :set, :public])
  end

  def insert() do
    {:ok, mod} = Basic.compile()
    :ets.insert(:compiled_actor_table, {"hey", mod})
  end

  def instantiate() do
    [{"hey", mod}] = :ets.lookup(:compiled_actor_table, "hey")
    {:ok, instance} = Basic.instance(mod)
    Basic.stop_instance(instance)
  end

  def many_instantiate(num) do
    1..num
    |> Enum.each(fn _ -> instantiate() end)
  end
end
