defmodule SensorHub.Sup do
  use Supervisor

  def start_link(ids) do
    Supervisor.start_link(__MODULE__, ids, name: __MODULE__)
  end

  @impl true
  def init(_ids) do
    children = [
      Supervisor.child_spec({BMP280, [bus_name: "i2c-1", bus_address: 0x76, name: BMP280_1]}, id: 76),
      Supervisor.child_spec({BMP280, [bus_name: "i2c-1", bus_address: 0x77, name: BMP280_2]}, id: 77),
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
