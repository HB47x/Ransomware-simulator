# RSA Private Key
$sf = @"
<RSAKeyValue>
<Modulus>YOUR_PUBLIC_MODULUS_HERE</Modulus>
<Exponent>AQAB</Exponent>
<P>...</P>
<Q>...</Q>
<DP>...</DP>
<DQ>...</DQ>
<InverseQ>...</InverseQ>
<D>...</D>
</RSAKeyValue>
"@
function dr($ct,$sf) {
 $rsa = New-Object Security.Cryptography.RSACryptoServiceProvider
 $rsa.FromXmlString($sf)
 $rsa.Decrypt([Convert]::FromBase64String($ct),$false)
}
function DFI($ifi,$privKeyXml) {
 $allBytes = [IO.File]::ReadAllBytes($ifi)
 $trailerLen = 344
 if ($allBytes.Length -le $trailerLen) {
   Write-Warning "File too small: $ifi"
   return
 }
 $dataLen = $allBytes.Length - $trailerLen
 $encryptedData = $allBytes[0..($dataLen-1)]
 $encryptedKeyBytes = $allBytes[$dataLen..($allBytes.Length-1)]
 $encryptedKeyB64 = [Text.Encoding]::UTF8.GetString($encryptedKeyBytes)
 $keyivBytes = dr $encryptedKeyB64 $privKeyXml
 $keyiv = [Text.Encoding]::UTF8.GetString($keyivBytes)
 $key = [Text.Encoding]::UTF8.GetBytes($keyiv.Substring(0,32))
 $iv  = [Text.Encoding]::UTF8.GetBytes($keyiv.Substring(32,16))
 $aes = [Security.Cryptography.Aes]::Create()
 $aes.KeySize = 256
 $aes.Key = $key
 $aes.IV  = $iv
 $decryptor = $aes.CreateDecryptor()
 $plainBytes = $decryptor.TransformFinalBlock($encryptedData,0,$encryptedData.Length)
 [IO.File]::WriteAllBytes($ifi,$plainBytes)
 $newName = $ifi -replace ".test$",""
 Rename-Item $ifi -NewName $newName
 Write-Host "Decrypted: $newName"
}
$vg = gdr -PS FileSystem | select -Expand Root
foreach ($root in $vg) {
 $files = gci $root -Recurse -Filter "*.test" -File
 foreach ($file in $files) {
   try { DFI $file.FullName $sf } catch { Write-Error $_ }
 }
}