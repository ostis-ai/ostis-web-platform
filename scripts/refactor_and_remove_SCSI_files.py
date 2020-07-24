import sys
import os
import re
import codecs


def main(workDirectory):
    osName = os.name
    slash = ""
    if osName == 'posix':
        slash = "/"
    elif osName == 'nt':
        slash = "\\"
        os.system('reg delete "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /f')
        os.system('reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1')

    for file in os.listdir(workDirectory):
        if file.endswith(".txt"):
            print(os.path.join(workDirectory, file))
    listOfFiles = list()
    for (dirPath, dirnames, filenames) in os.walk(workDirectory):
        listOfFiles += [os.path.join(dirPath, file) for file in filenames]
    print(listOfFiles)
    for file in listOfFiles:
        if file.endswith(".scs"):
            f = codecs.open(file, "r", "utf_8")
            if osName == 'posix':
                dirpathList = re.split(r'/', file)
                #dirPath = ""
            elif osName == 'nt':
                dirpathList = re.split(r'\\', file)
                #dirPath = os.path.abspath(os.getcwd()) + "\\"
            #f = codecs.open(dirPath + file, "r", "utf_8")
            dirPath = ""
            x = 0
            for x in range (0, len(dirpathList)-1):
                dirPath = dirPath + dirpathList[x] + slash
            isEdit = False
            bufferFileList = []
            for line in f:
                result = re.findall(r'\[\*\^\"file://', line)
                if (len(result) > 0):
                    stage1 = re.split(r'\^"file://', line)
                    tabulationString = ""
                    for x in stage1[0]:
                        tabulationString = tabulationString + " "
                        
                    bufferFileList.append(stage1[0]+'\n')
                    stage2 = re.split(r'"\*\];;', stage1[1])

                    temp = re.findall(r'/',stage2[0])
                    relativePath = ""
                    scsiPath = ""
                    if(len(temp) > 0):
                        stage3 = re.split(r'/',stage2[0])
                        x = 0
                        for x in range (0, len(stage3)-1):
                            relativePath = relativePath + stage3[x] + "/"
                            scsiPath = scsiPath + stage3[x] + slash
                        scsiPath = scsiPath + stage3[x+1]
                    else:
                        scsiPath = stage2[0]

                    f2 = codecs.open(dirPath+scsiPath, "r", "utf_8")
                    
                    for line2 in f2:                        
                        res = re.findall(r'\"file://', line2)
                        if (len(res) > 0 and len(relativePath) > 0):
                            stage3 = re.split(r'//', line2)
                            line2 = stage3[0] + "//" + relativePath + stage3[1]    
                        bufferFileList.append(tabulationString + line2)
                    
                    bufferFileList.append("\n")
                    bufferFileList.append("*];;")
                    f2.close()
                    os.remove(dirPath+scsiPath)
                    isEdit = True
                    print(file)
                    print(line)
                    print(scsiPath)
                    print("================")
                else:
                    bufferFileList.append(line)
            f.close()
            if (isEdit):
                f = codecs.open(file, "w", "utf_8")
                for line in bufferFileList:
                    f.write(line)






if __name__ == '__main__':
    if (len(sys.argv) == 2):
        main(sys.argv[1])
    else:
        print("invalid numb of arguments, Please specify only the work directory")
