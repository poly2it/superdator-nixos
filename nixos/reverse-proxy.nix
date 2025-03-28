{...}: {
  services.caddy = {
    enable = true;
    email = "eric.thorburn@hitachigymnasiet.se";
    virtualHosts = {
      "superdator.spetsen.net" = {
        extraConfig = ''
          respond "Should be a fancy superdator landing page"
        '';
      };
      "ctf.spetsen.net" = {
        extraConfig = ''
                 reverse_proxy 127.0.0.1:3333 {
                   header_up X-Forwarded-For {remote_host}
                   header_up X-Forwarded-Proto {scheme}
                   header_up Host {host}
                   header_up X-Forwarded-Host {host}
                   header_up Upgrade {upstream_upgrade}
                   header_up Connection {upstream_connection}
          }
        '';
      };
      "jupyter.superdator.spetsen.net" = {
        extraConfig = ''
                 forward_auth 127.0.0.1:9091 {
                   uri /api/authz/forward-auth
                   copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
                 }
          reverse_proxy 127.0.0.1:8000
        '';
      };
      "chat.superdator.spetsen.net" = {
        extraConfig = ''
          forward_auth 127.0.0.1:9091 {
                    uri /api/authz/forward-auth
                    copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
          }
                 # reverse_proxy 127.0.0.1:9999
          respond "Disabled"

        '';
      };
      "auth.superdator.spetsen.net" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:9091
        '';
      };
      "justcount-pb.superdator.spetsen.net" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8092
        '';
      };
      "boka.spetsen.net" = {
        extraConfig = ''
                  @websockets {
                    header Connection *Upgrade*
                    header Upgrade    websocket
                  }
          reverse_proxy @websockets 127.0.0.1:5001
          reverse_proxy 127.0.0.1:5000
        '';
      };
    };
  };
}
