# all plots for the paper

#set terminal tikz latex size 134mm,70mm color standalone font ",8" 
set terminal cairolatex eps size 5.2,3.2 color standalone font ",8"

set datafile separator comma

# line styles for ColorBrewer PuBuGn
# for use with sequential data
# provides 8 purple-blue-green colors of increasing saturation
# compatible with gnuplot >=4.2
# author: Anna Schneider

# line styles
set style line 1 lt 1 lc rgb '#FFF7FB' # very light purple-blue-green
set style line 2 lt 1 lc rgb '#ECE2F0' # 
set style line 3 lt 1 lc rgb '#D0D1E6' # 
set style line 4 lt 1 lc rgb '#A6BDDB' # light purple-blue-green
set style line 5 lt 1 lc rgb '#67A9CF' # 
set style line 6 lt 1 lc rgb '#3690C0' # medium purple-blue-green
set style line 7 lt 1 lc rgb '#02818A' #
set style line 8 lt 1 lc rgb '#016540' # dark purple-blue-green

# palette
set palette defined ( 0 '#FFF7FB',\
    	    	      1 '#ECE7F0',\
		      2 '#D0D1E6',\
		      3 '#A6BDDB',\
		      4 '#67A9CF',\
		      5 '#3690C0',\
		      6 '#02818A',\
		      7 '#016540' )

load "models.plt"

###############
# Scatter plots
###############
set output "scatterplots.tex"
set multiplot layout 2,3 margins 0.1,0.99,0.20,0.99 spacing 0.1,0.1
unset xlabel
set ylabel "Prediction"
set xtics 200
set ytics 200
plot '../data/2025/abb_2_preproc_with_outliers.csv' using 4:(f_steel_simpl($1,$2,$3,log10($3))) with dots lc 2 notitle,\
     x with lines lc black dt '-' notitle

unset ylabel
plot '../data/2025/abb_2_preproc_with_outliers_tomax.csv' using 4:(f_steel_tomax_simple($1,$2,$3,log10($3))) with dots lc 2 notitle,\
     x with lines lc black dt '-' notitle

set multiplot next
set ylabel "Prediction"
set xlabel "Target"

set xtics 20
set ytics 20
# 1         2            3      4  5   6    7    8   9
#filename,temp_setpoint,phip,yield,id,time,temp,phi,kf
plot '../data/2019_Kolody/AA6082_all_temps_combined.csv' using 9:(f_aa_simple($7,$8,$3,log10($3))) with dots lc 2 notitle,\
     x with lines lc black dt '-' notitle
unset ylabel
plot '../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv' using 9:(f_aa_tomax_simple($7,$8,$3,log10($3))) with dots lc 2 notitle,\
     x with lines lc black dt '-' notitle

plot '../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv' using 9:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with dots lc 2 notitle,\
     x with lines lc black dt '-' notitle

unset ylabel

unset multiplot


####################
# Line charts Steel full
####################
set terminal cairolatex eps size 5.2,1.6  color  standalone font ",8"

set output "linechart-steel-abb2.tex"
set multiplot layout 1,3 margins 0.1,0.99,0.25,0.99 spacing 0.05,0.1
# 5e-5 1e-4 1e-3"
unset xrange
unset yrange

set yrange[0:700]
set xrange[0:]
set ytics auto
set xtics 0.1,0.1

set ylabel "P [MPa]"
set xlabel "$\\varepsilon$"
plot "< mlr --csv --from ../data/2025/abb_2_preproc_with_outliers.csv filter '$epsp == 5e-5' then gap -g temp | sed 's/,,,//g'" using 2:4 with points ps 0.4 lc 2 notitle,\
     '' using 2:(f_steel_simpl($1,$2,$3,log10($3))) with lines lc 1 lw 2 notitle

unset ylabel
set ytics format ""

