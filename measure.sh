#!/bin/bash

# Example of usage: bash benchmark_stats.sh no-optimization 1 query1.sql

fout=$1
q=$2
qfile=$3
outdir=./measurements
sqldir=./SQL-files
niter=30

dbuser="postgres"
dbname="tpch"

echo "Enter the database password for user $dbuser:"
read -s dbpass

mkdir -p "$outdir"

echo "Running the query $q with the options: $fout"
echo -e "Query n. $q with the options: $fout\n" > "$outdir/q${q}-${fout}.txt"

for i in $(seq 1 $niter); do
    printf "iteration number $i:\n"  >> "$outdir/q${q}-${fout}.txt"
    { { time PGPASSWORD="$dbpass" psql -U "$dbuser" -d "$dbname" -a -f "$sqldir/$qfile" -h localhost >/dev/null ; } 2>> "$outdir/q${q}-${fout}.txt" ; }
    printf '\n' >>  "$outdir/q${q}-${fout}.txt"
done

echo "Calculating mean and standard deviation..."
awk '
    /real/ {
        split($2, arr, "m"); 
        split(arr[2], sec, "s"); 
        total_time = arr[1] * 60 + sec[1]; 
        time_sum += total_time; 
        time_sq_sum += total_time^2; 
        count++
    }
    END {
        time_mean = time_sum / count;
        std_dev = sqrt((time_sq_sum - time_sum^2 / count) / (count - 1));
        printf "Mean Execution Time: %f seconds\n", time_mean;
        printf "Standard Deviation of Execution Time: %f seconds\n", std_dev;
    }
' "$outdir/q${q}-${fout}.txt" > "$outdir/q${q}-${fout}-stats.txt"

cat "$outdir/q${q}-${fout}-stats.txt"
echo "Done"
