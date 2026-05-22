#pragma once

#include <QMainWindow>
#include <QMenu>
#include <QCloseEvent>

#include "systemtrayicon.h"


QT_BEGIN_NAMESPACE
namespace Ui {
    class MainWindow;
}
QT_END_NAMESPACE

namespace yuqing::mainboard{

class SystemTrayIcon;

class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public slots:
    void WakeUp();
    void CloseDown();

private:
    void closeEvent(QCloseEvent *event);
    Ui::MainWindow *ui;
    SystemTrayIcon* tray_icon_;
    QMenu* trayMenu;
    QAction* wakeUpAction;
    QAction* closeDownAction;
};

}