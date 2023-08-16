defmodule SensorHub.Sensor do

  def convert_fn({:ok, measurement}) do
    Map.take(measurement, [:dew_point_c, :humidity_rh, :pressure_pa, :temperature_c])
  end

  def convert_fn(_other) do
    %{}
  end

  def measure(pid) do
    BMP280.measure(pid) |> convert_fn()
  end
end
