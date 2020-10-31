#include "interaction.h"

Interaction::Interaction(QObject *parent):QObject(parent){
    udpSender = new QUdpSocket();
    udpReceiver = new QUdpSocket();
    radioPacket = new RadioPacket(this,udpSender,udpReceiver);
    for(int i=0;i<16;i++){
        frequency.append(i);                        stringFrequency.append(QString::number(i));
    }
    address.append(QHostAddress("10.12.225.78"));receiveAddress.append(QHostAddress("10.12.225.79"));   stringAddress.append("10.12.225.78");
    address.append(QHostAddress("10.12.225.109"));receiveAddress.append(QHostAddress("10.12.225.110"));  stringAddress.append("10.12.225.109");
    address.append(QHostAddress("10.12.225.142"));receiveAddress.append(QHostAddress("10.12.225.142"));  stringAddress.append("10.12.225.142");
    address.append(QHostAddress("10.12.225.130"));receiveAddress.append(QHostAddress("10.12.225.130"));  stringAddress.append("10.12.225.130");
    address.append(QHostAddress("10.12.225.143"));receiveAddress.append(QHostAddress("10.12.225.143"));  stringAddress.append("10.12.225.143");
    addressIndex = 0;
    radioPacket->updateAddress(address[addressIndex],receiveAddress[addressIndex]);
    frequencyIndex = 1;
}
Interaction::~Interaction(){
    delete udpSender;
    delete udpReceiver;
}

QStringList Interaction::getCrazySetting(int itemIndex) const{
    switch(itemIndex){
    case 0:
        return stringAddress;
    case 1:
        return stringFrequency;
    default:
        break;
    }
    return QStringList();
}
void Interaction::sendCrazySetting(int itemIndex,int index){
    switch(itemIndex){
    case 0:
        addressIndex = index;
        radioPacket->updateAddress(address[addressIndex],receiveAddress[addressIndex]);
    case 1:
        frequencyIndex = index;
    default:
        break;
    }
}
int Interaction::getDefaultIndex(int itemIndex) const{
    switch(itemIndex){
    case 0:
        return addressIndex;
    case 1:
        return frequencyIndex;
    default:
        break;
    }
    return 0;
}

void Interaction::sendStartPacket(int index){
    radioPacket->sendStartPacket(index);
}

