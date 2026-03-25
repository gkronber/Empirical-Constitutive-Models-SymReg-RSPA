set terminal pdf

filename=ARG1



set output filename . ".pdf"

set xlabel "phi"
plot filename using 4:5 with dots title "kf"

set xlabel "idx"
plot filename using 0:3 with dots title "Temp"
plot filename using 0:4 with dots title "Phi"
plot filename using 0:5 with dots title "kf"