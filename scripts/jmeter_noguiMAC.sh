#!/bin/bash

# TESTSCRIPT => the JMeter test script for load test
# GRAPHSCRIPT => the JMeter test script for generating performance graphs
# DIROUTPUT => directory for writing csv files
# TESTRESULTS => CSV file of JMeter results (Avg Resp Time, Errors, Hit Rate, etc...)
# PERFRESULTS => CSV file of PerfMon results, always PERFMON.csv

#MAC
USER=`whoami`
DATE=$(/bin/date +%Y%m%d_%H%M)
TESTSCRIPT=/Users/${USER}/GIT/int603/scripts/INT603_XITEST_MAC.jmx
GRAPHSCRIPT=/Users/${USER}/GIT/int603/scripts/INT603_GraphsGenerator.jmx


echo -e "Input test scenario name followed by [ENTER]:"
read SCENARIO
echo "SCENARIO=${SCENARIO}"

# Set DIROUTPUT and TESTRESULTS and PERFRESULTS
DIROUTPUT=/Users/${USER}/GIT/int603/csv/${DATE}_${SCENARIO}
TESTRESULTS=${DIROUTPUT}/${SCENARIO}.csv
PERFRESULTS=${DIROUTPUT}/PERFMON.csv
FILEPREFIX=${SCENARIO}-

echo -e "Input IP Address of Server to test"
read TESTIP
echo "Server IP: ${TESTIP}"

# Export variables
export DIROUTPUT
export TESTRESULTS
export GRAPHSCRIPT
export PERFRESULTS
export PREFIX
export TESTIP

# Make Directory

echo "DIROUTPUT: ${DIROUTPUT}"
echo "Creating directory ${DIROUTPUT}"
mkdir ${DIROUTPUT}

# Run the test
echo "Running command: jmeter30/apache-jmeter.3.0/bin/jmeter -t ${TESTSCRIPT} -n -l ${TESTRESULTS} -JDIROUTPUT=${DIROUTPUT} -JSCENARIO=${SCENARIO} -JTESTIP=${TESTIP} -JPERFRESULTS=${PERFRESULTS}"
jmeter30/apache-jmeter-3.0/bin/jmeter -t ${TESTSCRIPT} -n -l ${TESTRESULTS} -JDIROUTPUT=${DIROUTPUT} -JSCENARIO=${SCENARIO} -JTESTIP=${TESTIP} -JPERFRESULTS=${PERFRESULTS}


# Generate the JMETER graphs
#echo "Generate Graphs: jmeter30/apache-jmeter-3.0/bin/jmeter -t ${GRAPHSCRIPT} -n -l output.csv -JTESTRESULTS=${TESTRESULTS} -JDIROUTPUT=${DIROUTPUT} -JFILEPREFIX=${PREFIX}"
#jmeter30/apache-jmeter-3.0/bin/jmeter -t ${GRAPHSCRIPT} -n -l output.csv -JTESTRESULTS=${TESTRESULTS} -JDIROUTPUT=${DIROUTPUT} -JFILEPREFIX=${FILEPREFIX}

# Generate Specific Graphs
GRAPHS=(ResponseTimesOverTime TransactionsPerSecond BytesThroughputOverTime ResponseTimesDistribution ResponseTimesPercentiles)
for i in "${GRAPHS[@]}"
do
echo "Generate ${i} graph: java -jar jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/${i}.png --input-jtl ${TESTRESULTS}  --plugin-type ${i} --width 800 --height 600 --auto-scale yes --relative-times no "
java -jar jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/${i}.png --input-jtl ${TESTRESULTS}  --plugin-type ${i} --width 800 --height 600 --auto-scale yes --relative-times no
done

# Generate PERFMON Graphs
echo "Generate Perf Graphs: java -jar jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png CPU.png --input-jtl ${PERFRESULTS}}  --plugin-type PerfMon --width 800 --height 600 --auto-scale yes --relative-times no --include-labels \".*CPU.*\" --include-label-regex true"
java -jar jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/CPU.png --input-jtl ${PERFRESULTS}  --plugin-type PerfMon --width 800 --height 600 --auto-scale yes --relative-times no --include-labels ".*CPU.*" --include-label-regex true
echo "Generate Perf Graphs: java -jar jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png Memory.png --input-jtl ${PERFRESULTS}  --plugin-type PerfMon --width 800 --height 600 --auto-scale yes --relative-times no --include-labels \".*Memory.*\" --include-label-regex true"
java -jar jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/Memory.png --input-jtl ${PERFRESULTS}  --plugin-type PerfMon --width 800 --height 600 --auto-scale yes --relative-times no --include-labels ".*Memory.*" --include-label-regex true