#include "radiopacket.h"
#include <QElapsedTimer>

namespace{
    const int TRANSMIT_PACKET_SIZE = 25;
    const int START_PACKET_SIZE = 6;
    const int PORT = 1030;
}

RadioPacket::RadioPacket(QUdpSocket* udpSender)
    : startPacket1(START_PACKET_SIZE,0)
    , startPacket2(START_PACKET_SIZE,0)
    , transmitPacket(TRANSMIT_PACKET_SIZE,0)
    , udpSender(udpSender)
    , shoot(false), ctrl(false), shootMode(false), robotID(0)
    , velX(0), velY(0), velR(0)
    , ctrlPowerLevel(2), shootPowerLevel(0)
    , packageType(0x40),gameStatus(0x00)
    , address(QHostAddress("0.0.0.0")){

    startPacket1[0] = 0xf0;
    startPacket1[1] = 0x5a;
    startPacket1[2] = 0x5a;
    startPacket1[3] = 0x01;
    startPacket1[4] = 0x02;
    startPacket1[5] = 0xa7;

    startPacket2[0] = 0xf0;
    startPacket2[1] = 0x18;
    startPacket2[2] = 0x5a;
    startPacket2[3] = 0x01;
    startPacket2[4] = 0x02;
    startPacket2[5] = 0x65;
    encode();
}

void RadioPacket::sendStartPacket(int index){
    if(udpSender != nullptr){
        switch (index) {
        case 1: // No.8
            udpSender->writeDatagram((startPacket1.data()),START_PACKET_SIZE, address, PORT);
            qDebug() << "Start Packet:" << startPacket1.toHex();
            break;
        case 0: // No.6
            udpSender->writeDatagram((startPacket2.data()),START_PACKET_SIZE, address, PORT);
            qDebug() << "Start Packet:" << startPacket2.toHex();
            break;
        default:
            break;
        }
    }
}

void RadioPacket::updateAddress(QHostAddress address){
    this->address = address;
}

bool RadioPacket::sendCommand(){
    static int times = 0;
    static QElapsedTimer timer;
    if(times == 0) timer.start();
    if(udpSender != NULL){
        encode();
        qDebug() << "0x" << transmitPacket.toHex();
        udpSender->writeDatagram(transmitPacket.data(),TRANSMIT_PACKET_SIZE, address, PORT);
        return true;
    }
    return false;
}

bool RadioPacket::encode(){
    velR = velR * 4.0;
    transmitPacket[0] = packageType | gameStatus;
    //RobotID
    transmitPacket[1] = (robotID) & 0x0f;
    transmitPacket[0] = transmitPacket[0] | 0x08;
    //Robot1 Config
    //shoot or chip
    transmitPacket[1] = transmitPacket[1] | (shootMode << 6 );
    //power level
    transmitPacket[1] = transmitPacket[1] | (ctrl ? (ctrlPowerLevel << 4):0);
    //low bit of vel
    transmitPacket[2] = ((velX >= 0)?0:0x80) | (abs(velX) & 0x7f);
    transmitPacket[3] = ((velY >= 0)?0:0x80) | (abs(velY) & 0x7f);
    transmitPacket[4] = ((velR >= 0)?0:0x80) | (abs(velR) & 0x7f);
    //Don't understand !
    if(transmitPacket[2] == char(0xff)) transmitPacket[4] = 0xfe;
    if(transmitPacket[3] == char(0xff)) transmitPacket[5] = 0xfe;
    if(transmitPacket[4] == char(0xff)) transmitPacket[6] = 0xfe;
    //clear Byte[17-24]
    transmitPacket[17] = transmitPacket[18] = transmitPacket[19] = transmitPacket[20] = transmitPacket[21] = transmitPacket[22] = transmitPacket[23] = transmitPacket[24] = 0;
    //high bit of vel
    transmitPacket[17] = ((abs(velX) & 0x180) >> 1) | ((abs(velY) & 0x180) >> 3) | ((abs(velR) & 0x780) >> 7);
    //shoot power
    transmitPacket[21] = (shoot ? shootPowerLevel:0) & 0x7f;
    return true;
}
