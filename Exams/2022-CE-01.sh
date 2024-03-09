find ~ -maxdepth 1 -type f -user $(whoami) -exec chmod 7775 {} ';' 1>/dev/null
