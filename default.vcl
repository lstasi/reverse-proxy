vcl 4.0;

backend servers {
    #.host = "192.168.1.34";
	.host = "servers-api.va.3sca.net";
    .port = "80";
}
backend datacenters {
    #.host = "192.168.1.34";
	.host = "servers-api.va.3sca.net";
    .port = "80";
}

sub vcl_recv {
	if (! req.http.Authorization ~ "Basic M3NjYWxlOnRlc3Q=")
	{
	  return(synth(401, "Authentication required"));
	}
    if (req.http.host == "servers-api.va.3sca.net") {
        set req.backend_hint = servers;
    } elsif (req.http.host == "datacenters-api.va.3sca.net") {
        set req.backend_hint = datacenters;
    }
	if (req.url ~ "^\/servers\/$" ) {
                set req.url = "/servers.json";
        }
	if (req.url ~ "^\/servers\/[0-9]+$" ) {
                set req.url = regsub(req.url, "\/servers\/([0-9]+)$", "/servers/\1.json");
        }
}
sub vcl_backend_response {
  # cache everything for 5 minutes, ignoring any cache headers
  set beresp.ttl = 30m;
}