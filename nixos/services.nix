{
  pkgs,
  lib,
  ...
}: {
  services.openssh = {
    allowSFTP = true;
    enable = true;
    openFirewall = lib.mkForce true;
    settings = {
      AllowGroups = ["ssh-access"];
      PasswordAuthentication = true;
      PermitRootLogin = lib.mkForce "no";
      X11Forwarding = false;
    };
  };

  services.cockpit = {
    enable = true;
    openFirewall = true;
  };

  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    port = 11434;
    acceleration = "cuda";
  };

  /*
    services.open-webui = {
    enable = true;
    port = 9999;
    host = "127.0.0.1";
    environment = {
      ENV = "prod";
      WEBUI_NAME = "Spetsens LLM-chatt";
      WEBUI_AUTH = "False"; # TODO: change to something more secure, e.g. OIDC w/ authelia
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    };
  };
  */

  # TODO: fix jupyterhub

  services.jupyterhub = {
    enable = true;
    authentication = "jupyterhub.auth.PAMAuthenticator";
    extraConfig = ''
      c.Authenticator.allowed_users = set(["erre", "malte"])
    '';
    kernels = {
      torch = let
        env = pkgs.python311.withPackages (pythonPackages:
          with pythonPackages; [
            pip

            # Base for the kernel
            ipykernel

            # Useful utilities
            beautifulsoup4 # Web scraping
            matplotlib # Graphs
            numpy # Of course
            pandas # CSV files
            pillow # Images
            requests # Make API requests
            scipy # Superset of numpy
            torch # PyTorch
            torchaudio
            torchvision
          ]);
      in {
        displayName = "Machine learning kernel (PyTorch)";
        argv = [
          "${env.interpreter}"
          "-m"
          "ipykernel_launcher"
          "-f"
          "{connection_file}"
        ];
        language = "python";
        logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
        logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
      };
    };
  };
}
