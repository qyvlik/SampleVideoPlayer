/*
    by qyvlik
    email:qyvlik@qq.com
*/
import QtQuick 2.4
import QtQuick.Controls 1.3
import QtMultimedia 5.4
import QtQuick.Controls.Styles 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

import "./component"

ApplicationWindow {
    id:appWindow;

    width: 600;
    height: 400;
    title: qsTr("Video Player");

    // use the QQmlApplicationEngine class  to load this qml file;
    // the ApplicationWindow's visible must set true;
    visible: true;

    style:ApplicationWindowStyle {
        background:Rectangle{
            width: appWindow.width;
            height: appWindow.height;
            color:"black"
        }
    }


    VideoOutput {
        id: videoOutput;
        source: player;
        anchors.fill: parent;
        property alias totalTime: player.totalTime;

        ErrorDialog{
            player:player;
        }

        MediaPlayer {
            id: player;
            loops:MediaPlayer.Infinite ;

            readonly property int minutes: Math.floor(player.duration / 60000);
            readonly property int seconds: Math.round((player.duration % 60000) / 1000);
            readonly property int hours : (player.duration / 3600000 > 1) ?Math.floor(player.duration / 3600000):0;
            readonly property string totalTime:Qt.formatTime(new Date(0, 0, 0, hours, minutes, seconds), qsTr("hh:mm:ss"));

        }

        readonly property int minutes: Math.floor(player.position / 60000);
        readonly property int seconds: Math.round((player.position % 60000) / 1000);
        readonly property int hours : (player.position / 3600000 > 1) ?Math.floor(player.position / 3600000):0;
        readonly property string positionTime:Qt.formatTime(new Date(0, 0, 0, hours, minutes, seconds), qsTr("hh:mm:ss"));


        MouseArea{
            anchors.fill: parent;
            acceptedButtons: Qt.AllButtons;
            onClicked: {
                if(mouse.button == Qt.LeftButton){
                    player.playbackState == MediaPlayer.PlayingState ? player.pause() : player.play();
                }
                if(mouse.button == Qt.RightButton){
                    menu.open(mouse.x,mouse.y);
                } else {
                    menu.close();
                }

            }
            onWheel:{
                // down
                if(wheel.angleDelta.y < 0) {
                    if(player.volume != 0) player.volume -=0.1;
                } else if(wheel.angleDelta.y > 0){
                    if(player.volume != 1)  player.volume +=0.1;
                }
            }

// 以下是键盘控制
//=============================================================================================
            focus: true;
            Keys.onSpacePressed: player.playbackState == MediaPlayer.PlayingState ? player.pause() : player.play();
            Keys.onLeftPressed: player.seek(player.position - 5000);
            Keys.onRightPressed: player.seek(player.position + 5000);
            Keys.onEscapePressed: appWindow.visibility = Window.Windowed;
            Keys.onReturnPressed: appWindow.visibility =
                                  (appWindow.visibility == Window.FullScreen)?
                                      Window.Windowed:Window.FullScreen;
            Keys.onUpPressed: {
                if(player.volume != 1){
                    player.volume +=0.1;
                }
            }
            Keys.onDownPressed: {
                if(player.volume != 0){
                    player.volume -=0.1;
                }
            }
            Keys.onPressed: {
                // hide bar
                if ((event.key == Qt.Key_H) && (event.modifiers & Qt.ControlModifier)){
                    bar.visible = !bar.visible;
                }

                if (event.key == Qt.Key_H){
                    bar.visible = !bar.visible;
                }
            }
        }
//=============================================================================================

        MouseClickedMenu{
            id:menu;
            Column{
                spacing: 10;
                Rectangle{
                    width: menu.width;
                    height: 20;
                    color:"#fbed90";
                    Text{
                        anchors.centerIn: parent;
                        text:qsTr("隐藏菜单");
                    }
                }
                Text{
                    text:(player.loops < 0)?"在洗脑循环中":"就一次！";
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: (player.loops != -1)?(player.loops = MediaPlayer.Infinite ):(player.loops = 1);
                    }
                }

                Text{
                    text:bar.visible?"隐藏播放栏":"显示播放栏";
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: bar.visible?(bar.visible = false):(bar.visible = true);
                    }
                }
            }
        }

    }


    statusBar:PlayerBar{
        id:bar;
        player:player;
    }
}
