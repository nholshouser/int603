#!/bin/bash

#TE
#TESTSCRIPT=/D/Files/Session/INT603/test603/scripts/INT603_XITEST.jmx
#GRAPHSCRIPT=/D/Files/Session/INT603/test603/scripts/GraphsGenerator.jmx

#LOCAL
TESTSCRIPT=/c/software/GIT/int603/int603/scripts/INT603_XITEST_LOCAL.jmx
GRAPHSCRIPT=/c/software/GIT/GraphsGenerator.jmx

echo -e "Input test scenario name followed by [ENTER]:"
read SCENARIO
echo "SCENARIO=${SCENARIO}"

echo -e "Input IP Address of Server to test"
read TESTIP
echo "Server IP: ${TESTIP}"

DATE=$(/bin/date +%Y%m%d_%H%M)

#TE
#DIROUTPUT=/D/Files/Session/INT603/test603/scripts/${DATE}_${SCENARIO}
#WINDIR=D:\\Files\\Session\\INT603\\test603\\csv\\${DATE}_${SCENARIO}


#LOCAL
DIROUTPUT=/c/software/GIT/csv/${DATE}_${SCENARIO}
WINDIR=c:\\software\\GIT\\csv\\${DATE}_${SCENARIO}
echo "DIROUTPUT: ${DIROUTPUT}"
echo "WINDIR: ${WINDIR}"

#TE
#TESTRESULTS=${DIROUTPUT}/${SCENARIO}.csv
#GRAPHRESULTS=D:\\Files\\Session\\INT603\\test603\\csv\\${DATE}_${SCENARIO}\\${SCENARIO}.csv


#LOCAL
TESTRESULTS=${DIROUTPUT}/${SCENARIO}.csv
GRAPHRESULTS=c:\\software\\GIT\\csv\\${DATE}_${SCENARIO}\\${SCENARIO}.csv
PREFIX=${SCENARIO}-


# Export variables
export DIROUTPUT
export TESTRESULTS
export GRAPHSCRIPT
export PERFRESULTS
export PREFIX
export TESTIP


# Make Directory
mkdir ${DIROUTPUT}

# Run the test
echo "Running command: /c/software/jmeter30/apache-jmeter.3.0/bin/jmeter -t ${TESTSCRIPT} -n -l ${TESTRESULTS} -JWINDIR=${WINDIR} -JSCENARIO=${SCENARIO}"
#/c/software/jmeter30/apache-jmeter-3.0/bin/jmeter -t ${TESTSCRIPT} -n -l ${TESTRESULTS} -JWINDIR=${WINDIR} -JSCENARIO=${SCENARIO}
/c/software/jmeter30/apache-jmeter-3.0/bin/jmeter -t ${TESTSCRIPT} -n -l /c/software/GIT/int603/demo/${SCENARIO}.csv -JDIROUTPUT=${DIROUTPUT} -JSCENARIO=${SCENARIO} -JTESTIP=${TESTIP} -JPERFRESULTS=${PERFRESULTS}

# Generate the JMETER graphs
# echo "Generate Graphs: /c/software/jmeter30/apache-jmeter-3.0/bin/jmeter -t ${GRAPHSCRIPT} -n -l output.csv -JGRAPHRESULTS=${GRAPHRESULTS} -JWINDIR=${WINDIR} -JFILEPREFIX=${PREFIX}"
# /c/software/jmeter30/apache-jmeter-3.0/bin/jmeter -t ${GRAPHSCRIPT} -n -l output.csv -JGRAPHRESULTS=${GRAPHRESULTS} -JWINDIR=${WINDIR} -JFILEPREFIX=${PREFIX}
# Generate Specific Graphs

GRAPHS=(ResponseTimesOverTime TransactionsPerSecond BytesThroughputOverTime ResponseTimesDistribution ResponseTimesPercentiles)
for i in "${GRAPHS[@]}"
do
echo "Generate ${i} graph: java -jar jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/${i}.png --input-jtl ${TESTRESULTS}  --plugin-type ${i} --width 800 --height 600 --auto-scale yes --relative-times no "
java -jar /c/software/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png /c/software/GIT/int603/demo/${i}.png --input-jtl /c/software/GIT/int603/demo/${SCENARIO}.csv  --plugin-type ${i} --width 800 --height 600 --auto-scale yes --relative-times no
done

# Generate PERFMON Graphs
# C:\software\GIT\int603\demo\demo.csv
echo "Generate Perf Graphs: java -jar /c/software/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png CPU.png --input-jtl PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels \".*CPU.*\" --include-label-regex true"
echo "Generate Perf Graphs: java -jar /c/software/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png Memory.png --input-jtl PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels \".*Memory.*\" --include-label-regex true"
#java -jar /c/software/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/CPU.png --input-jtl ${DIROUTPUT}/PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels ".*CPU.*" --include-label-regex true
#java -jar /c/software/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png ${DIROUTPUT}/Memory.png --input-jtl ${DIROUTPUT}/PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels ".*Memory.*" --include-label-regex true

java -jar /c/software/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png /c/software/GIT/int603/demo/CPU.png --input-jtl /c/software/GIT/int603/demo/PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels ".*CPU.*" --include-label-regex true
java -jar /c/software/jmeter30/apache-jmeter-3.0/lib/cmdrunner-2.0.jar --tool Reporter --generate-png /c/software/GIT/int603/demo/Memory.png --input-jtl /c/software/GIT/int603/demo/PERFMON.csv  --plugin-type PerfMon --width 640 --height 480 --auto-scale yes --relative-times no --include-labels ".*Memory.*" --include-label-regex true