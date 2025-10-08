#!/bin/sh
set -eu

# Detect host tools
HOST_GPG="$(command -v gpg || true)"
[ -z "$HOST_GPG" ] && { echo "gpg not found on PATH"; exit 1; }

# Ensure pinentry exists on host; prefer GNOME
PINENTRY="/usr/bin/pinentry-gnome3"
[ -x "$PINENTRY" ] || PINENTRY="/usr/bin/pinentry"
[ -x "$PINENTRY" ] || PINENTRY="/usr/bin/pinentry-curses"

# Configure ~/.gnupg on host
GPGDIR="$HOME/.gnupg"
mkdir -p "$GPGDIR" && chmod 700 "$GPGDIR"

# gpg.conf: crypto prefs only
cat >"$GPGDIR/gpg.conf" <<'EOF'
personal-cipher-preferences AES256
personal-digest-preferences SHA512
personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
keyid-format 0xlong
charset utf-8
EOF
chmod 600 "$GPGDIR/gpg.conf"

# gpg-agent.conf: pinentry and loopback allowance
{
  echo "default-cache-ttl 600"
  echo "max-cache-ttl 7200"
  [ -x "$PINENTRY" ] && echo "pinentry-program $PINENTRY"
  echo "enable-ssh-support"
  echo "allow-loopback-pinentry"
} >"$GPGDIR/gpg-agent.conf"
chmod 600 "$GPGDIR/gpg-agent.conf"

# TTY binding helps loopback and some terminals
grep -q 'GPG_TTY=' "$HOME/.profile" 2>/dev/null || echo 'export GPG_TTY=$(tty)' >> "$HOME/.profile"
export GPG_TTY=$(tty || echo "")

# Restart agent
gpgconf --kill gpg-agent || true
gpgconf --launch gpg-agent || true

# If running inside a Flatpak, wire git to the host gpg via flatpak-spawn
if command -v flatpak-spawn >/dev/null 2>&1; then
  # Primary: host gpg with normal pinentry
  git config --global gpg.program "flatpak-spawn --host gpg"

  # Probe pinentry path through a sign test; if it fails, switch to loopback
  if ! printf '%s' test | flatpak-spawn --host gpg --clearsign >/dev/null 2>&1; then
    git config --global gpg.program "flatpak-spawn --host gpg --pinentry-mode=loopback"
  fi

  # Permit access to agent sockets for this user (helps some Flatpaks)
  flatpak override --user --filesystem=xdg-run/gnupg || true
else
  # Non-Flatpak shells: ensure gpg works; if pinentry is blocked, use loopback
  if ! printf '%s' test | gpg --clearsign >/dev/null 2>&1; then
    git config --global gpg.program "gpg --pinentry-mode=loopback"
  fi
fi

# Final sanity check using whatever git is configured to run
if git config --global --get gpg.program >/dev/null 2>&1; then
  GPG_PROG=$(git config --global --get gpg.program)
else
  GPG_PROG="gpg"
fi
printf '%s' test | sh -c "$GPG_PROG --clearsign" >/dev/null 2>&1 && echo "OK: signing available" || {
  echo "ERROR: signing still blocked"; exit 2; }

