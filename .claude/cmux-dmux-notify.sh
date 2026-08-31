#!/usr/bin/env bash
# cmux <- dmux notification bridge (wired into Claude Code Notification/Stop hooks).
#
# Fires a cmux notification ONLY inside a dmux pane that lives inside cmux -- the
# situation where cmux's own `claude` wrapper does NOT engage: CMUX_SURFACE_ID is
# not propagated through the tmux server, and `claude` resolves to the real
# binary, not the wrapper. Elsewhere it is a silent no-op, so it never
# double-fires against the wrapper in normal cmux surfaces and never errors in
# plain terminals.
#
# Requires cmux's automation.socketControlMode to allow external notifications
# (e.g. "notifications"); the default "cmuxOnly" rejects dmux panes with a
# Broken pipe. See ~/.config/cmux/cmux.json.
set -uo pipefail

[ -n "${DMUX_PANE_ID:-}" ]      || exit 0   # only inside a dmux pane
[ -n "${CMUX_SOCKET_PATH:-}" ]  || exit 0   # only when cmux is reachable
[ -n "${CMUX_WORKSPACE_ID:-}" ] || exit 0   # need a target tab/workspace
command -v cmux >/dev/null 2>&1 || exit 0

event="${1:-notification}"   # "notification" | "stop"

# Claude Code pipes the hook event JSON on stdin; `cmux claude-hook` reads it.
# This is the same path cmux's own claude wrapper uses in normal surfaces, so it
# gets cmux's focus suppression, cooldown, and sidebar state. Per-pane surface
# attribution isn't available (all dmux panes share one cmux surface), so we
# target the cmux workspace/tab that runs dmux.
cmux claude-hook "$event" --workspace "$CMUX_WORKSPACE_ID" >/dev/null 2>&1 || true
exit 0
