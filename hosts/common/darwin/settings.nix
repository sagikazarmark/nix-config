{ ... }:

{
  # Set keyboard speed
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;

  # Enable dark mode
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";

  # Automatically hide and show the Dock
  system.defaults.dock.autohide = true;

  # Disable automatic rearrange of spaces
  system.defaults.dock.mru-spaces = false;

  # Displays have separate spaces
  system.defaults.spaces.spans-displays = false;

  # Smart settings
  # https://derflounder.wordpress.com/2014/02/01/disabling-smart-quotes-in-mavericks/
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
}
