#include "maincontroller.h"

MainController::MainController(QWidget *parent) : QWidget(parent){

}

void MainController::selectDirToSaveDatabases(){
    QString dir = QFileDialog::getExistingDirectory(Q_NULLPTR, tr("Select Directory"), "/home", QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
    QString thePath = dir.trimmed();
    emit selectedSaveToPath(thePath + "/");
}

void MainController::downloadDatabases(QString dbStoragePath, QString dbName){

    qDebug() << "The DB storage path is: " + dbStoragePath;
    qDebug() << "The DB name is: " + dbName;

    QStringList args;

    args << "Set-Location -Path " + dbStoragePath + ";"
         << "Copy-Item C:/BioDatabaseManager/NCBI/update_blastdb.pl -Destination " +  dbStoragePath + ";"
         << "perl update_blastdb.pl --passive --decompress " + dbName;

    proc.connect(&proc, &QProcess::readyReadStandardOutput, this, &MainController::processDownloadDbMsg);
    connect(&proc, &QProcess::finished, this, &MainController::downloadFinishedNotification);
    proc.start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit processStatusMessage("Download db process started @ " + dateTimeString);
}

void MainController::processDownloadDbMsg(){
    ba_DownloadStdOut = proc.readAllStandardOutput().trimmed();
    str_DownloadStdOut = QString(ba_DownloadStdOut.trimmed());
    //str_DownloadStdOut = QString(ba_DownloadStdOut.trimmed());
    qDebug() << "The download std out is: " + str_DownloadStdOut;
    emit processStatusMessage(str_DownloadStdOut);
}

void MainController::downloadFinishedNotification(){
    qDebug() << "Download process has finished...";
    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit processStatusMessage("Download db process completed @ " + dateTimeString);
}
