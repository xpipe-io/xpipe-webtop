$Targets = "root/usr/bin", "root/apps", "root/defaults", "root/etc/s6-overlay/s6-rc.d/netbirdd/run", "root/etc/s6-overlay/s6-rc.d/packagekitd/run", "root/etc/s6-overlay/s6-rc.d/polkitd/run", "root/etc/s6-overlay/s6-rc.d/tailscaled/run", "root/etc/s6-overlay/s6-rc.d/sshd/run"

foreach ($Target in $Targets) {
  Get-ChildItem -Path $Target -Recurse |
    Where-Object { -not $_.PSIsContainer } |
    ForEach-Object {
      echo $_.FullName
      git update-index --chmod=+x $_.FullName
    }
}
