{ ... }:

{
  # TODO: use linking instead of copying?
  system.activationScripts.extraActivation.text = ''
    echo "setting up keyboard layouts..." >&2

    $DRY_RUN_CMD cp -r $VERBOSE_ARG ${./Hungarian_Win.keylayout} "/Library/Keyboard Layouts/Hungarian_Win.keylayout"
    $DRY_RUN_CMD cp -r $VERBOSE_ARG ${./Hungarian_Win_v2.keylayout} "/Library/Keyboard Layouts/Hungarian_Win_v2.keylayout"

    touch "/Library/Keyboard Layouts"
  '';
}
