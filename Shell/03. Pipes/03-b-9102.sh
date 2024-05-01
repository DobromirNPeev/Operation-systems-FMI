find ~/songs -type f | cut -d '/' -f 6 | sed -E 's/(.*) - (.*) \(.*\)\.ogg/\2/'
