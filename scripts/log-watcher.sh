#!/usr/bin/env bash
# Grab and save the path to this script
# http://stackoverflow.com/a/246128
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
# echo "${SCRIPTDIR}" # For debugging

export NVM_DIR="${HOME}/.nvm"
# shellcheck source=/home/chrisl8/.nvm/nvm.sh
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh" # This loads nvm

echo "set your browser to http://${HOSTNAME}:28778/ to watch logs"
echo "NOTE: This does not add new logs in real time,"
echo "so if new ROS nodes start up you will have to restart this."

# Fix default server config that requires SSL
cp "${SCRIPTDIR}/dotarlobot/web_server.conf" "${HOME}/.log.io/web_server.conf"
cp "${SCRIPTDIR}/dotarlobot/log_server.conf" "${HOME}/.log.io/log_server.conf"

confFile=${HOME}/.log.io/harvester.conf
echo "exports.config = {" >"${confFile}"
echo "  nodeName: \"application_server\"," >>"${confFile}"
echo "  logStreams: {" >>"${confFile}"
firstLine=true
for j in "${HOME}"/.ros/log/latest/*; do
  logName="${j//.log/}"
  if [[ "${firstLine}" == false ]]; then
    echo "  ]," >>"${confFile}"
  fi
  firstLine=false
  # https://stackoverflow.com/a/3162500/4982408
  echo "  \"${logName##*/}\": [" >>"${confFile}"
  echo "    \"${j}\"" >>"${confFile}"
done

# Grab the log files in the ~/.ros/log folder itself
logFolder=${HOME}/.ros/log
for j in $(find "${logFolder}" -maxdepth 1 -type f | sed 's#.*/##'); do
  logName="${j//.log/}"
  if [[ "${firstLine}" == false ]]; then
    echo "  ]," >>"${confFile}"
  fi
  firstLine=false
  echo "  \"${logName}\": [" >>"${confFile}"
  echo "    \"${logFolder}/${j}\"" >>"${confFile}"
done

if [[ -f /tmp/robotNodeScript.log ]]; then
  echo "  ]," >>"${confFile}"
  echo "\"behavior-log\": [\"/tmp/robotNodeScript.log\"]" >>"${confFile}"
else
  echo "  ]" >>"${confFile}"
fi
# shellcheck disable=SC2129
echo "}," >>"${confFile}"
echo "server: {" >>"${confFile}"
echo "    host: '0.0.0.0'," >>"${confFile}"
echo "        port: 28777" >>"${confFile}"
echo "  }" >>"${confFile}"
echo "}" >>"${confFile}"
#cat "${confFile}"
"${SCRIPTDIR}/../Log.io/bin/log.io-server" &
sleep 1
"${SCRIPTDIR}/../Log.io/bin/log.io-harvester" &
echo "To Stop log server run:"
echo "pkill -f log.io"
echo "Or kill_ros.sh also stops this."
