/*
    by qyvlik
    email:qyvlik@qq.com
*/
import QtQuick 2.4

Image {
    id:playButton;
    signal clicked;
    source:"./pic/rewind_.png";
    MouseArea{
        id:mouse;
        anchors.fill:parent;

        onPressed: playButton.source = "./pic/rewind.png";
        onReleased:  playButton.source = "./pic/rewind_.png";

        hoverEnabled:true;
        onEntered: a.visible = true;
        onExited: a.visible = false;
    }

    Component.onCompleted: mouse.clicked.connect(clicked);
    Rectangle{
        id:a;
        visible:false;
        width: t.width
        height: t.height
        border.color: "black";
        border.width: 1;
        opacity: 0.8;
        z:playButton.z+2
        color:"#fbed90"
        Text{
            id:t;
            text:"rewind"
        }
    }
}

