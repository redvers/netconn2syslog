
defmodule Netconn2syslog.Worker do
  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: String.to_atom("nccache-#{id}"))
  end

  def init(id) do
    {:ok, {id, HashDict.new}}
  end


end
