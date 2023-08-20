#ifndef MAINCONTROLLER_H
#define MAINCONTROLLER_H


#include <QObject>
#include <QWidget>

//File Ops Libs
#include <QFile>
#include <QFileInfo>
#include <QFileDialog>
//#include <QThread>
#include <QProcess>
//#include <QDebug>
//#include <QMessageBox>
#include <QDirIterator>
#include <QString>
#include <QDateTime>
//#include <QStandardPaths>

class MainController:  public QWidget{
    Q_OBJECT

public:
    MainController(QWidget *parent = nullptr);

signals:
    void selectedSaveToPath(QString dbSavePath);
    void processStatusMessage(QString statusMessage);


public slots:
    void selectDirToSaveDatabases();
    void downloadDatabases(QString, QString);
    void processDownloadDbMsg();
    void downloadFinishedNotification();
    void removePerlFileNotification();

private:
    QProcess *downloadDbProcess;
    QByteArray ba_DownloadStdOut;
    QString str_DownloadStdOut = "";
    QProcess *downloadDbProc;
    QProcess *removePerlFileProcess;
    QString curDatabasePath = "";
    QString curDatabaseName = "";
};

#endif // MAINCONTROLLER_H
