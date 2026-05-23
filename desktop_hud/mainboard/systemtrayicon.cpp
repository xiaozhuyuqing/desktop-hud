#include "systemtrayicon.h"

#include <QCoreApplication>
#include <QDebug>

yuqing::mainboard::SystemTrayIcon::SystemTrayIcon(MainWindow *mainWindow, QObject *parent)
{
    this->mainWindow = mainWindow;
    menu = new QMenu();
    SetupTrayIcon();
    SetupConnections();
    show();
}

yuqing::mainboard::SystemTrayIcon::~SystemTrayIcon()
{
    delete menu;
}

void yuqing::mainboard::SystemTrayIcon::SetupTrayIcon()
{
    QString iconPath = QCoreApplication::applicationDirPath() + "/resources/minihud-icon-small.png";
    QIcon icon = QIcon(iconPath);
    if (icon.isNull()) {
        qDebug() << "No Image icon.";
    }
    setIcon(icon);
    SetupTrayActions();
    setContextMenu(menu);
    setToolTip("minihud for windows");
}

void yuqing::mainboard::SystemTrayIcon::closeEvent(QCloseEvent *event)
{
}

void yuqing::mainboard::SystemTrayIcon::SetupTrayActions()
{
    wakeUpAction = new QAction("Show", menu);
    closeDownAction = new QAction("Exit", menu);
    menu->addAction(wakeUpAction);
    menu->addAction(closeDownAction);
}

void yuqing::mainboard::SystemTrayIcon::SetupConnections()
{
    connect(wakeUpAction, &QAction::triggered, mainWindow, &MainWindow::WakeUp);
    connect(closeDownAction, &QAction::triggered, mainWindow, &MainWindow::CloseDown);
}
