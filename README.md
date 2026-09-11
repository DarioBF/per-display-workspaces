# Per-display Workspaces

An [Omarchy](https://omarchy.org/) bar widget that gives every monitor its own
workspace list. Each bar shows only the workspaces that live on its monitor
and marks the one that monitor is currently showing.

![Per-display Workspaces on a three-monitor setup](preview.png)

The built-in Workspaces widget draws the same list on every bar: workspaces
1–5 plus any others that exist, with only the globally focused one marked. On
a multi-monitor desk that makes it hard to tell which workspaces are where.

## Features

- **Per monitor:** each bar lists only the workspaces on its own monitor.
- **Shown workspace marked on every bar:** the ■ follows what each monitor is
  displaying, not just the focused monitor.
- **Live:** when workspaces move between monitors (moving a workspace,
  plugging in a display, closing the lid in clamshell mode, workspace rules
  changing), every bar updates immediately.
- **No Hyprland changes:** it only reads where your workspaces already are, so
  it works with whatever assignment you use: `hl.workspace_rule`, scripts,
  or moving workspaces by hand. No keybindings or config are touched.
- **Drop-in:** enabling it takes the built-in Workspaces widget's place on the
  bar; removing it puts the built-in one back.

Workspaces with windows are bright, empty ones are dimmed, and clicking a
number switches to it, just like the built-in widget. Workspaces 1–10 are
shown; special workspaces (scratchpad) are not.

## Requirements

- Omarchy 4 (Quattro) with the Omarchy shell bar.
- No other dependencies.

## Install

```bash
omarchy plugin add https://github.com/DarioBF/per-display-workspaces --enable
```

The widget takes the built-in Workspaces widget's place and settings. Run from
a terminal, the installer asks which bar section to put it in (left by
default). Move it later like any other widget:

```bash
omarchy bar move io.github.dariobf.per-display-workspaces --section center --index 0
```

## Remove

```bash
omarchy plugin remove io.github.dariobf.per-display-workspaces
```

This deletes the plugin folder (Omarchy keeps a backup) and restores the
built-in Workspaces widget where this one was.

## Development

The widget is a single file, `Workspaces.qml`. After editing an installed
copy, run `omarchy restart shell` to load the change.

## License

[MIT](LICENSE)
