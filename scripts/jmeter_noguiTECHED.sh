#!/bin/bash

# for Monsoon
# export PATH=$PATH:/d/software/java/sapjvm_7/bin

#TE
TESTSCRIPT=/D/Files/Session/INT603/test603/scripts/INT603_XITEST.jmx
GRAPHSCRIPT=/D/Files/Session/INT603/test603/scripts/GraphsGenerator.jmx


echo -e "Input test scenario name followed by [ENTER]:"
read SCENARIO
echo "SCENARIO=${SCENARIO}"

DATE=$(/bin/date +%Y%m%d_%H%M)

#TE
DIROUTPUT=/D/Files/Session/INT603/test603/csv/${DATE}_${SCENARIO}
WINDIR=D:\\Files\\Session\\INT603\\test603\\csv\\${DATE}_${SCENARIO}

echo "DIROUTPUT: ${DIROUTPUT}"
echo "WINDIR: ${WINDIR}"

#TE
TESTRESULTS=${DIROUTPUT}/${SCENARIO}.csv
PERFRESULTS=${DIROUTPUT}/PERFMON.csv
GRAPHRESULTS=D:\\Files\\Session\\INT603\\test603\\csv\\${DATE}_${SCENARIO}\\${SCENARIO}.csv
PREFIX=${SCENARIO}-

export DIROUTPUT
export WINDIR
export TESTRESULTS
export PREFIX
export PERFRESULTS

# Make Directory
mkdir ${DIROUTPUT}

# Run the test
echo "Running command: /D/Files/Session/INT603/test603/jmeter30/apache-jmeter.3.0/bin/jmeter -t ${TESTSCRIPT} -n -l ${TESTRESULTS} -JPERFRESULTS=${PERFRESULTS} -JWINDIR=${WINDIR} -JSCENARIO=${SCENARIO}"
/D/Files/Session/INT603/test603/jmeter30/apache-jmeter-3.0/bin/jmeter -t ${TESTSCRIPT} -n -l ${TESTRESULTS} -JPERFRESULTS=${PERFRESULTS} -JWINDIR=${WINDIR} -JSCENARIO=${SCENARIO}


# Generate the JMETER graphs
# echo "Generate Graphs: /D/Files/Session/INT603/test603/jmeter30/apache-jmeter-3.0/bin/jmeter -t ${GRAPHSCRIPT} -n -l output.csv -JGRAPHRESULTS=${GRAPHRESULTS} -JWINDIR=${WINDIR} -JFILEPREFIX=${PREFIX}"
# /D/Files/Session/INT603/test603/jmeter30/apache-jmeter-3.0/bin/jmeter -t ${GRAPHSCRIPT} -n -l output.csv -JGRAPHRESULTS=${GRAPHRESULTS} -JWINDIR=${WINDIR} -JFILEPREFIX=${PREFIX}

# Generate Specific Graphs
GRAPHS=(ResponseTimesOverTime TransactionsPerSecond BytesThroughputOverTime ResponseTimesDistribution ResponseTimesPercentiles)
for i in "${GRAPHS[@]}"
do
echo "Generate ${i} graph: java -jar jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/${i}.png --input-jtl ${TESTRESULTS}  --plugin-type ${i} --width 800 --height 600 --auto-scale yes --relative-times no "
java -jar ../jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/${i}.png --input-jtl ${TESTRESULTS}  --plugin-type ${i} --width 800 --height 600 --auto-scale yes --relative-times no
done


# Generate PERFMON Graphs
echo "Generate Perf Graphs: java -jar /D/Files/Session/INT603/test603/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png CPU.png --input-jtl PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels \".*CPU.*\" --include-label-regex true"
echo "Generate Perf Graphs: java -jar /D/Files/Session/INT603/test603/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png Memory.png --input-jtl PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels \".*Memory.*\" --include-label-regex true"
java -jar /D/Files/Session/INT603/test603/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/CPU.png --input-jtl ${DIROUTPUT}/PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels ".*CPU.*" --include-label-regex true
java -jar /D/Files/Session/INT603/test603/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/Memory.png --input-jtl ${DIROUTPUT}/PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels ".*Memory.*" --include-label-regex true