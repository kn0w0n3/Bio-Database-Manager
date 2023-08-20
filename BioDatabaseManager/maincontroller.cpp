#include "maincontroller.h"

MainController::MainController(QWidget *parent) : QWidget(parent){

}

void MainController::selectDirToSaveDatabases(){
    QString dir = QFileDialog::getExistingDirectory(Q_NULLPTR, tr("Select Directory"), "/home", QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
    QString thePath = dir.trimmed();
    emit selectedSaveToPath(thePath + "/");
}

void MainController::downloadDatabases(QString dbStoragePath, QString dbName){
    curDatabasePath = dbStoragePath;
    curDatabaseName = dbName;

    downloadDbProc = new QProcess();
    QStringList args;
    args << "Set-Location -Path " + curDatabasePath + ";"
         << "Copy-Item C:/BioDatabaseManager/NCBI/update_blastdb.pl -Destination " + curDatabasePath + ";"
         << "perl update_blastdb.pl --passive --decompress " + curDatabaseName;

    downloadDbProc->connect(downloadDbProc, &QProcess::readyReadStandardOutput, this, &MainController::processDownloadDbMsg);
    connect(downloadDbProc, &QProcess::finished, this, &MainController::downloadFinishedNotification);
    downloadDbProc->start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit processStatusMessage("Download db process started @ " + dateTimeString);
}

void MainController::processDownloadDbMsg(){
    ba_DownloadStdOut = downloadDbProc->readAllStandardOutput().trimmed();
    str_DownloadStdOut = QString(ba_DownloadStdOut.trimmed());
    emit processStatusMessage(str_DownloadStdOut);
}

void MainController::downloadFinishedNotification(){
    downloadDbProc->terminate();
    removePerlFileProcess = new QProcess();
    QStringList args;
    args << "Set-Location -Path " + curDatabasePath + ";"
         << "Remove-Item " + curDatabasePath + "update_blastdb.pl";
    connect(removePerlFileProcess, &QProcess::finished, this, &MainController::removePerlFileNotification);
    removePerlFileProcess->start("powershell", args);
}

void MainController::removePerlFileNotification(){
    removePerlFileProcess->terminate();
    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit processStatusMessage("Download db process completed @ " + dateTimeString);
}
