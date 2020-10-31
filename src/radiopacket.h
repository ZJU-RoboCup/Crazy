#ifndef __RADIOPACKET_H__
#define __RADIOPACKET_H__

#include <QUdpSocket>
#include <QtDebug>

class RadioPacket : public QObject{
public:
    explicit RadioPacket(QObject *parent,QUdpSocket* udpSender,QUdpSocket*);
    void sendStartPacket(int index);
    bool sendCommand();
    void updateCommandParams(int robotID,int velX,int velY,int velR,bool ctrl,int ctrlLevel,bool mode,bool shoot,int power,bool report){
        this->robotID = robotID;
        this->velX = velX; this->velY = velY; this->velR = velR;
        this->ctrl = ctrl;
        this->shootMode = mode;this->shoot = shoot;this->shootPowerLevel = power;
        this->ctrlPowerLevel = ctrlLevel;
        this->report = report;
    }
    void updateAddress(const QHostAddress& address,const QHostAddress& receiveAddress);
public slots:
    void storeData();
private:
    QByteArray startPacket1;
    QByteArray startPacket2;
    QByteArray transmitPacket;
    QUdpSocket* udpSender,* udpReceiver;
    bool encode();
private:
    bool shoot;
    bool ctrl;
    bool shootMode;//false is "flat kick" and true is "chip kick".
    bool report;
    quint8 robotID;
    quint8 packageType = 0x00;
    quint8 gameStatus = 0x00;
    qint16 velX;
    qint16 velY;
    qint16 velR;
    quint16 ctrlPowerLevel;
    quint16 shootPowerLevel;
    QHostAddress address, receiveAddress;
};

#endif // __RADIOPACKET_H__
