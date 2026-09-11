import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

// Per-monitor workspaces: each bar shows only the workspaces living on its own
// monitor, and marks the one that monitor is showing, focused or not.
// Cloned from omarchy.workspaces, which shows 1–5 plus any others on every bar.
BarWidget {
  id: root
  moduleName: "io.github.dariobf.per-display-workspaces"

  // The Hyprland monitor this bar copy is drawn on. Null for the zero-size
  // placeholder the bar keeps for anchored center modules; that one shows all.
  readonly property var monitor: {
    var window = root.QsWindow.window
    return window && window.screen ? Hyprland.monitorFor(window.screen) : null
  }

  function onThisMonitor(workspace) {
    if (!root.monitor) return true
    return workspace.monitor !== null && workspace.monitor.name === root.monitor.name
  }

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  function workspaceIds() {
    var ids = []
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      var id = values[i].id
      if (id > 0 && id <= 10 && root.onThisMonitor(values[i])) ids.push(id)
    }

    ids.sort(function(left, right) { return left - right })
    return ids
  }

  function isShown(id) {
    if (!root.monitor) return Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === id
    return root.monitor.activeWorkspace !== null && root.monitor.activeWorkspace.id === id
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  readonly property var ids: workspaceIds()
  readonly property real trailingGap: root.vertical || ids.length === 0 ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : Math.max(1, root.ids.length)
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.ids

      WidgetButton {
        required property int modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool shown: root.isShown(modelData)

        bar: root.bar
        text: shown ? "󱓻" : (modelData === 10 ? "0" : String(modelData))
        opacity: occupied || shown ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }
      }
    }
  }
}
