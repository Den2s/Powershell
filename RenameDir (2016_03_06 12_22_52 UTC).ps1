# переименование папок в правильный вид для Play Memories
$p = "E:\imported video\"
cd $p
$d = dir -Directory -Path $p | ?{$_.name.Length -gt 8}

foreach ($item in $d)
{
    $f = dir $item -File | select -First 1
    $name = ($f.Name).Substring(0,8)
    $item | Rename-Item -NewName $name -Force
   
    Write-Host "$item -> $name"
}
