#!zsh

scale() {
  for dir in $(find .. -type d -name '[0-9]*'); do
    #echo scale dir is "$dir"
    export DIM=$(echo $dir | sed -e 's/[^0-9]*//g')
    #echo dim is $DIM
    export OUTPUT="${dir}"/"$(basename "${1}" .svg)".png
    if [ -L "${OUTPUT}" ]; then
      printf "Skipping symbolic link %s\n" "${OUTPUT}"
      continue
    fi
    rm -f "${OUTPUT}"
    convert -filter Lanczos -background none "${1}" -resize ${DIM}x${DIM} "${OUTPUT}"
  done
}

rasterize_svg() {
  printf "Converting %s\n" "${1}"
  echo `realpath $1`
  scale `realpath $1`

  for link in $(find -L ../.. -samefile ${1} -xtype l); do
    printf "Converting symbolic link %s\n" "${link}"
    echo `realpath --no-symlinks $link`
    scale `realpath --no-symlinks $link`
  done
}

if [ -z "$1" ]; then
  for svg in $(git ls-files --modified '*.svg'); do
    rasterize_svg "${svg}"
  done
else
    echo `realpath --no-symlinks "${1}"`
    scale `realpath --no-symlinks "${1}"`
fi
