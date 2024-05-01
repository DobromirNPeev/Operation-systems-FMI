find /tmp -type f -readable -exec printf '%m %f\n' '{}' ';' 2>/dev/null
