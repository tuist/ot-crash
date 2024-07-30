defmodule OtCrash.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    OpentelemetryBandit.setup()
    OpentelemetryPhoenix.setup()
    OpentelemetryEcto.setup([:tuist, :repo])
    OpentelemetryFinch.setup()

    children = [
      OtCrashWeb.Telemetry,
      OtCrash.Repo,
      {DNSCluster, query: Application.get_env(:ot_crash, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: OtCrash.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: OtCrash.Finch},
      # Start a worker by calling: OtCrash.Worker.start_link(arg)
      # {OtCrash.Worker, arg},
      # Start to serve requests, typically the last entry
      OtCrashWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OtCrash.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OtCrashWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
