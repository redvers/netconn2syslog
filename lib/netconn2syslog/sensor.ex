defmodule Netconn2syslog.Sensor do
  use GenServer

  def recv_netconn(sensorid, header, network) do
   case :gproc.lookup_local_name({:sensor, sensorid}) do
     :undefined ->
       {:ok, pid} = start_link(sensorid)
       GenServer.cast(pid, {:netconn_event, header, network})
     pid ->
       GenServer.cast(pid, {:netconn_event, header, network})
   end
  end






  def start_link(sensorid) do
    GenServer.start_link(__MODULE__, sensorid, [])
  end

  def init(sensorid) do
    :gproc.reg({:n, :l, {:sensor, sensorid}})
    {:ok, [sensorid, %{}]}
  end

  def handle_cast({:netconn_event, %Cbprotobuf.CbHeaderMsg{process_pid: nil}, _}, state) do
    IO.puts("I have an old sensor and so I'm going to ignore you for now...")
    {:noreply, state}
  end
  def handle_cast({:netconn_event,
                    header = %Cbprotobuf.CbHeaderMsg{process_guid: process_guid, process_md5: process_md5, timestamp: timestamp},
                    network = %Cbprotobuf.CbNetConnMsg{ipv4Address: ipv4Address, port: port,
                                             remoteIpAddress: remoteIpAddress, remotePort: remotePort,
                                             localIpAddress: localIpAddress, localPort: localPort,
                                             outbound: outbound, protocol: protocol,
                                             utf8_netpath: utf8_netpath,
                                             proxyIpv4Address: proxyNetPath, proxyNetPath: proxyNetPath, proxyPort: proxyPort
                                             }
                  }, state = [sensorid, cache]) do

    newcache =
      case cache[process_guid] do
        nil ->
          IO.puts("Not in cache")
          Map.put(cache, process_guid, [{header, network}]) # FIRST
        update when is_list(update) ->
          IO.puts("In cache")
          Map.put(cache, process_guid, [{header, network} | cache[process_guid]])
        {:cbclientapi, ds} ->
          IO.puts("Data from CBCLIENTAPI already present - just do thy thing...")
          cache
      end
#    IO.puts("IN GENSERVER: sensorid: #{sensorid}") 
#    IO.inspect([process_guid, process_md5,timestamp])
#    IO.inspect([])
    {:noreply, [sensorid, newcache]}
  end





end

#  IN GENSERVER: sensorid: 12
#  %Cbprotobuf.CbHeaderMsg{bootid: nil, eventid: nil, filepath_string_guid: nil,
#                          magic: nil, process_create_time: 130924423273338908,
#                          process_filepath_string_guid: nil, process_guid: 935885800102976795,
#                          process_md5: <<178, 200, 50, 187, 246, 73, 100, 247, 85, 211, 145, 116, 188, 73, 247, 185>>,
#                          process_path: "c:\\program files\\common files\\mcafee\\platform\\mcsvchost\\mcsvhost.exe",
#                          process_pid: 2600, timestamp: 130928367473548810, version: 4}
#  IN GENSERVER: sensorid: 8
#  %Cbprotobuf.CbHeaderMsg{bootid: nil, eventid: nil, filepath_string_guid: nil,
#                          magic: nil, process_create_time: 130928365110000000,
#                          process_filepath_string_guid: nil, process_guid: -6192204534132247860,
#                          process_md5: nil, process_path: nil, process_pid: nil,
#                          timestamp: 130928366129061967, version: 4}



#  IN GENSERVER: sensorid: 12
#  %Cbprotobuf.CbNetConnMsg{guid: nil, ipv4Address: 520202432, ipv6HiPart: nil,
#                           ipv6LoPart: nil, localIpAddress: 100772032, localPort: 63176, outbound: false,
#                           port: 60180, protocol: :ProtoUdp, proxyConnection: false,
#                           proxyIpv4Address: nil, proxyNetPath: nil, proxyPort: nil,
#                           remoteIpAddress: 520202432, remotePort: 60180, utf8_netpath: nil}
#  IN GENSERVER: sensorid: 8
#  %Cbprotobuf.CbNetConnMsg{guid: -4598708342779668009, ipv4Address: 16908804,
#                           ipv6HiPart: nil, ipv6LoPart: nil, localIpAddress: nil, localPort: nil,
#                           outbound: false, port: 13568, protocol: :ProtoUdp, proxyConnection: false,
#                           proxyIpv4Address: nil, proxyNetPath: nil, proxyPort: nil, remoteIpAddress: nil,
#                           remotePort: nil, utf8_netpath: nil}


#  iex(netconn2syslog@198.50.194.115)3> x = %{"foo" => :baz}
#  %{"foo" => :baz}
#  iex(netconn2syslog@198.50.194.115)4> x["foo"]
#  :baz
#  iex(netconn2syslog@198.50.194.115)5> y = "foo"
#  "foo"
#  iex(netconn2syslog@198.50.194.115)6> x[y]
