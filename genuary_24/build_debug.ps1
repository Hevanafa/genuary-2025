.\vars.ps1
cargo build

# assign the icon
rcedit .\target\debug\$global:APP_NAME.exe --set-icon .\assets\icon\raylib.ico
