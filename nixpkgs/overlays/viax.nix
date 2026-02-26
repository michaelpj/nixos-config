self: super:
{
  viax = super.writeShellApplication {
    name = "viax";
    runtimeInputs = [ super.tmux super.python3 ];
    text = ''exec python3 ${./viax/viax.py} "$@"'';
  };
}
