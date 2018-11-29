#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFont>
#include "interaction.h"
#include "radiopacket.h"

void qmlRegister(){
    qmlRegisterType<Interaction>("ZSS", 1, 0, "Interaction");
}

int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setFont(QFont("Microsoft YaHei",9));
    qmlRegister();
    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    return app.exec();
}
