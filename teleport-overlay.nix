self: super:

let
  newVersion = "v12.4.34";
in
{
  teleport = super.teleport.overrideAttrs (oldAttrs: rec {
    version = newVersion;
  });
}

