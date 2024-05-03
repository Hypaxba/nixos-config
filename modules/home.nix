{ pkgs, ...}: {
   home.username = "baptiste";
   home.homeDirectory = "/home/baptiste";
   home.stateVersion = "23.11";
   programs.home-manager.enable = true;
   
   home.packages = with pkgs; [
   ];
   
   programs.git = {
     enable = true;
     userEmail = "baptiste@forge.epita.fr";
     userName = "Baptiste Fontaine";
     signing = {
       key = "0F52C374F0E6FA6BE68140D0A6A2FCF37E96351E";
       signByDefault = true;
     };
   };
  
   programs.direnv = {
     nix-direnv.enable = true;
     enableZshIntegration = true;
   };


   programs.zsh = {
     enable = true;
     enableAutosuggestions = true;
     shellAliases = {
       ll = "ls -l";
       update = "sudo nixos-rebuild switch";
       k = "kubectl";
     };
     history = {
        expireDuplicatesFirst = true;
        save = 100000000;
        size = 1000000000;
      };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "history" ];
      theme = "robbyrussell";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
          "$mod" = "SUPER";
    bind =
      [
        "$mod, F, exec, firefox"
        ", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      ); 
    };
  };
}  
