TEMPLATE = app
QT += quick
CONFIG += c++11
TARGET = Crazy
DESTDIR = $$PWD/../ZBin

DEFINES += QT_DEPRECATED_WARNINGS

HEADERS += \
    src/radiopacket.h \
    src/interaction.h

SOURCES += \
    src/main.cpp \
    src/radiopacket.cpp \
    src/interaction.cpp

RESOURCES += \
    Crazy.qrc

RC_ICONS = Crazy.ico
