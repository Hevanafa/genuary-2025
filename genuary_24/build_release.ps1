.\vars.ps1
cargo build --release

# assign the icon
rcedit .\target\release\$global:APP_NAME.exe --set-icon .\assets\icon\raylib.ico
