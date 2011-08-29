# This script outputs a b c ... where one letter is printed for each block
# of 256 lines that start with a slash
BEGIN {
  i = 0; k = 97 # ASCII value of a
}
{
  if ($1 ~ /^\//) {
    if (i == 0) {
	  printf "%c ", k; k++
	}
    i = (i + 1) % 256
  }
}
END { 
  printf "\n"
}
