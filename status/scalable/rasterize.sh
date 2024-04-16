#!zsh

set v

scale() {
  for dir in $(find .. -type d -name '[0-9]*'); do
    #echo scale dir is "$dir"
    export DIM=$(echo $dir | sed -e 's/[^0-9]*//g')
    #echo dim is $DIM
    convert -background none "${1}" -resize ${DIM}x${DIM} "${dir}"/"$(basename "${1}" .svg)".png
  done
}

for svg in $(git ls-files --modified '*.svg'); do
  echo `realpath $svg`
  scale `realpath $svg`
done
