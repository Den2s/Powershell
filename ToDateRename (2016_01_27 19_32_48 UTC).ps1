# переименование файлов видео с фотоаппарата в правильный вид для каталога
$p = "E:\vid"
$p = "D:\temp\1"
cd $p
$d = dir -File -Path $p
$bk = @{}

foreach ($item in $d)
{
  $lastWtime = $item.LastWriteTime
  #$lastWtime = $item.CreationTime
  $type = $item.Name.Substring($item.Name.IndexOf("."));
  $oldname = $item.Name
  $filename = ("{0:yyyyMMddHHmmss}" -f $lastWtime)+ $type 
  
  $dirName = "{0:yyyyMMdd}" -f $lastWtime
  
  # На случай видео с янд диска ----------------------------------------------------------
  #$filename = $item.Name.Replace("-","").Replace(" ","")
  
  #$dirName = $filename.Substring(0,8)

  # На случай если видео после конвертации -----------------------------------------------
  #$filename = $oldname
  
  #$dirName = $filename.Substring(0,8)
 
 echo "$oldname - $filename"
 #continue
  
 $item | Rename-Item -NewName $filename 
  
  if (Test-Path $dirName)
  {
     if (Test-Path "$dirName\$filename")
     {
        $filenameBad = $filename
        $filename = $filename.Split(".")[0]+(Get-Random -Maximum 999 -Minimum 100)+"."+$filename.Split(".")[1]
        Rename-Item -Path $filenameBad -NewName $filename 
        Move-Item $filename -Destination $dirName
     } else {
        Move-Item $filename -Destination $dirName
     }
     
  }
  else
  {
      mkdir $dirName
      Move-Item $filename -Destination $dirName  
  }
 $bk.Add($oldname,"$dirName\$filename")
  
}
break
$bk.GetEnumerator()| sort name |select name,value| Export-Csv "$p\1.csv" -NoTypeInformation
$bk |Out-File "$p\1.txt"

break

# Если задница случилась
$a = Import-Csv -Path "$p\1.csv"

$a| %{Rename-Item -Path $_.value -NewName $_.name }
