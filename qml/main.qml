import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtGamepad 1.0
import ZSS 1.0 as ZSS
ApplicationWindow{
    visible:true;
    height:630;
    width:500;
    color: "#333"
    id:window;
    ZSS.Interaction { id : interaction; }

    property bool useGamepad:false;

    Timer{
        id:timer;
        interval:16;//15 ms
        running:false;
        repeat:true;
        onTriggered: {
            if(switchControl.checked)
                crazyShow.updateFromGamepad();
                crazyShow.updateCommand();
                interaction.sendCommand();
        }
    }
    Column{
        anchors.fill:parent;
        Grid{
            id:radioRectangle;
            width:parent.width;
            columns: 1;
            topPadding: 10;
            columnSpacing: 10;
            property int itemWidth : (width - (columns-1) * columnSpacing - 2*padding)/columns;
            ZGroupBox{
                title :qsTr("Sender Setting");
                Column{
                    width:parent.width;
                    Grid{
                        bottomPadding: 5;
                        id : crazyListView;
                        verticalItemAlignment: Grid.AlignVCenter;
                        horizontalItemAlignment: Grid.AlignLeft;
                        columnSpacing: 10;
                        rowSpacing: 10;
                        columns:4;
                        width:parent.width;
                        property int itemWidth : (width - (columns-1) * columnSpacing - 2*padding)/columns;
                        enabled: !crazyConnect.ifConnected;
                        ZText{
                            text: qsTr("Control Mode");
                        }
                        Switch {
                            id : switchControl;
                            checked :window.useGamepad
                            onClicked: {
                                window.useGamepad = checked;
                            }
                        }
                        ZText{
                            text: qsTr(" ");
                        }
                        ZText{
                            text: qsTr(" ");
                        }
                        ZText{
                            text: qsTr("Address");
                        }
                        ComboBox{
                            id : address
                            model:interaction.getCrazySetting(0);
                            currentIndex : interaction.getDefaultIndex(0);
                            onActivated: interaction.sendCrazySetting(0,index);
                            width:parent.itemWidth;
                        }
                        ZText{
                            text: qsTr("Frequency");
                        }
                        ComboBox{
                            id : frequency
                            model:interaction.getCrazySetting(1);
                            currentIndex : interaction.getDefaultIndex(1);
                            onActivated: interaction.sendCrazySetting(1,index);
                            width:parent.itemWidth;
                        }
                    }
                    Button{
                        anchors.right: parent.right;
                        id : crazyConnect;
                        text : qsTr("Connect");
                        onClicked: clickEvent();
                        function clickEvent(){
                            interaction.sendStartPacket(frequency.currentIndex);
                            switch(frequency.currentIndex){
                            case 0:
                                console.log("Connect to Frequency 6");break;
                            case 1:
                                console.log("Connect to Frequency 8");break;
                            default:
                                console.log("Frequency ERROR !");break;
                            }
                        }
                    }
                }
            }
            ZGroupBox{
                title : qsTr("Manual Control");
                Column{
                    width:parent.width;
                    Grid{
                        bottomPadding: 5;
                        id : crazyShow;
                        columns: 6;
                        columnSpacing: 10;
                        padding:0;
                        width:parent.width;
                        property int itemWidth : (width - (columns-1) * columnSpacing - 2*padding)/columns;
                        property int robotID : 1;//Robot
                        property int velX : 0;//Vx
                        property int velY : 0;//Vy
                        property int velR : 0;//Vr
                        property bool shoot : false;//Shoot
                        property bool dribble : false;//Dribb
                        property bool rush : false;//Rush

                        property int velXStep : 20;//VxStep
                        property int velYStep : 20;//VyStep
                        property int velRStep : 20;//VrStep
                        property bool mode : false;//KickMode
                        property int dribbleLevel : 3;//DribLevel
                        property int rushSpeed : 20;//RushSpeed

                        property int m_VEL : 150//MaxVel
                        property int velocityRMax : 1023;//MaxVelR
                        property int power : 20;//KickPower

                        property int m_VELR : 200
                        property int velocityMax : 511;
                        property int dribbleMaxLevel : 3;
                        property int kickPowerMax: 127;

                        ZText{ text:qsTr("Robot");}
                        //max num of robot: 12
                        ZSpinBox{ minimumValue:1; maximumValue:12; value:parent.robotID; width:parent.itemWidth
                            onEditingFinished:{parent.robotID = value}}
                        ZText{ text:"Stop" }
                        Button{ text:qsTr("[Space]"); width:parent.itemWidth}
                        ZText{ text:" "}
                        ZText{ text:" "}
                        ZText{ text:qsTr("Vx [W/S]") }
                        //Vx:(-m_VEL, m_VEL)
                        ZSpinBox{ minimumValue:-crazyShow.m_VEL; maximumValue:crazyShow.m_VEL; value:parent.velX;onEditingFinished:{parent.velX = value;}}
                        ZText{ text:qsTr("VxStep") }
                        //VxStep:(1, m_VEL)
                        ZSpinBox{ minimumValue:1; maximumValue:crazyShow.m_VEL; value:parent.velXStep;onEditingFinished:{parent.velXStep = value;}}
                        ZText{ text:qsTr("MaxVel") }
                        //MaxVel:(1, velocityMax)
                        ZSpinBox{ minimumValue:1; maximumValue:crazyShow.velocityMax; value:parent.m_VEL;width:parent.itemWidth
                            onEditingFinished:{parent.m_VEL = value;}}
                        ZText{ text:qsTr("Vy [A/D]")}
                        //Vy:(-m_VEL, m_VEL)
                        ZSpinBox{ minimumValue:-crazyShow.m_VEL; maximumValue:crazyShow.m_VEL; value:parent.velY;width:parent.itemWidth
                            onEditingFinished:{parent.velY = value;}}
                        ZText{ text:qsTr("VyStep") }
                        //VyStep:(1, m_VEL)
                        ZSpinBox{ minimumValue:1; maximumValue:crazyShow.m_VEL; value:parent.velYStep;width:parent.itemWidth
                            onEditingFinished:{parent.velYStep = value;}}
                        ZText{ text:" " }
                        ZText{ text:" " }
                        ZText{ text:qsTr("Vr [Left/Right]") }
                        //Vr:(-m_VEL, m_VEL)
                        ZSpinBox{ minimumValue:-crazyShow.m_VELR; maximumValue:crazyShow.m_VELR; value:parent.velR;width:parent.itemWidth
                            onEditingFinished:{parent.velR = value;}}
                        ZText{ text:qsTr("VrStep") }
                        //VrStep:(1, m_VELR)
                        ZSpinBox{ minimumValue:1; maximumValue:crazyShow.m_VELR; value:parent.velRStep;width:parent.itemWidth
                            onEditingFinished:{parent.velRStep = value;}}
                        ZText{ text:qsTr("MaxVelR") }
                        //MaxVelR:(1, velocityRMax)
                        ZSpinBox{ minimumValue:1; maximumValue:crazyShow.velocityRMax; value:parent.m_VELR;width:parent.itemWidth
                            onEditingFinished:{parent.m_VELR = value;}}
                        ZText{ text:qsTr("Shoot [E]")}
                        Button{ text:(parent.shoot? qsTr("true") : qsTr("false"));width:parent.itemWidth
                            onClicked: { parent.shoot = !parent.shoot;}
                        }
                        ZText{ text:qsTr("KickMode [Up]") }
                        Button{ text:(parent.mode?qsTr("chip"):qsTr("flat"));width:parent.itemWidth
                            onClicked: { parent.mode = !parent.mode }
                        }
                        ZText{ text:qsTr("KickPower") }
                        //KickPower:(1, kickPowerMax)
                        ZSpinBox{ minimumValue:0; maximumValue:parent.kickPowerMax; value:parent.power;width:parent.itemWidth
                            onEditingFinished:{parent.power = value;}}
                        ZText{ text:qsTr("Dribb [Q]") }
                        Button{ text:(parent.dribble ? qsTr("true") : qsTr("false"));width:parent.itemWidth
                            onClicked: { parent.dribble = !parent.dribble;}
                        }
                        ZText{ text:qsTr("DribLevel") }
                        //DribLevel:(0, dribbleMaxLevel)
                        ZSpinBox{ minimumValue:0; maximumValue:crazyShow.dribbleMaxLevel; value:parent.dribbleLevel;width:parent.itemWidth
                            onEditingFinished:{parent.dribbleLevel = value;}}
                        ZText{ text:" " }
                        Rectangle{ width:parent.itemWidth; height:20; color:parent.shoot ? "red" : "lightgrey"; }
                        // keyboard response
                        Keys.onPressed:getFocus(event);
                        function getFocus(event){
                            switch(event.key){
                            case Qt.Key_Enter:
                            case Qt.Key_Return:
                            case Qt.Key_Escape:
                                crazyShow.focus = true;
                                break;
                            default:
                                event.accepted = false;
                                return false;
                            }
                            event.accepted = true;
                        }
                        function updateStop(){
                            crazyShow.velX = 0;
                            crazyShow.velY = 0;
                            crazyShow.velR = 0;
                            crazyShow.shoot = false;
                            crazyShow.dribble = false;
                            crazyShow.rush = false;
                        }
                        function updateRush(){
                            if(crazyShow.rush){
                                crazyShow.velX = crazyShow.rushSpeed;
                                crazyShow.velY = 0;
                                crazyShow.velR = 0;
                                crazyShow.shoot = true;
                                crazyShow.dribble = false;
                            }else{
                                crazyShow.updateStop();
                            }
                        }
                        function handleKeyboardEvent(e){
                            switch(e){
                            case 'U':crazyShow.mode = !crazyShow.mode;
                                break;
                            case 'a':crazyShow.velY = crazyShow.limitVel(crazyShow.velY+crazyShow.velYStep,-crazyShow.m_VEL,crazyShow.m_VEL);
                                break;
                            case 'd':crazyShow.velY = crazyShow.limitVel(crazyShow.velY-crazyShow.velYStep,-crazyShow.m_VEL,crazyShow.m_VEL);
                                break;
                            case 'w':crazyShow.velX = crazyShow.limitVel(crazyShow.velX+crazyShow.velXStep,-crazyShow.m_VEL,crazyShow.m_VEL);
                                break;
                            case 's':crazyShow.velX = crazyShow.limitVel(crazyShow.velX-crazyShow.velXStep,-crazyShow.m_VEL,crazyShow.m_VEL);
                                break;
                            case 'q':crazyShow.dribble = !crazyShow.dribble;
                                break;
                            case 'e':crazyShow.shoot = !crazyShow.shoot;
                                break;
                            case 'L':crazyShow.velR = crazyShow.limitVel(crazyShow.velR+crazyShow.velRStep,-crazyShow.m_VELR,crazyShow.m_VELR);
                                break;
                            case 'R':crazyShow.velR = crazyShow.limitVel(crazyShow.velR-crazyShow.velRStep,-crazyShow.m_VELR,crazyShow.m_VELR);
                                break;
                            case 'S':crazyShow.updateStop();
                                break;
                            case 'g':crazyShow.rush = !crazyShow.rush; updateRush();
                                break;
                            default:
                                return false;
                            }
                            updateCommand();
                        }
                        function updateCommand(){
                            interaction.updateCommandParams(crazyShow.robotID,crazyShow.velX,crazyShow.velY,crazyShow.velR,crazyShow.dribble,crazyShow.dribbleLevel,crazyShow.mode,crazyShow.shoot,crazyShow.power);
                        }
                        function updateFromGamepad(){
                            crazyShow.velX = -parseInt(gamepad.axisLeftY*10)/10.0*crazyShow.m_VEL;
                            crazyShow.velY = parseInt(gamepad.axisLeftX*10)/10.0*crazyShow.m_VEL;
                            crazyShow.velR = parseInt(gamepad.axisRightX*10)/10.0*crazyShow.m_VELR;
                            if(gamepad.buttonX > 0){
                                crazyShow.power = parseInt(gamepad.buttonL2*10)/10.0*crazyShow.kickPowerMax;
                                crazyShow.mode = true;
                                crazyShow.shoot = gamepad.buttonX;
                            }
                            else if(gamepad.buttonY > 0){
                                crazyShow.power = parseInt(gamepad.buttonL2*10)/10.0*crazyShow.kickPowerMax;
                                crazyShow.mode = false;
                                crazyShow.shoot = gamepad.buttonY;

                            }
                            else{
                                crazyShow.shoot = 0;
                            }

                            if(gamepad.buttonR2 > 0){
                                crazyShow.dribbleLevel =  parseInt(gamepad.buttonR2*10)/10.0*crazyShow.dribbleMaxLevel;
                                crazyShow.dribble = true ;
                            }
                            else{
                                crazyShow.dribble = false ;
                            }

                            console.log(velX,velY);
                        }
                        function limitVel(vel,minValue,maxValue){
                            if(vel>maxValue) return maxValue;
                            if(vel<minValue) return minValue;
                            return vel;
                        }
                        Shortcut{
                            sequence:"G";
                            onActivated:crazyShow.handleKeyboardEvent('g');
                        }
                        Shortcut{
                            sequence:"A";
                            onActivated:crazyShow.handleKeyboardEvent('a');
                        }
                        Shortcut{
                            sequence:"Up";
                            onActivated:crazyShow.handleKeyboardEvent('U');
                        }
                        Shortcut{
                            sequence:"D"
                            onActivated:crazyShow.handleKeyboardEvent('d');
                        }
                        Shortcut{
                            sequence:"W"
                            onActivated:crazyShow.handleKeyboardEvent('w');
                        }
                        Shortcut{
                            sequence:"S"
                            onActivated:crazyShow.handleKeyboardEvent('s');
                        }
                        Shortcut{
                            sequence:"Q"
                            onActivated:crazyShow.handleKeyboardEvent('q');
                        }
                        Shortcut{
                            sequence:"E"
                            onActivated:crazyShow.handleKeyboardEvent('e');
                        }
                        Shortcut{
                            sequence:"Left"
                            onActivated:crazyShow.handleKeyboardEvent('L');
                        }
                        Shortcut{
                            sequence:"Right"
                            onActivated:crazyShow.handleKeyboardEvent('R');
                        }
                        Shortcut{
                            sequence:"Space"
                            onActivated:crazyShow.handleKeyboardEvent('S');
                        }
                    }
                    Button{
                        anchors.right: parent.right;
                        id:crazyStart;
                        text:qsTr("Start");
                        property bool ifStarted:false;
                        enabled : true;
                        onClicked:{
                            handleClickEvent();
                        }

                        function handleClickEvent(){
                            if(ifStarted){
                                timer.stop();
                            }else{
                                timer.start();
                            }
                            ifStarted = !ifStarted;
                            text = (ifStarted ? qsTr("Stop") : qsTr("Start"));
                        }
                    }
                }
            }
        }
        Rectangle{
            id : gamepadInterface;
            height:300;
            width:parent.width;
            color:"#333"
            Item {
                id: background
                anchors.fill: parent

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    RowLayout {
                        id: topRow
                        width: parent.width
                        ColumnLayout {
                            id: buttonL2Item
                            Layout.alignment: Qt.AlignLeft
                            ButtonImage {
                                id: leftTrigger
                                Layout.alignment: Qt.AlignCenter
                                source: "/gamepad/xboxControllerLeftTrigger.png"
                                active: gamepad.buttonL2 != 0
                            }
                            ProgressBar {
                                id: buttonL2Value
                                value: gamepad.buttonL2
                            }
                        }

                        Item {
                            id: centerButtons
                            Layout.alignment: Qt.AlignCenter
                            Layout.fillWidth: true
                            height: guideButton.height
                            width: guideButton.width + 16 + backButton.width + startButton.width
                            ButtonImage {
                                id: backButton
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: guideButton.left
                                anchors.rightMargin: 8
                                source: "/gamepad/xboxControllerBack.png"
                                active: gamepad.buttonSelect
                            }
                            ButtonImage {
                                id: guideButton
                                anchors.centerIn: parent
                                source: "/gamepad/xboxControllerButtonGuide.png"
                                active: gamepad.buttonGuide
                            }
                            ButtonImage {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: guideButton.right
                                anchors.leftMargin: 8
                                id: startButton
                                source: "/gamepad/xboxControllerStart.png"
                                active: gamepad.buttonStart
                            }
                        }


                        ColumnLayout {
                            id: buttonR2Item
                            Layout.alignment: Qt.AlignRight
                            ButtonImage {
                                id: rightTrigger
                                Layout.alignment: Qt.AlignCenter
                                source: "/gamepad/xboxControllerRightTrigger.png"
                                active: gamepad.buttonR2 != 0
                            }

                            ProgressBar {
                                id: buttonR2Value
                                value: gamepad.buttonR2
                            }
                        }
                    }

                    RowLayout {
                        id: middleRow
                        ButtonImage {
                            id: buttonL1
                            source: "/gamepad/xboxControllerLeftShoulder.png"
                            active: gamepad.buttonL1
                        }
                        Item {
                            id: spacer1
                            Layout.fillWidth: true
                        }

                        ButtonImage {
                            id: buttonR1
                            source: "/gamepad/xboxControllerRightShoulder.png"
                            active: gamepad.buttonR1
                        }
                    }

                    RowLayout {
                        id: bottomRow
                        width: parent.width
                        DPad {
                            id: dPad
                            Layout.alignment: Qt.AlignLeft
                            gamepad: gamepad
                        }

                        LeftThumbstick {
                            id: leftThumbstick
                            Layout.alignment: Qt.AlignLeft
                            gamepad: gamepad
                        }

                        Item {
                            id: spacer2
                            Layout.fillWidth: true
                        }

                        RightThumbstick {
                            id: rightThumbstick
                            Layout.alignment: Qt.AlignRight
                            gamepad: gamepad
                        }

                        Item {
                            width: 100
                            height: 100
                            Layout.alignment: Qt.AlignRight
                            ButtonImage {
                                id: buttonA
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: "/gamepad/xboxControllerButtonA.png";
                                active: gamepad.buttonA
                            }
                            ButtonImage {
                                id: buttonB
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                source: "/gamepad/xboxControllerButtonB.png";
                                active: gamepad.buttonB
                            }
                            ButtonImage {
                                id: buttonX
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                source: "/gamepad/xboxControllerButtonX.png";
                                active: gamepad.buttonX
                            }
                            ButtonImage {
                                id: buttonY
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: "/gamepad/xboxControllerButtonY.png";
                                active: gamepad.buttonY
                            }
                        }
                    }
                }
            }

            Connections {
                target: GamepadManager
                onGamepadConnected: gamepad.deviceId = deviceId
            }

            Gamepad {
                id: gamepad
                deviceId: GamepadManager.connectedGamepads.length > 0 ? GamepadManager.connectedGamepads[0] : -1
                property int count : 0;
                onButtonGuideChanged: {
                    if(gamepad.buttonGuide == false)
                        switchControl.checked = !switchControl.checked
                }
                onButtonStartChanged: {
                    if(gamepad.buttonStart == false){
//                        timer.start();
                        crazyStart.handleClickEvent();
                    }
                }
                onButtonUpChanged: {
                    if(gamepad.buttonUp == false){
                        crazyShow.robotID += 1;
                    }
                }
                onButtonDownChanged: {
                    if(gamepad.buttonDown == false){
                        crazyShow.robotID -= 1;
                    }
                }
            }
        }
    }
}


