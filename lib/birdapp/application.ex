defmodule Birdapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BirdappWeb.Telemetry,
      Birdapp.Repo,
      {DNSCluster, query: Application.get_env(:birdapp, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Birdapp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Birdapp.Finch},
      # Start a worker by calling: Birdapp.Worker.start_link(arg)
      # {Birdapp.Worker, arg},
      # Start to serve requests, typically the last entry
      BirdappWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Birdapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BirdappWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
