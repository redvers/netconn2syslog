defmodule Netconn2syslog.Cb2recv do
  def callback({:"basic.consume_ok", tag}) do
    IO.puts("Registered with tag: #{tag}")
  end

  def callback({
        {:"basic.deliver", tag, serial, _, "api.events", "ingress.event.netconn"},
        {:amqp_msg, {:P_basic, "application/protobuf",_,_,_,_,_,_,_,_,_,_,_,_,_}, payload}}) do
    %Cbprotobuf.CbEventMsg{env: %Cbprotobuf.CbEnvironmentMsg{
                                  endpoint: %Cbprotobuf.CbEndpointEnvironmentMsg{SensorId: sensorid}
                                },
                           header: header, network: network
                          } = Cbprotobuf.CbEventMsg.decode(payload)
    Netconn2syslog.Sensor.recv_netconn(sensorid, header, network)
  end
  def callback({
        {:"basic.deliver", tag, serial, _, "api.events", "ingress.event.process"},
        {:amqp_msg, {:P_basic, "application/protobuf",_,_,_,_,_,_,_,_,_,_,_,_,_}, payload}}) do
    Cbprotobuf.CbEventMsg.decode(payload)
    |> IO.inspect
    IO.puts("FSCKING PROCESS MOFO #{serial}")
  end

  def callback("foo") do
    IO.puts("DING")
  end
end

#%Cbprotobuf.CbEventMsg{blocked: nil, childproc: nil, crossproc: nil, emet: nil,
# env: %Cbprotobuf.CbEnvironmentMsg{endpoint: %Cbprotobuf.CbEndpointEnvironmentMsg{HostId: 0,
#   SensorHostName: "LENOVO-PC", SensorId: 12},
#  server: %Cbprotobuf.CbServerEnvironmentMsg{NodeId: 0}}, filemod: nil,
# header: %Cbprotobuf.CbHeaderMsg{bootid: nil, eventid: nil,
#  filepath_string_guid: nil, magic: nil,
#  process_create_time: 130924423273338908, process_filepath_string_guid: nil,
#  process_guid: 935885800102976795,
#  process_md5: <<178, 200, 50, 187, 246, 73, 100, 247, 85, 211, 145, 116, 188, 73, 247, 185>>,
#  process_path: "c:\\program files\\common files\\mcafee\\platform\\mcsvchost\\mcsvhost.exe",
#  process_pid: 2600, timestamp: 130928321692504593, version: 4}, modload: nil,
# module: nil, netconnBlocked: nil,
# network: %Cbprotobuf.CbNetConnMsg{guid: nil, ipv4Address: 520202432,
#  ipv6HiPart: nil, ipv6LoPart: nil, localIpAddress: 100772032, localPort: 40922,
#  outbound: false, port: 60180, protocol: :ProtoUdp, proxyConnection: false,
#  proxyIpv4Address: nil, proxyNetPath: nil, proxyPort: nil,
#  remoteIpAddress: 520202432, remotePort: 60180, utf8_netpath: nil},
# process: nil, regmod: nil, stats: nil, strings: [], tamperAlert: nil,
# vtload: nil, vtwrite: nil}
