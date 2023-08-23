defmodule SensorHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SensorHub.Supervisor]

    children = [
      # I really want to pass these ids in, but I could not figure that out
      # so in the supervisor they are hard coded :(
      {SensorHub.Sup, [118, 119]},
      {Finch, name: TemperatureTrackerClient},
      {
        Publisher,
        %{
          environment_tracker_url: environment_tracker_url()
        }
      }
    ]

    Supervisor.start_link(children, opts)
  end

  defp environment_tracker_url do
    Application.get_env(:sensor_hub, :environment_tracker_url)
  end

end
