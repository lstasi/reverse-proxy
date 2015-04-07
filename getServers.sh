#!/bin/bash
set -e
VERBOSE="--silent"
while getopts ":v:h" opt; do
  case $opt in
    v)
      VERBOSE="--verbose"
      ;;
	h)
      echo "Run getServers.sh -v for verbose" >&2
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

echo -e "\nLoad DataCenters\n"
curl $VERBOSE -u 3scale:test --header 'Host: datacenters-api.va.3sca.net' 'http://127.0.0.1:80/datacenters/' -o temp/datacenters.json

dc_id=($(jq -r '.[].id' temp/datacenters.json))
dc_name=($(jq -r '.[].name' temp/datacenters.json))
dc_servers=($(jq -r '.[].servers' temp/datacenters.json))
dc_location=($(jq -r '.[].location' temp/datacenters.json))
total=${#dc_id[*]}

echo "Total DataCenters : ${#dc_id[*]}"
for (( i=0; i<=$(( $total -1 )); i++ ))
do
    echo -e "DataCenter Name: ${dc_name[$i]} - id: ${dc_id[$i]} loc: ${dc_location[$i]}\n "
	echo -e "Servers:\n"
	IFS=","
	server_list="${dc_servers[$i]}"
	for server in $server_list
	do
		curl $VERBOSE -u 3scale:test --header 'Host: servers-api.va.3sca.net' "http://127.0.0.1:80/servers/$server" -o temp/$server.json
		srv_code=($(jq -r '.code' temp/$server.json))
		if (( "$srv_code"=="1" )); then
			srv_message=($(jq -r '.message' temp/$server.json))
			echo -e "Server: Error - ID: $server code: $srv_code message: $srv_message"
		else
			srv_id=($(jq -r '.id' temp/$server.json))
			srv_name=($(jq -r '.name' temp/$server.json))
			srv_desc=($(jq -r '.description' temp/$server.json))
			echo -e "Server: $srv_name: $srv_desc"
		fi
	done
	echo -e "\n\n"
done
