#!/bin/bash

# $ \dot{\varepsilon}\approx 5\!\times\! 10^{-5}\,\mathrm{s}^{-1} $
# 	\addplot+[thick] table {CRE387_extensometer_mean.txt};
# 	\addlegendentry{$ 673\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE383_extensometer_mean.txt};
# 	\addlegendentry{$ 723\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE400_extensometer_mean.txt};
# 	\addlegendentry{$ 773\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE391_extensometer_mean.txt};
# 	\addlegendentry{$ 823\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE380_extensometer_mean.txt};
# 	\addlegendentry{$ 873\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE405_extensometer_mean.txt};
# 	\addlegendentry{$ 923\,\mathrm{K} $};
# 
# $ \dot{\varepsilon}\approx 1\!\times\! 10^{-4}\,\mathrm{s}^{-1} $
# 	\addplot+[thick] table {CRE389_extensometer_mean.txt};
# 	\addlegendentry{$ 673\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE388_extensometer_mean.txt};
# 	\addlegendentry{$ 723\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE386_extensometer_mean.txt};
# 	\addlegendentry{$ 773\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE392_extensometer_mean.txt};
# 	\addlegendentry{$ 823\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE385_extensometer_mean.txt};
# 	\addlegendentry{$ 873\,\mathrm{K} $};
#     
#     
#     $ \dot{\varepsilon}\approx 1\!\times\! 10^{-3}\,\mathrm{s}^{-1} $
#     \addplot+[thick] table {CRE396_extensometer_mean.txt};
# 	\addlegendentry{$ 673\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE395_extensometer_mean.txt};
# 	\addlegendentry{$ 723\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE394_extensometer_mean.txt};
# 	\addlegendentry{$ 773\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE393_extensometer_mean.txt};
# 	\addlegendentry{$ 823\,\mathrm{K} $};
# 	\addplot+[thick] table {CRE390_extensometer_mean.txt};
# 	\addlegendentry{$ 873\,\mathrm{K} $};


# eps 5e-5

# outlier
# mlr --implicit-csv-header --csv --ifs '\t' --ofs ',' --from "Abb_2/cre387_extensometer_mean.txt" \
#     clean-whitespace \
#     then rename 1,eps,2,P \
#     then put '$epsp=5e-5; $temp=673' \
#     then template -f temp,eps,epsp,P
    
mlr --implicit-csv-header                         --csv --ifs '\t' --ofs ',' --from "Abb_2/cre383_extensometer_mean.txt" \
    clean-whitespace \
    then rename 1,eps,2,P \
    then put '$epsp=5e-5; $temp=723' \
    then template -f temp,eps,epsp,P
    
mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre400_extensometer_mean.txt" \
    clean-whitespace \
    then rename 1,eps,2,P \
    then put '$epsp=5e-5; $temp=773' \
    then template -f temp,eps,epsp,P
    
mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre391_extensometer_mean.txt" \
    clean-whitespace \
    then rename 1,eps,2,P \
    then put '$epsp=5e-5; $temp=823' \
    then template -f temp,eps,epsp,P
    
mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre380_extensometer_mean.txt" \
    clean-whitespace \
    then rename 1,eps,2,P \
    then put '$epsp=5e-5; $temp=873' \
    then template -f temp,eps,epsp,P

# extra  
# mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre405_extensometer_mean.txt" \
#     clean-whitespace \
#     then rename 1,eps,2,P \
#     then put '$epsp=5e-5; $temp=923' \
#     then template -f temp,eps,epsp,P
    


# eps 1e-4
mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre389_extensometer_mean.txt" \
    clean-whitespace \
    then rename 1,eps,2,P \
    then put '$epsp=1e-4; $temp=673' \
    then template -f temp,eps,epsp,P
    
mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre388_extensometer_mean.txt" \
    clean-whitespace \
    then rename 1,eps,2,P \
    then put '$epsp=1e-4; $temp=723' \
    then template -f temp,eps,epsp,P
    
mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre386_extensometer_mean.txt" \
    clean-whitespace \
    then rename 1,eps,2,P \
    then put '$epsp=1e-4; $temp=773' \
    then template -f temp,eps,epsp,P
    
mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre392_extensometer_mean.txt" \
    clean-whitespace \
    then rename 1,eps,2,P \
    then put '$epsp=1e-4; $temp=823' \
    then template -f temp,eps,epsp,P
    
mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre385_extensometer_mean.txt" \
    clean-whitespace \
    then rename 1,eps,2,P \
    then put '$epsp=1e-4; $temp=873' \
    then template -f temp,eps,epsp,P


# eps 1e-3
# outlier
# mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre396_extensometer_mean.txt" \
#     clean-whitespace \
#     then rename 1,eps,2,P \
#     then put '$epsp=1e-3; $temp=673' \
#     then template -f temp,eps,epsp,P
# 

mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre395_extensometer_mean.txt" \
    clean-whitespace \
    then rename 1,eps,2,P \
    then put '$epsp=1e-3; $temp=723' \
    then template -f temp,eps,epsp,P

# outlier
# mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre394_extensometer_mean.txt" \
#     clean-whitespace \
#     then rename 1,eps,2,P \
#     then put '$epsp=1e-3; $temp=773' \
#     then template -f temp,eps,epsp,P
    
mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre393_extensometer_mean.txt" \
    clean-whitespace \
    then rename 1,eps,2,P \
    then put '$epsp=1e-3; $temp=823' \
    then template -f temp,eps,epsp,P
    
mlr --implicit-csv-header --headerless-csv-output --csv --ifs '\t' --ofs ',' --from "Abb_2/cre390_extensometer_mean.txt" \
    clean-whitespace \
    then rename 1,eps,2,P \
    then put '$epsp=1e-3; $temp=873' \
    then template -f temp,eps,epsp,P
    
