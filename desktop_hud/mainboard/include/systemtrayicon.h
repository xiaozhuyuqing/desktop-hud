#ifndef SYSTEMTRAYICON_H
#define SYSTEMTRAYICON_H

#include <QSystemTrayIcon>
#include <QMenu>
#include <QAction>

#include "mainwindow.h"

namespace yuqing::mainboard{
class MainWindow;

class SystemTrayIcon: public QSystemTrayIcon {
    Q_OBJECT
public:
    explicit SystemTrayIcon(MainWindow* mainWindow, QObject *parent = nullptr);
    ~SystemTrayIcon();

private:
    // 初始化成员
    void SetupTrayIcon();
    void closeEvent(QCloseEvent *event);
    // 设置任务栏右键菜单
    void SetupTrayActions();
    // 连接信号槽
    void SetupConnections();
    MainWindow* mainWindow;
    QAction* wakeUpAction;
    QAction* closeDownAction;
    QMenu* menu;
};
  
}

#endif