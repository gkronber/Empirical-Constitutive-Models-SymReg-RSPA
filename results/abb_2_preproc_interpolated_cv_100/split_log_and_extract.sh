#!/bin/bash

for fold in $(seq 0 7); do
   gzip -dc ${fold}/run_0.txt.gz | \
      sed -nr 's/.* ([[:digit:]]+) best front \[(.+)\] mse_test ([^ ]+) .*/\1,\2,\3/p' \
      > "fold_${fold}_pareto.csv"
   gzip -dc ${fold}/run_0.txt.gz | \
      sed -nr 's/.* ([[:digit:]]+) best front \[(.+), (.+)\] mse_test ([^ ]+) (.*)/\1;\2;\3;\4;\5/p' \
      | mlr --csv --ifs ';' --ofs ','  --implicit-csv-header rename 1,generation,2,mse,3,length,4,msetest,5,expr \
         then clean-whitespace \
         then top -n 1 --min -f mse -g length -a \
         then sort -n length \
      > "fold_${fold}_best_expr.csv"
done

mlr --csv --fs ',' stats1 -a mean,stddev,count -f msetest -g length \
   then put '$cv_stderr=$msetest_stddev/sqrt($msetest_count)' \
   then rename msetest_mean,cv_score \
   then cut -f length,cv_score,cv_stderr \
   fold_*_best_expr.csv \
   > "cv_scores.csv"

for run in $(seq 0 3); do
   gzip -dc all/run_0_$run.txt.gz | \
      sed -nr 's/.* ([[:digit:]]+) best front \[(.+)\] mse_test ([^ ]+) .*/\1,\2,\3/p' \
      > "all_${run}_pareto.csv"
   gzip -dc all/run_0_$run.txt.gz | \
      sed -nr 's/.* ([[:digit:]]+) best front \[(.+), (.+)\] mse_test ([^ ]+) (.*)/\1;\2;\3;\4;\5/p' \
      | mlr --csv --ifs ';' --ofs ','  --implicit-csv-header rename 1,generation,2,mse,3,length,4,msetest,5,expr \
         then clean-whitespace \
         then top -n 1 --min -f mse -g length -a \
         then sort -n length \
      > "all_${run}_best_expr.csv"
done

mlr --csv --fs ',' stats1 -a mean,stddev,count -f mse -g length \
   then put '$stderr=$mse_stddev/sqrt($mse_count)' \
   then cut -f length,mse_mean,stderr \
   all_*_best_expr.csv \
   > "all_train_mse.csv"