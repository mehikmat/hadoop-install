# set same java home for all users
JAVA_HOME="$JAVA_HOME" # get java home from current user's environment
echo "Setting Java Home:> $JAVA_HOME"
sudo sh -c "echo export JAVA_HOME=$JAVA_HOME > /etc/profile.d/java.sh"
#To make sure JAVA_HOME is defined for this session, source the new script:
source /etc/profile.d/java.sh 