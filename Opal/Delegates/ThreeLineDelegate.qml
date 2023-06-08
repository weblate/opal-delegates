/*
SPDX-FileCopyrightText: 2023 Peter G. (nephros)
SPDX-License-Identifier: Apache-2.0
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

/*! \qmltype ThreeLineDelegate
    \inqmlmodule Opal.Delegates
    \inherits Sailfish.Silica.ListItem

    Layout:

    |------------------------------------------|
    | left | line1, normal, highlight, fade
    | item | line2, small, secondary, wrap
    |      | line3, small, secondary, fade
    |------------------------------------------|

*/


ListItem { id: root

    /*! \qmlproperty string title
     *
     * the first line of text.
     *
     * formatted as highlighted color, normal font size.
     * the text will fade if too long
     */

    /*! \qmlproperty string text
     *
     * the second line of text.
     *
     * formatted as secondary color, small font size.
     * the text will wrap if too long
     */

    /*! \qmlproperty string context
     *
     * the third line of text.
     *
     * formatted as secondary color, small font size.
     * the text will fade if too long
     *
     */
    /*! \qmlproperty string extratext
     *
     * an optional smaller text to the right of the first line (such as "online" for a user)
     */
    property alias title:   line1.text
    property alias text:    line2.text
    property alias context: line3.text
    property alias extratext: extra.text

    /*! \qmlproperty Component leftItem
     *
     * an Item such as an Icon displayed on the left side of the Delegate
     *
     */
    property Component leftItem: null

    /*! \qmlproperty bool showOddEven
     *
     * if \c true delegates will use alternating colors
     *
     * \default false
     */
    property bool showOddEven: false
    property bool isOdd: (index %2 != 0)
    property color oddColor: "transparent"
    property color evenColor: Theme.highlightBackgroundColor
    Rectangle { id: oddevenrect
        anchors.fill: parent
        radius: Theme.paddingSmall
        opacity: 0.2
        color: showOddEven ?
                    isOdd ? oddColor : evenColor
            : "transparent"
        border.color: "transparent"
        border.width: radius/2
    }

    /*! \qmlproperty var colors
     * An array of three \c color values, overriding the defaults.
     */
    /*! \qmlproperty var sizes
     * An array of three \c int values specifying font size, overriding the defaults.
     */
    property var colors: []

    property bool amThreeLine: true

    Component.onCompleted: {
        var num = amThreeLine ? 3 : 2
        if ( !!colors && colors.length === num) {
            line1.color = colors[0];
            line2.color = colors[1];
            if (amThreeLine)
                line3.color = colors[2];
        }
    }

    QtObject{ id: line1; property string text: ""; property color color: Theme.highlightColor; property int size: Theme.fontSizeMedium }
    QtObject{ id: line2; property string text: ""; property color color: Theme.secondaryColor; property int size: Theme.fontSizeSmall }
    QtObject{ id: line3; property string text: ""; property color color: Theme.secondaryColor; property int size: Theme.fontSizeTiny }
    QtObject{ id: extra; property string text: ""; property color color: Theme.primaryColor; property int size: Theme.fontSizeTiny }

    contentHeight: content.height
    Loader { id: leftItemLoader
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        active: leftItem !== null
        sourceComponent: leftItem
        width: height
    }
    Column { id: content
        anchors.left: leftItemLoader.right
        anchors.right: parent.right
        anchors.verticalCenter: (leftItemLoader.height > 0) ? leftItemLoader.verticalCenter : parent.verticalCenter
        Row {
            width: parent.width
            spacing: Theme.paddingMedium
            Label { id: label1
                width: (implicitWidth > parent.width - extraLabel.width) ? parent.width*2/3 : implicitWidth
                //anchors.verticalCenter: parent.verticalCenter
                text: line1.text;
                color:          !!line1.color ? line1.color : Theme.highlightColor;
                font.pixelSize: !!line1.size  ? line1.size  : Theme.fontSizeNormal;
                wrapMode:       Text.NoWrap
                truncationMode: TruncationMode.Fade

            }
            Label { id: extraLabel
                anchors.bottom: label1.bottom
                text: extra.text;
                color:          !!extra.color ? extra.color : Theme.primaryColor;
                font.pixelSize: !!extra.size  ? extra.size  : Theme.fontSizeNormal;
                wrapMode:       Text.NoWrap
                truncationMode: TruncationMode.Fade

            }
        }
        Label {
            width: parent.width
            text: line2.text;
            color:          !!line2.color ? line2.color : Theme.secondaryColor;
            font.pixelSize: !!line2.size  ? line2.size  : Theme.fontSizeSmall;
            wrapMode:       Text.Wrap

        }
        Label {
            visible: amThreeLine
            width: parent.width
            text: line3.text;
            color:          !!line3.color ? line3.color : Theme.secondaryColor;
            font.pixelSize: !!line3.size  ? line3.size  : Theme.fontSizeSmall;
            wrapMode:       Text.NoWrap
            truncationMode: TruncationMode.Fade
        }
    }
}
