DIR=$(basename $(pwd))
USERNAME=paulbuis
IMAGE=$DIR
DATE=$(date -I)
BASETAG=$(echo -n "$USERNAME/$IMAGE")
DAYTAG=$(echo -n "$BASETAG:$DATE")
LATEST=$(echo -n "$BASETAG:latest")
LOGFILE=$(echo -n "build-$IMAGE:$DATE.log")
echo "Building $DAYTAG"
echo "Logging to $LOGFILE"
LOG=$((docker build --tag $DAYTAG .) 2>&1)
if [ $? -eq 0 ]; then
    echo "$LOG" > $LOGFILE
    docker tag $DAYTAG $LATEST
    echo "Also tagged as $LATEST"
    docker image ls $BASETAG
    echo " DONE"
else
    echo "$LOG" > $LOGFILE
    echo " FAILED"
    echo "$LOG" | less
fi
