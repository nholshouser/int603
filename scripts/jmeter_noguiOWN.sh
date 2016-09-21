#!/bin/bash
#TE
TESTSCRIPT=/C/INT603/test603/scripts/INT603_XITEST.jmx
GRAPHSCRIPT=/C/INT603/test603/scripts/GraphsGenerator.jmx
echo -e "Input test scenario name followed by [ENTER]:"
read SCENARIO
echo "SCENARIO=${SCENARIO}"
DATE=$(/bin/date +%Y%m%d_%H%M)
#TE or Monsoon 
DIROUTPUT=/C/INT603/test603/csv/${DATE}_${SCENARIO}
WINDIR=C:\\INT603\\test603\\csv\\${DATE}_${SCENARIO}
echo "DIROUTPUT: ${DIROUTPUT}"
echo "WINDIR: ${WINDIR}"
#TE
TESTRESULTS=${DIROUTPUT}/${SCENARIO}.csv
PERFRESULTS=${DIROUTPUT}/PERFMON.csv
GRAPHRESULTS=C:\\INT603\\test603\\csv\\${DATE}_${SCENARIO}\\${SCENARIO}.csv
#LOCAL
PREFIX=${SCENARIO}-
export DIROUTPUT
export WINDIR
export TESTRESULTS
export PREFIX
export PERFRESULTS
# Make Directory
mkdir ${DIROUTPUT}
# Run the test
echo "Running command: /C/INT603/test603/jmeter30/apache-jmeter.3.0/bin/jmeter -t ${TESTSCRIPT} -n -l ${TESTRESULTS} -JPERFRESULTS=${PERFRESULTS} -JWINDIR=${WINDIR} -JSCENARIO=${SCENARIO}"
/C/INT603/test603/jmeter30/apache-jmeter-3.0/bin/jmeter -t ${TESTSCRIPT} -n -l ${TESTRESULTS} -JPERFRESULTS=${PERFRESULTS} -JWINDIR=${WINDIR} -JSCENARIO=${SCENARIO}
# Generate the JMETER Plugin graphs
echo "Generate Plugin Graphs: /C/INT603/test603/jmeter30/apache-jmeter-3.0/bin/jmeter -t ${GRAPHSCRIPT} -n -l output.csv -JGRAPHRESULTS=${GRAPHRESULTS} -JWINDIR=${WINDIR} -JFILEPREFIX=${PREFIX}"
/C/INT603/test603/jmeter30/apache-jmeter-3.0/bin/jmeter -t ${GRAPHSCRIPT} -n -l output.csv -JGRAPHRESULTS=${GRAPHRESULTS} -JWINDIR=${WINDIR} -JFILEPREFIX=${PREFIX}
# Generate Specific CMDRunner Graphs
GRAPHS=(ResponseTimesOverTime TransactionsPerSecond BytesThroughputOverTime ResponseTimesDistribution ResponseTimesPercentiles)
for i in "${GRAPHS[@]}"
do
echo "Generate CMDRunner ${i} graph: java -jar jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/${i}.png --input-jtl ${TESTRESULTS}  --plugin-type ${i} --width 800 --height 600 --auto-scale yes --relative-times no "
java -jar ../jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/${i}.png --input-jtl ${TESTRESULTS}  --plugin-type ${i} --width 800 --height 600 --auto-scale yes --relative-times no
done
# Generate PERFMON Graphs
echo "Generate Perf Graphs: java -jar /C/INT603/test603/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png CPU.png --input-jtl PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels \".*CPU.*\" --include-label-regex true"
java -jar /C/INT603/test603/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/CPU.png --input-jtl ${DIROUTPUT}/PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels ".*CPU.*" --include-label-regex true
echo "Generate Perf Graphs: java -jar /C/INT603/test603/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png Memory.png --input-jtl PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels \".*Memory.*\" --include-label-regex true"java -jar /C/INT603/test603/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/Memory.png --input-jtl ${DIROUTPUT}/PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels ".*Memory.*" --include-label-regex true