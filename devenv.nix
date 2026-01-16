{ pkgs, lib, ... }:

{
  name = "clipse";

  dotenv.enable = true;

  # Go development packages
  packages = with pkgs; [
    # Go toolchain
    go
    gopls
    golangci-lint
    delve

    # Build tools
    gnumake
    gcc
    pkg-config

    # Wayland dependencies for testing
    wl-clipboard

    # Development utilities
    git
    jq
  ];

  languages.go = {
    enable = true;
    package = pkgs.go;
  };

  env = {
    CGO_ENABLED = "1";
  };

  scripts = {
    build.exec = ''
      echo "Building clipse..."
      go build -o clipse .
    '';

    build-wayland.exec = ''
      echo "Building clipse with wayland tag..."
      go build -tags wayland -o clipse .
    '';

    run-listen.exec = ''
      echo "Running clipse listener..."
      ./clipse --listen-shell
    '';

    test.exec = ''
      echo "Running tests..."
      go test ./...
    '';

    lint.exec = ''
      echo "Running linter..."
      golangci-lint run
    '';

    install-local.exec = ''
      echo "Installing to ~/.local/bin..."
      mkdir -p ~/.local/bin
      cp clipse ~/.local/bin/
    '';
  };
}
