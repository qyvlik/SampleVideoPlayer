/*
    by qyvlik
    email:qyvlik@qq.com
*/
import QtQuick 2.4
import QtQuick.Dialogs 1.2
import QtMultimedia 5.4

Item {

    // 这个player属性要设置成 MediaPlayer 的id
    property variant player;

    MessageDialog{id:d;}
    Connections{
        target:player;
        onError:{
            switch(error)
            {
            case  MediaPlayer.NoError:

                break;
            case MediaPlayer.ResourceError:
                d.title = qsTr("Resource Error");
                d.text = qsTr("The audio cannot be played due to a problem allocating resources.");
                d.open();
                break;

            case MediaPlayer.FormatError:
                d.title = qsTr("Format Error");
                d.text = qsTr("The audio format is not supported.");
                d.open();
                break;

            case MediaPlayer.NetworkError:
                d.title = qsTr("Network Error");
                d.text = qsTr("The audio cannot be played due to network issues.");
                d.open();
                break;

            case MediaPlayer.AccessDenied:
                d.title = qsTr("Access Denied");
                d.text = qsTr("The audio cannot be played due to insufficient permissions.");
                d.open();
                break;

            case MediaPlayer.ServiceMissing:
                d.title = qsTr("Service Missing");
                d.text = qsTr("The audio cannot be played because the media service could not be instantiated.");
                d.open();
                break;

            default:break;
            }
        }
    }
}