plot "< mlr --csv --from ../data/2025/abb_2_preproc_with_outliers.csv filter '$epsp == 1e-4' then gap -g temp | sed 's/,,,//g' " using 2:4 with points ps 0.4 lc 2 notitle,\
     '' using 2:(f_steel_simpl($1,$2,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2025/abb_2_preproc_with_outliers.csv filter '$epsp == 1e-3' then gap -g temp | sed 's/,,,//g' " using 2:4 with points ps 0.4 lc 2 title "data",\
     '' using 2:(f_steel_simpl($1,$2,$3,log10($3))) with lines lc 1 lw 2 title "f(x)"
     
unset multiplot 

# repeat for logscale
set output "linechart-steel-abb2_logscale.tex"
set multiplot layout 1,3 margins 0.1,0.99,0.25,0.99 spacing 0.05,0.1
# 5e-5 1e-4 1e-3"

set key top left
set yrange[0:700]
set xrange[1e-5:]
set ytics auto
set xtics auto
set ytics format
set xtics format "%1.0e"
set logscale x
set ylabel "P [MPa]"
set xlabel "$\\varepsilon$"
plot "< mlr --csv --from ../data/2025/abb_2_preproc_with_outliers.csv filter '$epsp == 5e-5' then gap -g temp | sed 's/,,,//g'" using 2:4 with points ps 0.4 lc 2 notitle,\
     '' using 2:(f_steel_simpl($1,$2,$3,log10($3))) with lines lc 1 lw 2 notitle

unset ylabel
set ytics format "" 

plot "< mlr --csv --from ../data/2025/abb_2_preproc_with_outliers.csv filter '$epsp == 1e-4' then gap -g temp | sed 's/,,,//g' " using 2:4 with points ps 0.4 lc 2 notitle,\
     '' using 2:(f_steel_simpl($1,$2,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2025/abb_2_preproc_with_outliers.csv filter '$epsp == 1e-3' then gap -g temp | sed 's/,,,//g' " using 2:4 with points ps 0.4 lc 2 title "data",\
     '' using 2:(f_steel_simpl($1,$2,$3,log10($3))) with lines lc 1 lw 2 title "f(x)"
     
unset multiplot 



####################
# Line charts Steel tomax
####################
set terminal cairolatex eps size 5.2,1.6  color  standalone font ",8"

unset logscale x

set output "linechart-steel-abb2-tomax.tex"
set multiplot layout 1,3 margins 0.1,0.99,0.25,0.99 spacing 0.05,0.1
# 5e-5 1e-4 1e-3"
unset xrange
unset yrange

set yrange[0:800]
set xrange[0:]
set ytics auto
set ytics format "%.0f"
set xtics 0.01,0.01
set xtics format "%.2f"
set key bottom right

set ylabel "P [MPa]"
set xlabel "$\\varepsilon$"
plot "< mlr --csv --from ../data/2025/abb_2_preproc_with_outliers_tomax.csv filter '$epsp == 5e-5' then gap -g temp | sed 's/,,,//g'" using 2:4 with points ps 0.4 lc 2 notitle,\
     '' using 2:(f_steel_tomax_simple($1,$2,$3,log10($3))) with lines smooth csplines lc 1 lw 2 notitle

unset ylabel
set ytics format ""

set xtics 0.01,0.01
set xtics format "%.2f"

plot "< mlr --csv --from ../data/2025/abb_2_preproc_with_outliers_tomax.csv filter '$epsp == 1e-4' then gap -g temp | sed 's/,,,//g' " using 2:4 with points ps 0.4 lc 2 notitle,\
     '' using 2:(f_steel_tomax_simple($1,$2,$3,log10($3))) with lines smooth csplines lc 1 lw 2 notitle

set xtics 0.005,0.005
set xtics format "%.3f"

plot "< mlr --csv --from ../data/2025/abb_2_preproc_with_outliers_tomax.csv filter '$epsp == 1e-3' then gap -g temp | sed 's/,,,//g' " using 2:4 with points ps 0.4 lc 2 title "data",\
     '' using 2:(f_steel_tomax_simple($1,$2,$3,log10($3))) with lines smooth csplines lc 1 lw 2 title "f(x)"
     
unset multiplot 

# repeat for logscale
set output "linechart-steel-abb2-tomax_logscale.tex"
set multiplot layout 1,3 margins 0.1,0.99,0.25,0.99 spacing 0.05,0.1
# 5e-5 1e-4 1e-3"

set key top left
set yrange[0:800]
set xrange[1e-5:]
set ytics auto
set xtics auto
set ytics format
set xtics format "%1.0e"
set logscale x
set ylabel "P [MPa]"
set xlabel "$\\varepsilon$"
plot "< mlr --csv --from ../data/2025/abb_2_preproc_with_outliers_tomax.csv filter '$epsp == 5e-5' then gap -g temp | sed 's/,,,//g'" using 2:4 with dots lc 2 notitle,\
     '' using 2:(f_steel_tomax_simple($1,$2,$3,log10($3))) with lines lc 1 lw 2 notitle

unset ylabel
set ytics format "" 

plot "< mlr --csv --from ../data/2025/abb_2_preproc_with_outliers_tomax.csv filter '$epsp == 1e-4' then gap -g temp | sed 's/,,,//g' " using 2:4 with dots lc 2 notitle,\
     '' using 2:(f_steel_tomax_simple($1,$2,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2025/abb_2_preproc_with_outliers_tomax.csv filter '$epsp == 1e-3' then gap -g temp | sed 's/,,,//g' " using 2:4 with dots lc 2 title "data",\
     '' using 2:(f_steel_tomax_simple($1,$2,$3,log10($3))) with lines lc 1 lw 2 title "f(x)"
     
unset multiplot 


set output "linechart-alu.tex"
set multiplot layout 1,5 margins 0.1,0.99,0.25,0.99 spacing 0.01,0.1
# phip 0.001 0.01 0.1 1 10"
unset xrange
unset yrange
unset logscale x

set key bottom right
set yrange[0:100]
set xrange[0:]
set ytics auto
set xtics 0.1,0.1

set ylabel "kf [MPa]"
set xlabel "$\\varphi$"
plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 0.001' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

unset ylabel
set ytics format ""

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 0.01' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 0.1' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 1' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 10' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 title "data",\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 title "f(x)"

unset multiplot 


set output "linechart-alu_logscale.tex"
set multiplot layout 1,5 margins 0.1,0.99,0.25,0.99 spacing 0.01,0.1
# phip 0.001 0.01 0.1 1 10"
unset xrange
unset yrange
set logscale x

set key top left
set yrange[0:100]
set xrange[1e-3:]
set ytics auto
set xtics 0.1,0.1

set ylabel "kf [MPa]"
set xlabel "$\\varphi$"
plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 0.001' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 title "data",\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 title "f(x)"

unset ylabel
set ytics format ""

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 0.01' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 0.1' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 1' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 10' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

unset multiplot 



set output "linechart-alu-tomax.tex"
set multiplot layout 1,5 margins 0.1,0.99,0.25,0.99 spacing 0.01,0.1
# phip 0.001 0.01 0.1 1 10"
unset xrange
unset yrange
unset logscale x

set key bottom right
set yrange[0:100]
set xrange[0:]
set ytics auto
set xtics 0.1,0.1

set ylabel "kf [MPa]"
set xlabel "$\\varphi$"
plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 0.001' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

unset ylabel
set ytics format ""

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 0.01' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 0.1' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 1' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 10' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 title "data",\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 title "f(x)"

unset multiplot 


set output "linechart-alu-tomax_logscale.tex"
set multiplot layout 1,5 margins 0.1,0.99,0.25,0.99 spacing 0.01,0.1
# phip 0.001 0.01 0.1 1 10"
unset xrange
unset yrange
set logscale x

set key top left
set yrange[0:100]
set xrange[1e-3:]
set ytics auto
set xtics 0.1,0.1

set ylabel "kf [MPa]"
set xlabel "$\\varphi$"
plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 0.001' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 title "data",\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 title "f(x)"

unset ylabel
set ytics format ""

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 0.01' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 0.1' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 1' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 10' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with dots lc 2 notitle,\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

unset multiplot 



####################
# Line charts 2 rows
####################
set terminal cairolatex eps size 5.2,3  color  standalone font ",8"
set output "linechart-alu-2row.tex"
set multiplot layout 2,3 margins 0.1,0.99,0.20,0.99 spacing 0.05,0.05
# phip 0.001 0.01 0.1 1 10"
unset xrange
unset yrange
unset logscale x

set key bottom right
set yrange[0:60]
set xrange[0:]
set ytics auto

set xtics format ""
set ytics format "%.0f"

unset xlabel
set ylabel "kf [MPa]"
plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 0.001' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with points ps 0.4 lc 2 notitle,\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

unset ylabel
set ytics format ""

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 0.01' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with points ps 0.4 lc 2 notitle,\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

set ylabel "kf [MPa]"
set ytics format "%.0f"
set multiplot next 
set yrange[0:100]
set xtics 0.1,0.1
set xtics format "%.1f"
set xlabel "$\\varphi$"

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 0.1' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with points ps 0.4 lc 2 notitle,\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

unset ylabel
set ytics format ""

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 1' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with points ps 0.4 lc 2 notitle,\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined.csv filter '$phip == 10' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with points ps 0.4 lc 2 title "data",\
     '' using 8:(f_aa_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 title "f(x)"

unset multiplot 


set output "linechart-alu-tomax-2row.tex"
set multiplot layout 2,3 margins 0.1,0.99,0.20,0.99 spacing 0.05,0.10
# phip 0.001 0.01 0.1 1 10"
unset xrange
unset yrange
unset logscale x

set key bottom right
set yrange[0:60]
set xrange[0:0.05]
set ytics auto
set xtics 0.01,0.01

set ylabel "kf [MPa]"
set ytics format "%.0f"
unset xlabel
set xtics format "%.2f"
plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 0.001' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with  points ps 0.4 lc 2 notitle,\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

unset ylabel
set ytics format ""
set xrange[0:0.1]
set xtics 0.02,0.02
plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 0.01' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with  points ps 0.4 lc 2 notitle,\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

set multiplot next 
set yrange[0:100]
set xtics format "%.1f"
set xtics 0.05,0.05
set xrange[0:0.2]
set xlabel "$\\varphi$"
set ylabel "kf [MPa]"
set ytics format "%.0f"

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 0.1' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with  points ps 0.4 lc 2 notitle,\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

unset ylabel
set ytics format ""

set xrange[0:0.3]
plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 1' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with  points ps 0.4 lc 2 notitle,\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 notitle

plot "< mlr --csv --from ../data/2019_Kolody/AA6082_all_temps_combined_tomax.csv filter '$phip == 10' then gap -g temp_setpoint | sed 's/,,,,,,,,//g'" using 8:9 with  points ps 0.4 lc 2 title "data",\
     '' using 8:(f_aa_tomax_long_simple($7,$8,$3,log10($3))) with lines lc 1 lw 2 title "f(x)"

unset multiplot 

##################################
# Cross-validation Pareto fronts, all four
##################################

set terminal cairolatex eps size 5.2,5  color  standalone font ",8"

set output "pareto_fronts_all.tex"

set ylabel "CV score"
set xlabel "Length"

set logscale y
unset logscale x
set xtics auto
set ytics auto
set xrange [1:100]
# set yrange [0:10]
unset yrange


set multiplot layout 2,2  margins 0.1,0.99,0.22,0.8 spacing 0.1,0.1
# set title "AA6082 (to maximum stress, all temperatures)" 
# _best_expr: generation,mse,length,msetest,expr
set errorbars 0.2

# plot '../results/AA6082_GECCO_2021_interpolated_tomax_cv_100/cv_scores.csv' using 1:2:3 with yerrorbars lt 2 pt 0 notitle,\
#      # keyentry with lines lt 1 title "Training",\
#      # keyentry with lines lt 2 title "CV score (+/- $\\sigma_\\text{err}$)"
# 
# 
#      # this is for training errors
#      # for [fold=0:7] '../results/AA6082_GECCO_2021_interpolated_tomax_cv_100/fold_'.fold.'_best_expr.csv' using 3:2 with lines lt 1 notitle,\
#      # this is for checking the training mse for the full dataset (should follow training mse in cv-folds)
#      # '../results/AA6082_GECCO_2021_interpolated_tomax_cv_100/all_train_mse.csv' using 1:2:3 with yerrorbars lt 3 pt 0 notitle,\
#      # this is for the individual cv results
#      # for [fold=0:7] '../results/AA6082_GECCO_2021_interpolated_tomax_cv_100/fold_'.fold.'_best_expr.csv' using 3:4 with points pt 1 lt 2 ps 0.1 notitle,\
# 
# set title "AA6082 (full curve, all temperatures)" 
# plot for [fold=0:7] '../results/AA6082_GECCO_2021_interpolated_cv_100/fold_'.fold.'_best_expr.csv' using 3:2:1 with lines lt 1 notitle,\
#      '../results/AA6082_GECCO_2021_interpolated_cv_100/cv_scores.csv' using 1:2:3 with yerrorbars lt 2 pt 0 notitle,\
#      keyentry with lines lt 1 title "Training",\
#      keyentry with lines lt 2 title "Test"
# #     for [fold=0:7] '../results/AA6082_GECCO_2021_interpolated_cv_100/fold_'.fold.'_best_expr.csv' using 3:4:1 with lines lt 2 lw 0.5 notitle,\
# #     '../results/AA6082_GECCO_2021_interpolated_cv_100/all_train_mse.csv' using 1:2:3 with yerrorbars lt 3 pt 0 notitle,\
# 

set xtics 20,20
set xtics format ""
set ytics format "%.0e"
unset xlabel 

set arrow 1 from 1,0.31968410513776097 to 100,0.31968410513776097 dt '..' nohead
set arrow 2 from 64,0.1 to 64,1000 dt '-' nohead
set title "AA6082 (full curve)" 
plot '../results/AA6082_GECCO_2021_interpolated_gt350_cv_100/cv_scores.csv' using 1:2:($2-$3):($2+$3) with yerrorbars lt 2 pt 0 notitle,\
   #keyentry with lines lt 1 title "Training",\
   #keyentry with lines lt 2 title "Test"

# for [fold=0:7] '../results/AA6082_GECCO_2021_interpolated_gt350_cv_100/fold_'.fold.'_best_expr.csv' using 3:2:1 with lines lt 1 notitle,\
#     for [fold=0:7] '../results/AA6082_GECCO_2021_interpolated_gt350_cv_100/fold_'.fold.'_best_expr.csv' using 3:4:1 with lines lt 2 lw 0.5 notitle,\
#     '../results/AA6082_GECCO_2021_interpolated_gt350_cv_100/all_train_mse.csv' using 1:2:($2-$3):($2+$3) with yerrorbars lt 3 pt 0 notitle,\

unset ylabel


set arrow 1 from 1,0.511481 to 100,0.511481 dt '..' nohead
set arrow 2 from 62,0.1 to 62,1000 dt '-' nohead
set arrow 3 from 89,0.1 to 89,1000 dt '..' nohead
set title "AA6082 (to maximum)" 
plot '../results/AA6082_GECCO_2021_interpolated_gt350_tomax_cv_100/cv_scores.csv' using 1:2:($2-$3):($2+$3) with yerrorbars lt 2 pt 0 notitle,\
     #keyentry with lines lt 1 title "Training",\
     #keyentry with lines lt 2 title "Test"

#for [fold=0:7] '../results/AA6082_GECCO_2021_interpolated_gt350_tomax_cv_100/fold_'.fold.'_best_expr.csv' using 3:2:1 with lines lt 1 notitle,\
#     for [fold=0:7] '../results/AA6082_GECCO_2021_interpolated_gt350_tomax_cv_100/fold_'.fold.'_best_expr.csv' using 3:4:1 with lines lt 2 lw 0.5 notitle,\
#     '../results/AA6082_GECCO_2021_interpolated_gt350_tomax_cv_100/all_train_mse.csv' using 1:2:($2-$3):($2+$3) with yerrorbars lt 3 pt 0 notitle,\

set ylabel "CV Score"
set xlabel "Expression length"
set xtics format "%.0f"
unset yrange

set arrow 1 from 1,278 to 100,278 dt '..' nohead
set arrow 2 from 17,100 to 17,1000000 dt '-' nohead
set arrow 3 from 18,100 to 18,1000000 dt '..' nohead

set title "X20CrMoV12 (full curve)" 
plot '../results/abb_2_preproc_interpolated_cv_100/cv_scores.csv' using 1:2:($2-$3):($2+$3) with yerrorbars lt 2 pt 0 notitle,\

unset ylabel

set arrow 1 from 1,459.5 to 100,459.5 dt '..' nohead
set arrow 2 from 9,100 to 9,1000000000 dt '-' nohead
unset arrow 3
# set arrow 3 from 9,100 to 9,1000000 dt '..' nohead
set title "X20CrMoV12 (to maximum)" 
plot '../results/abb_2_preproc_interpolated_tomax_cv_100/cv_scores.csv' using 1:2:($2-$3):($2+$3) with yerrorbars lt 2 pt 0 notitle,\

unset multiplot


##################################
# Cross-validation Pareto fronts, single
##################################

set terminal cairolatex eps size 5.2,2.5  color  standalone font ",8"

set output "pareto_fronts_example.tex"

set ylabel "CV score"
set xlabel "Length"

set logscale y
unset logscale x
set xtics auto
set ytics auto
set ytics format "%.0f"
set xtics format
set xrange [1:100]
# set yrange [0:10]
unset yrange

# set title "AA6082 (to maximum stress, all temperatures)" 
# _best_expr: generation,mse,length,msetest,expr
set errorbars small
unset pointintervalbox
set arrow 1 from 1,0.511481 to 100,0.511481 dt '..' nohead
set arrow 2 from 62,0.1 to 62,1000 dt '-' nohead
set arrow 3 from 89,0.1 to 89,1000 dt '..' nohead
set title "AA6082 (to maximum)" 
plot '../results/AA6082_GECCO_2021_interpolated_gt350_tomax_cv_100/cv_scores.csv' using 1:2:($2-$3):($2+$3) with yerrorbars lt 2 lw 2 pt 1 ps 0.2 notitle,\
     #keyentry with lines lt 1 title "Training",\
     #keyentry with lines lt 2 title "Test"

#for [fold=0:7] '../results/AA6082_GECCO_2021_interpolated_gt350_tomax_cv_100/fold_'.fold.'_best_expr.csv' using 3:2:1 with lines lt 1 notitle,\
#     for [fold=0:7] '../results/AA6082_GECCO_2021_interpolated_gt350_tomax_cv_100/fold_'.fold.'_best_expr.csv' using 3:4:1 with lines lt 2 lw 0.5 notitle,\
#     '../results/AA6082_GECCO_2021_interpolated_gt350_tomax_cv_100/all_train_mse.csv' using 1:2:($2-$3):($2+$3) with yerrorbars lt 3 pt 0 notitle,\

