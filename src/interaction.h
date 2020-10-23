#ifndef __INTERACTION_H__
#define __INTERACTION_H__

#include <QObject>
#include <QString>
#include <QUdpSocket>
#include "radiopacket.h"

class Interaction : public QObject{
    Q_OBJECT
public:
    Interaction(QObject *parent = 0);
    ~Interaction();
    Q_INVOKABLE QStringList getCrazySetting(int itemIndex) const;
    Q_INVOKABLE void sendCrazySetting(int itemIndex,int index);
    Q_INVOKABLE int getDefaultIndex(int itemIndex) const;
    Q_INVOKABLE void sendStartPacket(int);
    Q_INVOKABLE void sendCommand(){radioPacket->sendCommand();}
    Q_INVOKABLE void updateCommandParams(int robotID,int velX,int velY,int velR,bool dribble,int dribbleLevel,bool mode,bool shoot,int power){
        radioPacket->updateCommandParams(robotID,velX,velY,velR,dribble,dribbleLevel,mode,shoot,power);
    }

private:
    QList<QHostAddress> address;
    QStringList stringAddress;
    int addressIndex;
    QList<quint8> frequency;
    QStringList stringFrequency;
    int frequencyIndex;
    QUdpSocket *udpSender,*udpReceiver;
    RadioPacket *radioPacket;
};

#endif // __INTERACTION_H__
