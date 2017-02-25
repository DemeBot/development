function inArray # ( keyOrValue, arrayKeysOrValues ) 
{
  local e
  for e in "${@:2}"; do 
    [[ "$e" == "$1" ]] && return 0; 
  done
  return 1
}

# Enable extened patterns for bash file mtaching
shopt -s extglob

# prevent subshells
shopt -s lastpipe

# Detect Architecture.
DETECTED_ARCH=$(uname -m)

let "image_count=0"

# For each docker-compose file
for file in $(find -iname "*docker-compose.yml" ); do
    echo "SCANNING: $file"

    # Get non commented docker images
    grep 'image: ' ${file} | grep -v '#' | while read a; do
        # Filter for the image name itself
        docker_image=$(sed 's/^\s*image: //' <<< $a)

        inArray $docker_image ${image_names[@]}
        res=$?
        if [[ $res == 1 ]];
        then
            image_names[${image_count}]=$docker_image
            ((image_count++))
        fi
    done

done

for image in  ${image_names[@]}; do
    echo "FOUND IMAGE: $image"
    
    if [[ $DETECTED_ARCH = "armv7l" ]];
    then
        armhf_image=$(sed 's/arunk3001\///' <<< $image)
        armhf_image="arunk3001/armhf-"${armhf_image}
        echo "MODIFIED TO- $armhf_image"
        docker pull $armhf_image
        docker tag $armhf_image $image
    else
        docker pull $image
    fi

done