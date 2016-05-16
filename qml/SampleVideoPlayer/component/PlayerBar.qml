/*
    by qyvlik
    email:qyvlik@qq.com
*/
import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.3
import QtMultimedia 5.4

import "../VideoButton" as VB;


/*
播放栏，放着播放控制按钮
进度栏等
*/
Rectangle{

    id:toolBar;
    property variant player;
    anchors{
        left:parent.left;
        right:parent.right;
    }
    height: 40;
    color: "#5c5858"

    Slider {
        id:temp;
        anchors{
            left: toolBar.left;
            right: toolBar.right;
            leftMargin:toolBar.height*r.children.length;
            verticalCenter: toolBar.verticalCenter;
            rightMargin: toolBar.height*1.2;
        }

        property bool sync: false
        maximumValue: player.duration;
        onValueChanged: {
            if(!sync)
                player.seek(value);
        }
        style: SliderStyle {
            groove: Rectangle {
                implicitWidth: parent.width;
                implicitHeight: 8
                color: "gray"
                radius: 8
            }
            // control : Slider read-only
            handle: Rectangle {
                anchors.centerIn: parent
                color: control.pressed ? "white" : "lightgray"
                border.color: "gray"
                border.width: 2
                implicitWidth: toolBar.height*0.4
                implicitHeight: toolBar.height*0.4
                radius:toolBar.height*0.2
            }
        }
        Connections {
            target: player
            onPositionChanged: {
                temp.sync = true
                temp.value = player.position
                temp.sync = false
            }
        }
    }

    Label {
        // position time;
        width: toolBar.height*1.2;
        height: toolBar.height;
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
        anchors.right: toolBar.right;
        font.pointSize: toolBar.height / 5;
        color:"white";

        // 21 May 2001 14:13:09
        //var dateTime = new Date(2001, 5, 21, 14, 13, 09);

        readonly property int minutes: Math.floor(player.position / 60000);
        readonly property int seconds: Math.round((player.position % 60000) / 1000);
        readonly property int hours : (player.position / 3600000 > 1) ?Math.floor(player.position / 3600000):0;

        text: Qt.formatTime(new Date(0, 0, 0, hours, minutes, seconds), qsTr("hh:mm:ss"));
    }


    Row{
        id:r
        anchors.verticalCenter: toolBar.verticalCenter;

        VB.MenuButton{
            // menu
            width: toolBar.height;
            height: toolBar.height;
            onClicked:{
                about.open();
            }
        }

        VB.OpenFileButton{
            // open File
            width: toolBar.height;
            height: toolBar.height;
            onClicked: fileDialog.open();
        }

        VB.RewindButton{
            // 快退
            width: toolBar.height;
            height: toolBar.height;
            onClicked: { player.seek(player.position - 5000); }
        }

        VB.PlayOrPauseButton{
            // play or pause
            id:p_o_p;
            width: toolBar.height;
            height: toolBar.height;
            onClicked: {
                player.playbackState == MediaPlayer.PlayingState ? player.pause() : player.play();
            }
            Connections{
                target:player;
                onPlaybackStateChanged:{
                    switch(player.playbackState)
                    {
                    case   MediaPlayer.PlayingState:
                        //console.debug("PlayingState");
                        p_o_p.doItPlay = true;
                        break;

                    case   MediaPlayer.PausedState:
                        //console.debug("PausedState");
                        p_o_p.doItPlay = false;
                        break;

                    case   MediaPlayer.StoppedState:
                        //console.debug("StoppedState");
                        p_o_p.doItPlay = false;
                        break;
                    }
                }
            }
        }

        VB.StopButton{
            width: toolBar.height;
            height: toolBar.height;
            onClicked: { player.stop(); }
        }

        VB.SpeedButton{
            id:speed;
            width: toolBar.height;
            height: toolBar.height;
            onClicked: {player.seek(player.position + 5000);}
        }

        Label {
            // tool time;
            width: toolBar.height*1.2;
            height: toolBar.height;
            horizontalAlignment: Text.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;
            color:"white";

            // 21 May 2001 14:13:09
            //var dateTime = new Date(2001, 5, 21, 14, 13, 09)

            readonly property int minutes: Math.floor(player.duration / 60000);
            readonly property int seconds: Math.round((player.duration % 60000) / 1000);
            readonly property int hours : (player.duration / 3600000 > 1) ?Math.floor(player.duration / 3600000):0;

            text: Qt.formatTime(new Date(0, 0, 0, hours, minutes, seconds), qsTr("hh:mm:ss"));

        }

    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file";
        onAccepted: {
            player.source = fileDialog.fileUrl;
            player.play();
        }
        //onRejected: {console.log("Canceled");}
    }

    MessageDialog {
        id: about
        title: "how to use"
        text:
"功能:
    1.打开文件
    2.播放 暂停
    3.错误信息提示
    4.鼠标菜单 移动隐藏 可拖拽
    5.全屏
    6.隐藏播放栏
    7.时间显示
    8.播放模式一次或者无限循环
    9.快捷键:
        ctrl+H : 隐藏播放栏
        空格键 : 暂停/播放
        回车键 : 全屏/正常窗口
        esc : 退出全屏
        → : 快进
        ← : 快退
        ↓ : 声音加
        ↑ : 声音减
菜单可以用鼠标拖拽，点击菜单空白处隐藏，单击鼠标右键可以显示菜单

"
        onAccepted: {
            about.close();
        }
    }

}

