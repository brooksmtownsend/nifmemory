defmodule Basic do
  # Testing basic wasmex functionality. Compile a webassembly module, start_link it
  # and then see what happens in memory.

  # Compiling multiple times is a waste of memory
  # Instantiating 1000 modules, stopping them does leave around 6MB of memory
  # Somewhat of a waste here, but after starting and stopping 10000 instances it's a 32mb increase.
  # After a garbage collect, brought down to 27mb

  # Instantiating, calling, immediately stopping 100000 instances increases memory by 2mb. Garbage
  # collect removes that.

  # {:ok, mod} = Basic.compile
  # instances = 1..1000 |> Enum.map(fn _ -> Basic.instance(mod) end)
  # instances |> Enum.each(fn {:ok, i} -> Basic.stop_instance(i) end)
  # Process.list() |> Enum.each(&:erlang.garbage_collect/1)

  def compile() do
    {:ok, bytes} = File.read("wasmex_test.wasm")
    Wasmex.Module.compile(bytes)
  end

  def instance(module) do
    # starts a GenServer running this WASM instance
    Wasmex.start_link(%{module: module})
  end

  def call_fn(instance) do
    Wasmex.call_function(instance, "sum", [50, -8])
  end

  def simple_wasmer(module, stop \\ false) do
    {:ok, instance} = instance(module)
    {:ok, [42]} = call_fn(instance)

    if stop do
      stop_instance(instance)
    end
  end

  # NOTE: Not stopping the module intentionally, with the wasmex_test.wasm,
  # leaks 16 bytes.
  def stop_instance(instance) do
    GenServer.stop(instance, :normal)
  end

  def many_instantiates(num) do
    1..num
    |> Enum.each(fn _ ->
      {:ok, mod} = compile()
      simple_wasmer(mod)
    end)
  end

  def many_simples(module, num) do
    1..num
    |> Enum.each(fn _ ->
      simple_wasmer(module)
    end)
  end
end
