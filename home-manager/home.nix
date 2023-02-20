{ inputs, lib, config, pkgs, ... }: {
    imports = [];

    nixpkgs.config.allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    nixpkgs.config.allowUnfreePredicate = (_: true);

    home = {
        username = "noahc";
        homeDirectory = "/home/noahc";
    };

    # home.packages = with pkgs; [  ];

    # Enable home-manager
    programs.home-manager.enable = true;

    programs.git = {
        enable = true;
        userName = "Noah Craig";
        userEmail = "noahcraig123@gmail.com";
    };

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "22.11";
}
