$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider 2048
$publicXml = $rsa.ToXmlString($false)
$privateXml = $rsa.ToXmlString($true)
$publicPath = ".\PublicKey.xml"
$privatePath = ".\PrivateKey.xml"
Set-Content -Path $publicPath -Value $publicXml
Set-Content -Path $privatePath -Value $privateXml
Write-Host "`n✅ RSA keys generated successfully."
Write-Host "`n🔹 Public Key XML (embed in Encryptor):`n"
Write-Host $publicXml
Write-Host "`n🔸 Private Key XML (embed in Decryptor):`n"
Write-Host $privateXml
Write-Host "`nFiles saved:"
Write-Host " - Public Key: $publicPath"
Write-Host " - Private Key: $privatePath"