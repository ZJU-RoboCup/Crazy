#ifndef __RADIOPACKET_H__
#define __RADIOPACKET_H__

#include <QUdpSocket>
#include <QtDebug>

class RadioPacket{
public:
    explicit RadioPacket(QUdpSocket* udpSender);
    void sendStartPacket(int index);
    bool sendCommand();
    void updateCommandParams(int robotID,int velX,int velY,int velR,bool ctrl,int ctrlLevel,bool mode,bool shoot,int power){
        this->robotID = robotID - 1;
        this->velX = velX; this->velY = velY; this->velR = velR;
        this->ctrl = ctrl;
        this->shootMode = mode;this->shoot = shoot; this->shootPowerLevel = power;
        this->ctrlPowerLevel = ctrlLevel;
    }
    void updateAddress(QHostAddress);
private:
    QByteArray startPacket1;
    QByteArray startPacket2;
    QByteArray transmitPacket;
    QUdpSocket* udpSender;
    bool encode();
private:
    bool shoot;
    bool ctrl;
    bool shootMode;//false is "flat kick" and true is "chip kick".
    quint8 robotID;
    quint8 packageType = 0x00;
    quint8 gameStatus = 0x00;
    qint16 velX;
    qint16 velY;
    qint16 velR;
    quint16 ctrlPowerLevel;
    quint16 shootPowerLevel;
    QHostAddress address;
};

#endif // __RADIOPACKET_H__
