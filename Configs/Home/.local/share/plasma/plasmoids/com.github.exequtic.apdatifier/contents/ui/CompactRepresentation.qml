/*
    SPDX-FileCopyrightText: 2024 Evgeny Kazantsev <exequtic@gmail.com>
    SPDX-License-Identifier: MIT
*/

import QtQuick
import QtQuick.Controls

import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

import "../tools/tools.js" as JS

Item {
    Kirigami.Icon {
        id: icon
        anchors.fill: parent
        source: JS.setIcon(plasmoid.icon)
        active: mouseArea.containsMouse

        Rectangle {
            id: frame
            anchors.centerIn: parent
            width: JS.setFrameSize()
            height: width * 0.9
            opacity: 0
            visible: cfg.indicatorUpdates && !busy && plasmoid.location !== PlasmaCore.Types.Floating
        }

        Rectangle {
            id: circle
            width: frame.width / 3.7
            height: width
            radius: width / 2
            visible: frame.visible && cfg.indicatorCircle && (error || count)
            color: error ? Kirigami.Theme.negativeTextColor
                 : cfg.indicatorColor ? cfg.indicatorColor
                 : Kirigami.Theme.highlightColor

            anchors {
                top: JS.setAnchor("top")
                bottom: JS.setAnchor("bottom")
                right: JS.setAnchor("right")
                left: JS.setAnchor("left")
            }
        }

        Rectangle {
            id: counterFrame
            width: counter.width + frame.width / 8
            height: cfg.indicatorScale ? frame.width / 3 : counter.height
            radius: width * 0.35
            color: Kirigami.Theme.backgroundColor
            opacity: 0.9
            visible: frame.visible && cfg.indicatorCounter

            Label {
                id: counter
                anchors.centerIn: parent
                text: error ? "🛇" : (count || "✔")
                renderType: Text.NativeRendering
                font.bold: true
                font.pointSize: cfg.indicatorScale ? frame.width / 5 : Kirigami.Theme.smallFont.pointSize
                color: error ? Kirigami.Theme.negativeTextColor
                     : !count ? Kirigami.Theme.positiveTextColor
                     : Kirigami.Theme.textColor
            }

            anchors {
                top: JS.setAnchor("top")
                bottom: JS.setAnchor("bottom")
                right: JS.setAnchor("right")
                left: JS.setAnchor("left")
            }
        }

        Rectangle {
            id: intervalStopped
            height: stop.height
            width: height
            radius: width / 2
            color: counterFrame.color
            opacity: counterFrame.opacity
            visible: frame.visible && !cfg.interval && cfg.indicatorStop

            Label {
                id: stop
                anchors.centerIn: parent
                text: "⏸"
                renderType: Text.NativeRendering
                font.pointSize: cfg.indicatorScale ? frame.width / 5 : Kirigami.Theme.smallFont.pointSize
                color: Kirigami.Theme.neutralTextColor
            }

            anchors {
                top: JS.setAnchor("top", 1)
                bottom: JS.setAnchor("bottom", 1)
                right: JS.setAnchor("right", 1)
                left: JS.setAnchor("left", 1)
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: cfg.rightClick ? Qt.AllButtons : Qt.LeftButton | Qt.MiddleButton
        hoverEnabled: true
        property bool wasExpanded: false
        onPressed: wasExpanded = expanded
        onClicked: (mouse) => {
            if (mouse.button == Qt.LeftButton) expanded = !wasExpanded
            if (mouse.button == Qt.MiddleButton && cfg.middleClick) JS[cfg.middleClick]()
            if (mouse.button == Qt.RightButton && cfg.rightClick) JS[cfg.rightClick]()
        }
        onEntered: {
            lastCheck = JS.getLastCheck()
        }
    }
}
