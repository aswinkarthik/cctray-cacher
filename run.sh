set -e

## Checking if env is set
if [ -z $CI_MASTER_FEED_URL ]
then
echo 'Set $CI_MASTER_FEED_URL'
exit 1
fi

## Creating directory for xml to host if it does not exist
mkdir -p data
cd data

#Hosting server
ruby -run -e httpd . -p 9095 &

control_c()
## run if user hits control-c
{
	echo -en "\n***Exiting at `date`***\n"
	pkill -P $$	
	exit $?	
}

## Trapping keyboard interrupt
trap control_c SIGINT

## Looping calls
while true
do
echo "Getting XML at `date`"
curl $CI_MASTER_FEED_URL > ./cctray.xml 2>/dev/null 
sleep 300
done

