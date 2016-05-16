/*
    by qyvlik
    email:qyvlik@qq.com
*/
import QtQuick 2.4

Image {
    id:playButton;
    signal clicked;

    source:"./pic/play_.png";

    // have not play
    property bool doItPlay: false;

    property url __sourcePressed: doItPlay?"./pic/pause.png":"./pic/play.png";
    property url __sourceReleased: doItPlay?"./pic/pause_.png":"./pic/play_.png";

    MouseArea{
        id:mouse;
        anchors.fill:parent;
        onPressed: playButton.source = __sourcePressed;
        onReleased:  playButton.source =__sourceReleased;

        hoverEnabled:true;
        onEntered: a.visible = true;
        onExited: a.visible = false;
    }
    Component.onCompleted: mouse.clicked.connect(clicked);

    onDoItPlayChanged: {
        //console.debug("Play or Pause Button do it play ?",doItPlay);
        playButton.source = doItPlay?"./pic/pause_.png":"./pic/play_.png";
        playButton.__sourcePressed = doItPlay?"./pic/pause.png":"./pic/play.png";
        playButton.__sourceReleased = doItPlay?"./pic/pause_.png":"./pic/play_.png";
    }
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
            text:"play"
        }
    }
}

