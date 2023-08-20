import QtQuick
import QtQuick.Controls 2.15

Window {
    width: 900
    height: 600
    visible: true
    title: qsTr("Bio Database Manager")

    Connections {
        target: mainController

        onSelectedSaveToPath:{
            saveToDirTxtEdit.text = dbSavePath
        }
        onProcessStatusMessage:{
            textArea.text += statusMessage + "\n"
        }
    }

    Rectangle {
        id: mainWin
        x: 0
        y: 0
        width: 900
        height: 600
        color: "#000000"

        Image {
            id: image
            x: 0
            y: 0
            width: 900
            height: 600
            source: "file:C:/BioDatabaseManager/images/bg.png"
            fillMode: Image.PreserveAspectFit

        }


        Rectangle {
            id: dirPathRect
            x: 253
            y: 385
            width: 485
            height: 20
            color: "#000000"
            border.color: "#ffffff"
        }

        Image {
            id: selectDirBtnImg
            x: 160
            y: 384
            width: 85
            height: 25
            source: "file:C:/BioDatabaseManager/images/selectDirBtn.png"

            //Need to try this
            //source: "qrc:/qtquickplugin/images/template_image.png"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text2
            x: 253
            y: 368
            width: 157
            height: 18
            color: "#ffffff"
            text: qsTr("Select location to store databases")
            font.pixelSize: 10
        }

        Image {
            id: startBtn
            x: 253
            y: 427
            width: 85
            height: 25
            source: "file:C:/BioDatabaseManager/images/startBtn2.png"
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: rectangle
            x: 163
            y: 85
            width: 575
            height: 277
            color: "#000000"
            border.color: "#ffffff"

            ScrollView {
                id: scrollView
                x: 3
                y: 3
                width: 569
                height: 271

                TextArea {
                    id: textArea
                    x: 0
                    y: 0
                    color: "#ffffff"
                    placeholderText: qsTr("Text Area")
                    background: Rectangle {color: "black"}
                }
            }
        }

        TextEdit {
            id: saveToDirTxtEdit
            x: 255
            y: 387
            width: 481
            height: 16
            color: "#ffffff"
            text: qsTr("")
            font.pixelSize: 11
        }

        MouseArea {
            id: selectDirMouseArea
            x: 160
            y: 384
            width: 85
            height: 25

            onClicked: {
                mainController.selectDirToSaveDatabases()
            }
        }

        MouseArea {
            id: startBtnMouseArea
            x: 253
            y: 427
            width: 85
            height: 25
            onClicked: {

                if(selectDbComboBox.currentText === "Select Database to Download"){
                    textArea.text += "Select a database to download before proceeding/n"
                }
                else if(saveToDirTxtEdit.text === ""){
                    textArea.text += "Select a location to save the database before proceeding/n"
                }
                else if(saveToDirTxtEdit.text !== ""){
                    console.log("Sending db info to c++")
                    mainController.downloadDatabases(saveToDirTxtEdit.text, selectDbComboBox.currentText)
                }
            }
        }

        Image {
            id: windowTitleImg
            x: 278
            y: 8
            width: 344
            height: 49
            source: "file:C:/BioDatabaseManager/images/logo.png"
            fillMode: Image.PreserveAspectFit
        }

        ComboBox {
            id: selectDbComboBox
            x: 164
            y: 59
            width: 189
            height: 21
            editable: false
            visible: true
            model: ["Select Database to Download", "165_ribosomal_RNA", "185_fungal_sequences","285_fungal_sequences",
                "Betacoronavirus", "ITS_RefSeq_Fungi", "human_genome", "landmark", "mito", "mouse_genome", "nt", "env_nt",
                "nt_euk", "nt_prok", "nt_viruses", "nr", "env_nr",  "pataa", "patnt", "pdbaa", "pdbnt", "ref_euk_repgenomes",
                "ref_viroids_rep_genomes", "ref_viruses_rep_genomes", "refseq_protein", "taxdb", "tsa_nr", "tsa_nt", "swissprot"]

            delegate: ItemDelegate {
                width: selectDbComboBox.width
                contentItem: Text {
                    text: selectDbComboBox.textRole
                          ? (Array.isArray(selectDbComboBox.model) ? modelData[selectDbComboBox.textRole] : model[selectDbComboBox.textRole])
                          : modelData
                    color: "#000000" //Change the text color of the model data in the drop down box.
                    font: selectDbComboBox.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: selectDbComboBox.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvasselectOutputFormat
                x: selectDbComboBox.width - width - selectDbComboBox.rightPadding
                y: selectDbComboBox.topPadding + (selectDbComboBox.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: selectDbComboBox
                    function onPressedChanged() { canvasselectAlgorithm.requestPaint(); }
                }

                //This will change the color of the triangle indicator.
                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = selectDbComboBox.pressed ? "#FFFFFF" : "#FFFFFF";
                    context.fill();
                }
            }
            //The second color is the main color. The first item is what color the changes to once clicked.
            //This will change the text color of main text in the box.
            contentItem: Text {
                leftPadding: 0
                rightPadding: selectDbComboBox.indicator.width + selectDbComboBox.spacing

                text: selectDbComboBox.displayText
                font: selectDbComboBox.font
                color: selectDbComboBox.pressed ? "#FFFFFF" : "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            //This will change the main box background color, border color,  and the border color when pressed.
            //The second color is the main color. The first item is what color the changes to once clicked.
            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                color: "#000000"
                border.color: selectDbComboBox.pressed ? "#FFFFFF" : "#FFFFFF"
                border.width: selectDbComboBox.visualFocus ? 2 : 1
                radius: 2
            }

            popup: Popup {
                y: selectDbComboBox.height - 1
                width: selectDbComboBox.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: selectDbComboBox.popup.visible ? selectDbComboBox.delegateModel : null
                    currentIndex: selectDbComboBox.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                //This will change the color of the drop down Rectangle
                background: Rectangle {
                    border.color: "#FFFFFF"
                    color: "#FFFFFF"
                    radius: 5
                }
            }
        }
    }
}
