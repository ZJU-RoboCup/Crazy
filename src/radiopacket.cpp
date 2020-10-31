#include "radiopacket.h"
#include "crc/crc.h"
#include <QElapsedTimer>
#include <thread>
namespace{
    const int TRANSMIT_PACKET_SIZE = 25;
    const int START_PACKET_SIZE = 6;
    const int PORT = 1030;
    std::thread t;
    unsigned char calc_add(unsigned char *buf, int len);
}

RadioPacket::RadioPacket(QObject *parent,QUdpSocket* udpSender,QUdpSocket* udpReceiver)
    : QObject(parent)
    , startPacket1(START_PACKET_SIZE,0)
    , startPacket2(START_PACKET_SIZE,0)
    , transmitPacket(TRANSMIT_PACKET_SIZE,0)
    , udpSender(udpSender),udpReceiver(udpReceiver)
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
    startPacket2[1] = 0x5a;
    startPacket2[2] = 0x5a;
    startPacket2[3] = 0x02;
    startPacket2[4] = 0x02;
    startPacket2[5] = 0xa8;
    encode();

    udpReceiver->bind(QHostAddress::AnyIPv4, PORT, QUdpSocket::ShareAddress);
    t = std::thread([&]{storeData();});
}

void RadioPacket::sendStartPacket(int frq){
    if(udpSender != nullptr){
        qDebug() << "frq : " << frq;
        unsigned char important_data = frq < 8 ? frq*4 : frq*4+58;
        startPacket1[0] = (char)0xf0;
        startPacket1[1] = (char)important_data;
        startPacket1[2] = (char)important_data;
        startPacket1[3] = (char)0x01;
        startPacket1[4] = (char)0x02;
        startPacket1[5] = (char)::calc_add((unsigned char*)startPacket1.data(),START_PACKET_SIZE-1);

        startPacket2[0] = (char)0xf0;
        startPacket2[1] = (char)important_data;
        startPacket2[2] = (char)important_data;
        startPacket2[3] = (char)0x02;
        startPacket2[4] = (char)0x02;
        startPacket2[5] = (char)::calc_add((unsigned char*)startPacket2.data(),START_PACKET_SIZE-1);
        udpSender->writeDatagram((startPacket1.data()),START_PACKET_SIZE, address, PORT);
        udpSender->writeDatagram((startPacket2.data()),START_PACKET_SIZE, receiveAddress, PORT);
        qDebug() << "Start Packet:" << startPacket1.toHex();
    }
}

void RadioPacket::updateAddress(const QHostAddress& address,const QHostAddress& receiveAddress){
    this->address = address;
    this->receiveAddress = receiveAddress;
    qDebug() << "get address : " << address << receiveAddress;
}

void RadioPacket::storeData(){
    static QByteArray datagram;
    qDebug() << "in storeData function!!!";
    while(true){
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
        while (udpReceiver->hasPendingDatagrams()) {
            datagram.resize(udpReceiver->pendingDatagramSize());
            udpReceiver->readDatagram(datagram.data(), datagram.size());
//            if(quint16(datagram[3])!=quint16(0))
                qDebug() << "recv : 0x" << datagram.toHex() << QString::number((datagram[3]),16);
        }
    }
}

bool RadioPacket::sendCommand(){
    static int times = 0;
    static QElapsedTimer timer;
    if(times == 0) timer.start();
    if(udpSender != NULL){
        encode();
//        if(shootPowerLevel > 0 && shoot == true){
            qDebug() << "sent : 0x" << transmitPacket.toHex() << shootPowerLevel;
//        }
        udpSender->writeDatagram(transmitPacket.data(),TRANSMIT_PACKET_SIZE, address, PORT);
        return true;
    }
    return false;
}

bool RadioPacket::encode(){

    velR = velR * 4.0;
    transmitPacket[0] = packageType | gameStatus;
    //RobotID
//    transmitPacket[1] = (0x80) | ((robotID) & 0x0f);
    transmitPacket[1] = (report ? 0x80 : 0x00) | ((robotID) & 0x0f);
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
namespace{
    unsigned char calc_add(unsigned char *buf, int len){
        unsigned char fcs = 0;
        for( int i=0; i<len; ++i ){
            fcs += buf[i];
        }
        return fcs;
    }
}
