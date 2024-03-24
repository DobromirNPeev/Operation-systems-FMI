find ~/songs -type f | cut -d '/' -f 6 | sort | sed -E 's/(.*) - .*/\1/' | uniq | sed -E 's/(.*) (.*)/\1\2/' | xargs -I{} mkdir ~/songs/{}
