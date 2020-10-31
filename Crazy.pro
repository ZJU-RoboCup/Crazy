TEMPLATE = app
QT += qml quick gamepad
CONFIG += c++11
TARGET = Crazy
DESTDIR = $$PWD/../ZBin

DEFINES += QT_DEPRECATED_WARNINGS

HEADERS += \
    src/crc/crc.h \
    src/radiopacket.h \
    src/interaction.h

SOURCES += \
    src/crc/crc.cpp \
    src/main.cpp \
    src/radiopacket.cpp \
    src/interaction.cpp

RESOURCES += \
    Crazy.qrc

RC_ICONS = Crazy.ico
