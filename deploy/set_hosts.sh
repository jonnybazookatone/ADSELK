function dip() { docker inspect $1 | grep IPAddress | cut -d '"' -f 4 ; }

cat /etc/hosts | grep -v '#DOCKER-DELETE-ME' > hosts.docker.tmp
RESULT="$?"
if [ ${RESULT} = 0 ]; then
    echo "Checking for running docker contadoiners..."
  else
    echo "Error modifying /etc/hosts, try running with sudo."
exit 1
fi

echo "# Below are the docker hosts running at $(date). #DOCKER-DELETE-ME" >> hosts.docker.tmp

docker ps | awk '{print $1}' | while read CONTAINERID
do
  IP=$(dip ${CONTAINERID})
  if [ -n "${IP}" ] ; then
    baseaddr="$(echo $IP | cut -d. -f1-3)"
    lsv="$(echo $IP | cut -d. -f4)"
    IP="$(echo $baseaddr.$lsv)"
    NAME=$(docker inspect ${CONTAINERID} | grep Name | cut -d '"' -f 4 | sed 's#^/##g' | tr -d '\n')
    echo "${IP} ${NAME} #DOCKER-DELETE-ME" >> hosts.docker.tmp
    fi
done

dnsmasq
sudo mv -f hosts.docker.tmp /etc/hosts
sudo killall -HUP dnsmasq
echo 'Updated /etc/hosts with current ("docker ps") entries...'
tail -10 /etc/hosts
