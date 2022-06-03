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

        // ---- PlusSign ----
        Rectangle {
            id: plusSignRec;
            color: "Transparent";
            width: cubeImage - 25;
            height: cubeImage - 25;
            anchors{
                top: lennaOriRec.bottom
                topMargin: 5
                // bottom: noiseImg.source = "top;
                // bottomMargin: 80
                left: parent.left
                leftMargin: lineTab + 15
            }

            // ---- PlusSign Image ----
            Image {
                source: "./images/plus_icon.png"
                sourceSize.width: parent.width
                sourceSize.height: parent.height
                fillMode: Image.PreserveAspectCrop
            }
        }

        // ---- Noise Image ----
        Rectangle {
            id: noiseRect;
            color: "Transparent";
            width: cubeImage;
            height: cubeImage;
            anchors{
                top: plusSignRec.bottom
                topMargin: 5
                left: parent.left
                leftMargin: lineTab
            }

            // ---- Noise Image ----
            Image {

                id: noiseImg;

                source: "./images/Noise.png"
                sourceSize.width: parent.width
                sourceSize.height: parent.height
                cache: false;
                fillMode: Image.PreserveAspectCrop

                function reloadImage(){
                    if(source == "./images/Noise.png"){
                        source = "./images/Noise1.png"
                    }else{
                        source = "./images/Noise.png"
                    }

                }
            }

            // ---- Noise Label ----
            Text {
                text: "Ruido"
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
                top: noiseRect.bottom
                topMargin: 25
                left: parent.left
                leftMargin: lineTab
            }
            Label{
                text: "Média de Ruído"
                font.pixelSize: 18
                color: "White"
            }

            TextField {
                validator: DoubleValidator;
                placeholderText: qsTr("Insira Média de Ruído");
                // text: "test"

                onEditingFinished: {
                    if(text==""){
                        text = mean;
                    }else{
                        mean = text;
                    }
                    backend.onMediaUpdate(mean, variation);
                    noiseImg.reloadImage();
                    lennaResultImg.reloadImage();
                    // background.color = "Red"
                }
            }
        }

        Column{
            anchors{
                top: meanText.bottom
                topMargin: 5
                left: parent.left
                leftMargin: lineTab
            }

            Label{
                text: "Variação de Ruído"
                font.pixelSize: 18
                color: "White"
            }

            TextField {                
                validator: DoubleValidator;
                placeholderText: qsTr("Insira Variação de Ruído");
                // text: "test"

                onEditingFinished: {
                    if(text==""){
                        text = variation;
                    }else{
                        variation = text;
                    }
                    backend.onMediaUpdate(mean, variation);
                    noiseImg.reloadImage();
                    lennaResultImg.reloadImage();
                    // noiseImg.source="./images/Lenna.png"
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
                source: "./images/LennaResult.png"
                sourceSize.width: parent.width
                sourceSize.height: parent.height
                fillMode: Image.PreserveAspectCrop

                function reloadImage(){
                    if(source == "./images/LennaResult.png"){
                        source = "./images/LennaResult1.png"
                    }else{
                        source = "./images/LennaResult.png"
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

        Column {
            id: filterStrText

            anchors{
                top: lennaResultRec.bottom
                topMargin: 5
                left: parent.left
                leftMargin: lineTab
            }

            Label{
                text: "Filtro de Força"
                font.pixelSize: 18
                color: "White"
            }

            TextField {

                validator: DoubleValidator;
                placeholderText: qsTr("Insira a força do filtro");
                // text: "test"

                onEditingFinished: {
                    if(text==""){
                        text = filterStr;
                    }else{
                        filterStr = text;
                    }
                    backend.onFilterUpdate(filterStr, searchWin, templateWin, colorStr);
                    imgDenoised.reloadImage();
                    // background.color = "Red"
                }
            }
        }

        Column{
            id: searchWinText;
            anchors{
                top: filterStrText.bottom
                topMargin: 5
                left: parent.left
                leftMargin: lineTab
            }

            Label{
                text: "Janela de Busca"
                font.pixelSize: 18
                color: "White"
            }

            TextField {

                validator: DoubleValidator;
                placeholderText: qsTr("Insira Tamanho da Janela de Busca");
                // text: "test"



                onEditingFinished: {
                    if(text==""){
                        text = searchWin;
                    }else{
                        searchWin = text;
                    }
                    backend.onFilterUpdate(filterStr, searchWin, templateWin, colorStr);
                    imgDenoised.reloadImage();
                    // noiseImg.source="./images/Lenna.png"
                    // background.color = "Red"
                }
            }

        }

        Column{
            id: templateWinText
            anchors{
                top: searchWinText.bottom
                topMargin: 5
                left: parent.left
                leftMargin: lineTab
            }

            Label{
                text: "Media para Pesos"
                font.pixelSize: 18
                color: "White"
            }

            TextField {

                validator: DoubleValidator;
                placeholderText: qsTr("Insira a quantidade de pixels para pesos");
                // text: "test"

                onEditingFinished: {
                    if(text==""){
                        text = templateWin;
                    }else{
                        templateWin = text;
                    }
                    backend.onFilterUpdate(filterStr, searchWin, templateWin, colorStr);
                    imgDenoised.reloadImage();
                    // background.color = "Red"
                }
            }
        }

        Column{
            id: colorStrText
            anchors{
                top: templateWinText.bottom
                topMargin: 5
                left: parent.left
                leftMargin: lineTab
            }

            Label{
                text: "Força do Filtro de Cor"
                font.pixelSize: 18
                color: "White"
            }

            TextField {


                validator: DoubleValidator;
                placeholderText: qsTr("Insira a força do filtro de cores");
                // text: "test"

                onEditingFinished: {
                    if(text==""){
                        text = colorStr;
                    }else{
                        colorStr = text;
                    }
                    backend.onFilterUpdate(filterStr, searchWin, templateWin, colorStr);
                    imgDenoised.reloadImage();
                    // noiseImg.source="./images/Lenna.png"
                    // background.color = "Red"
                }
            }
        }


    }

    // ---- Line ----
    Rectangle{
        id: lineDenoise;
        width: 2;
        height: parent.height;
        color: "#373737"
        anchors{
            left: lennaNoisyRec.right;
            leftMargin: lineTab;
            top: parent.top;
            bottom: parent.bottom;
        }
    }

    // ---- DenoiseResultImage ----
    Rectangle {
        id: lennaDenoiseResultRec
        color: "white"
        width: cubeImage
        height: cubeImage
        anchors{
            top: parent.top
            topMargin: parent.height/2 - cubeImage/2
            left: lineDenoise.left
            leftMargin: lineTab;
        }

        Image {
            id: imgDenoised;
            cache: false;
            source: "./images/Denoised.png"
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            fillMode: Image.PreserveAspectCrop

            function reloadImage(){
                if(source == "./images/Denoised.png"){
                    source = "./images/Denoised1.png"
                }else{
                    source = "./images/Denoised.png"
                }

            }
        }

        Text {
            text: "Img sem Ruido"
            font.pixelSize: 20
            color: "White"
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.top
        }
    }



    Connections {
        target: backend

        function onUpdated(msg) {
            time = msg
            noiseImg.reloadImage();
            lennaResultImg.reloadImage();
            imgDenoised.reloadImage();
        }

    }
}