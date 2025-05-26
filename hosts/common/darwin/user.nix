{ ... }:

/*
  Failed assertions:
  - Previously, some nix-darwin options applied to the user running
  `darwin-rebuild`. As part of a long‐term migration to make
  nix-darwin focus on system‐wide activation and support first‐class
  multi‐user setups, all system activation now runs as `root`, and
  these options instead apply to the `system.primaryUser` user.

  You currently have the following primary‐user‐requiring options set:

  * `homebrew.enable`
  * `services.jankyborders.enable`
  * `services.skhd.enable`
  * `services.yabai.enable`
  * `system.defaults.NSGlobalDomain.AppleInterfaceStyle`
  * `system.defaults.NSGlobalDomain.InitialKeyRepeat`
  * `system.defaults.NSGlobalDomain.KeyRepeat`
  * `system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled`
  * `system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled`
  * `system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled`
  * `system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled`
  * `system.defaults.dock.autohide`
  * `system.defaults.dock.mru-spaces`
  * `system.defaults.spaces.spans-displays`

  To continue using these options, set `system.primaryUser` to the name
  of the user you have been using to run `darwin-rebuild`. In the long
  run, this setting will be deprecated and removed after all the
  functionality it is relevant for has been adjusted to allow
  specifying the relevant user separately, moved under the
  `users.users.*` namespace, or migrated to Home Manager.
*/
{
  system.primaryUser = "mark";
}
