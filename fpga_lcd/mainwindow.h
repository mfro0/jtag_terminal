#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTimer>

#include "jtag_atlantic.h"
#include "common.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public slots:
    void processTimeout(void);

private:
    Ui::MainWindow *ui;

    JTAGATLANTIC *atlantic;
    int bytes_received;

};

#endif // MAINWINDOW_H
