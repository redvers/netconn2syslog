defmodule Netconn2syslog do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Netconn2syslog.Worker,[1])
    ]
    opts = [strategy: :one_for_one, name: Netconn2syslog.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
