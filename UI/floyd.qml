import QtQuick
import QtQuick.Controls.Basic
ApplicationWindow {
    visible: true;
    width: 1200;
    height: 600;
    title: "HelloApp";

    property string time: "00:00:00"
    property QtObject backend
    property int lineTab: 150;
    property int cubeImage: 153;
    property double variation: 0.2;
    property double mean: 0.0;
    property int filterStr: 10;
    property int searchWin: 21;
    property int templateWin: 7;
    property int colorStr: 10;
    
    Timer{
        id: timer;
        interval: 200;
        running: false;
        repeat: false;

        property var callback;

        onTriggered: {
            if (this.running) {
                this.callback();
            }
        }
    }

    function setTimeout(callback, time) {
        timer.callback = callback;
        timer.interval = time;
        timer.start();
    }

    // ---- Background ----
    Rectangle {
        id: background;
        anchors.fill: parent
        color: "#272727"

    }

    Rectangle{
        id: originalOptionsRec;
        color: 'Transparent';
        width: cubeImage + lineTab;
        height: parent.height;

        anchors{
            left: parent.left;
            top: parent.top;
        }

        // ---- OriginalImage ----
        Rectangle {
            id: lennaOriRec;
            color: "Blue";
            width: cubeImage;
            height: cubeImage;
            anchors{
                top: parent.top
                topMargin: 80
                left: parent.left
                leftMargin: lineTab
            }

            // ---- Image ----
            Image {
                source: "./images/Lenna.png"
                sourceSize.width: parent.width
                sourceSize.height: parent.height
                fillMode: Image.PreserveAspectCrop
            }

            // ---- OriginalImage Label ----
            Text {
                text: "Original"
                font.pixelSize: 20
                color: "White"
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.top
            }
        }

        Column{
            id: meanText
            anchors{
                top: lennaOriRec.bottom
                topMargin: 25
                left: parent.left
                leftMargin: lineTab
            }
            Label{
                text: "Possibilidade de cores"
                font.pixelSize: 18
                color: "White"
            }

            TextField {
                validator: DoubleValidator;
                placeholderText: qsTr("Insira Possibilidade de cores");
                // text: "test"

                onEditingFinished: {
                    if(text==""){
                        text = mean;
                    }else{
                        mean = text;
                    }
                    backend.onMediaUpdate(mean, 0.0);
                    // noiseImg.reloadImage();
                    lennaResultImg.reloadImage();
                    // background.color = "Red"
                }
            }
        }

    }

    // ---- Line ----
    Rectangle{
        id: lineResult;
        width: 2;
        height: parent.height;
        color: "#373737"
        anchors{
            left: originalOptionsRec.right;
            leftMargin: lineTab;
            top: parent.top;
            bottom: parent.bottom;
        }
    }

    Rectangle {
        id: lennaNoisyRec;
        width: cubeImage + lineTab;
        height: parent.height;
        color: "Transparent";
        anchors{
            top: parent.top
            topMargin: 80
            left: lineResult.right
        }

        // ---- ResultImage ----
        Rectangle {
            id: lennaResultRec
            color: "white"
            width: cubeImage
            height: cubeImage
            anchors{
                top: parent.top
                topMargin: parent.height/4 - height/2
                left: parent.left
                leftMargin: lineTab;
            }

            Image {
                id: lennaResultImg;
                cache: false;
                source: "./images/FloydSteinberg1.png"
                sourceSize.width: parent.width
                sourceSize.height: parent.height
                fillMode: Image.PreserveAspectCrop

                function reloadImage(){
                    if(source == "./images/FloydSteinberg.png"){
                        source = "./images/FloydSteinberg1.png"
                    }else{
                        source = "./images/FloydSteinberg.png"
                    }

                }
            }

            Text {
                text: "Img com Ruido"
                font.pixelSize: 20
                color: "White"
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.top
            }
        }
    }



    Connections {
        target: backend

        function onUpdated(msg) {
            time = msg
            // noiseImg.reloadImage();
            lennaResultImg.reloadImage();
            // imgDenoised.reloadImage();
        }

    }
}