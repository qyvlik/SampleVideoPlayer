/*
    by qyvlik
    email:qyvlik@qq.com
*/
import QtQuick 2.4

/*
这个控件是一个菜单，
现有的QtQuick控件中没有可以独立显示的menu控件
*/
Rectangle{
    id:menu;
    width: 70;
    height: 100;
    x:-menu.width;
    color:"#fbed90";
    opacity: 0.7;
    z:parent.z+10;

    MouseArea{
        anchors.fill: menu;
        drag.target: menu
        drag.axis: Drag.XAndYAxis;
        onClicked: {
            menu.close();
        }
    }

    function open(_x,_y){
        menu.x = _x;
        menu.y = _y;
    }
    function close(){
        menu.x = -menu.width;
        menu.y = -menu.height;
    }

    Behavior on x{
        NumberAnimation { duration: 500 }
    }
    Behavior on y{
        NumberAnimation { duration: 500 }
    }
}
