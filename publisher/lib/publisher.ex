defmodule Publisher do
  use GenServer
  alias SensorHub.Sensor

  require Logger

  def start_link(options \\ %{}) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(options) do
    state = %{
      interval: options[:interval] || 10_000,
      environment_tracker_url: options[:environment_tracker_url],
      sensors: [%{id: 1, process: Process.whereis(BMP280_1)}, %{id: 2, process: Process.whereis(BMP280_2)}],
      measurements: :no_measurements
    }

    schedule_next_publish(state.interval)

    {:ok, state}
  end

  @impl true
  def handle_info(:publish_data, state) do
    {:noreply, state |> measure()}
  end

  defp measure(state) do
    for sensor <- state.sensors do
      %{id: id, process: process} = sensor
      measurement = Sensor.measure(process)
      {:ok, current_time} = DateTime.now("America/Los_Angeles")
      iso_time = DateTime.to_iso8601(current_time)
      data = Map.put(Map.put(measurement, :sensor_id, id), :time, iso_time)

      Logger.debug("Request Payload: #{inspect(data)}")
      result =
        :post
        |> Finch.build(
             state.environment_tracker_url,
             [{"Content-Type", "application/json"}],
             Jason.encode!(data)
           )
        |> Finch.request(TemperatureTrackerClient)

      Logger.debug("Server response: #{inspect(result)}")
    end

    schedule_next_publish(state.interval)

    state
  end

  defp schedule_next_publish(interval) do
    Process.send_after(self(), :publish_data, interval)
  end
end