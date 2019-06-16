#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <iostream>
#include <sstream>

static const int bytes_to_receive = 1 << 20;

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    std::string device_name = "Arrow MAX 10 DECA [1-4]";

    ui->setupUi(this);

    atlantic = jtagatlantic_open(device_name.c_str(), -1, -1, "fpga_lcd");
    if (atlantic == NULL)
    {
        std::cerr << "could not open " << device_name << ", exiting." << std::endl;
        exit(1);
    }
    QTimer *timer = new QTimer(this);
    timer->start(1);
    connect(timer, SIGNAL(timeout()), this, SLOT(processTimeout()));
}

void MainWindow::processTimeout(void)
{
    char str[80];
    int i = 0;

    std::cout << "Bytes available: " << 
                 jtagatlantic_bytes_available(atlantic) << 
                 '\n';
    while (jtagatlantic_bytes_available(atlantic) &&
           jtagatlantic_read(atlantic, &str[i], 1) &&
           str[i++] != '\n');
    std::string s = std::string(str);
    std::stringstream tokenizer;
    int number;

    tokenizer << std::hex << str;
    tokenizer >> number;
    ui->lcdNumber->display(number);
}

MainWindow::~MainWindow()
{
    delete ui;
    jtagatlantic_close(atlantic);
}
