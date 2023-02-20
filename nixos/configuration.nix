{ inputs, lib, config, pkgs, ... }: {
    imports = [
        ./nix.nix
        ./ld-so.nix
        ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "noahc-nas";
    networking.networkmanager.enable = true;

    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";

    users.users = {
        noahc = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOSouCHA4MKB9h3dmCfDexF74z2Yxu8xQD144zClmTcx noahc@noahc-desktop-arch"
            ];
        };
    };

    security.sudo.extraRules = [
        { users = ["noahc"]; commands = [{ command = "ALL"; options = ["NOPASSWD"]; }]; }
    ];

    environment.systemPackages = with pkgs; [
        git
    ];

    services.openssh.enable = true;
    services.openssh.permitRootLogin = "no";
    services.openssh.passwordAuthentication = false;

    services.avahi.enable = true;
    services.avahi.publish = {
        enable = true;
        addresses = true;
        workstation = true;
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    system.stateVersion = "22.11";
}
