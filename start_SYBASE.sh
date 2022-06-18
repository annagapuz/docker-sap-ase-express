#!/bin/sh

# Source in the Sybase environment variables

source /opt/sap/SYBASE.sh

echo $PATH

echo "Start SYBASE using $SYBASE/$SYBASE_ASE/install/RUN_SYBASE"
$SYBASE/$SYBASE_ASE/install/RUN_SYBASE24
RET=$?

echo "Return code is $RET"

exit ${RET}
