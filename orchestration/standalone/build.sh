# Checkout sources to $source_directory

export JAVA_HOME=/usr/jdk
export M2_HOME=/usr/mvn
export ANT_HOME=/usr/ant
export PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin:$ANT_HOME/bin

cd $source_directory/jpetstore
mvn clean compile package

# Publish artifact: $source_directory/jpetstore/target/jpetstore.war
# Publish artifact: $source_directory/docker/*
