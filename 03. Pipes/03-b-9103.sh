find ~/songs -type f | cut -d '/' -f 6 | sed -E 's/(.*) - (.*) \(.*\)\.ogg/\2/' | sed 's/[A-Z]/\L&/g'| sed 's/ /_/g' | sort
