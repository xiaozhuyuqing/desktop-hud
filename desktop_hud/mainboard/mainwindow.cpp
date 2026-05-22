#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <desktop_hud_core>

namespace yuqing::mainboard{


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    tray_icon_ = new SystemTrayIcon(this, this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::WakeUp()
{
    show();
    raise();
    activateWindow();
}

void MainWindow::CloseDown()
{
    qApp->exit();
}

void MainWindow::closeEvent(QCloseEvent *event)
{
    event->ignore();
    this->hide();
}

}
