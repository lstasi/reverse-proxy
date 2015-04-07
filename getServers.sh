#!/bin/bash
set -e
VERBOSE="--silent"
DOCKERSERVER="127.0.0.1"
DOCKERPORT="80"
while getopts ":vs:p:h" opt; do
  case $opt in
    v)
      VERBOSE="--verbose"
      ;;
	s)
      DOCKERSERVER=$OPTARG
      ;;
	p)
      DOCKERPORT=$OPTARG
      ;;
	h)
	  echo "-s DOCKERSERVER ip address"
	  echo "-p DOCKERPORT port" 
      echo "Run getServers.sh -v for verbose"
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
echo "$DOCKERSERVER:$DOCKERPORT"
echo -e "\nLoad DataCenters\n"
curl $VERBOSE -u 3scale:test --header 'Host: datacenters-api.va.3sca.net' "http://$DOCKERSERVER:$DOCKERPORT/datacenters/" -o /tmp/datacenters.json
if [ "$VERBOSE" == "--verbose" ]; then
	jq -r '.[]' /tmp/datacenters.json
fi
dc_id=($(jq -r '.[].id' /tmp/datacenters.json))
dc_name=($(jq -r '.[].name' /tmp/datacenters.json))
dc_servers=($(jq -r '.[].servers' /tmp/datacenters.json))
dc_location=($(jq -r '.[].location' /tmp/datacenters.json))
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
		curl $VERBOSE -u 3scale:test --header 'Host: servers-api.va.3sca.net' "http://$DOCKERSERVER:$DOCKERPORT/servers/$server" -o /tmp/$server.json
		if [ "$VERBOSE" == "--verbose" ]; then
			jq -r '.' /tmp/$server.json
		fi
		srv_code=($(jq -r '.code' /tmp/$server.json))
		if (( "$srv_code"=="1" )); then
			srv_message=($(jq -r '.message' /tmp/$server.json))
			echo -e "Server: Error - ID: $server code: $srv_code message: $srv_message"
		else
			srv_id=($(jq -r '.id' /tmp/$server.json))
			srv_name=($(jq -r '.name' /tmp/$server.json))
			srv_desc=($(jq -r '.description' /tmp/$server.json))
			echo -e "Server: $srv_name: $srv_desc"
		fi
	done
	echo -e "\n\n"
done
