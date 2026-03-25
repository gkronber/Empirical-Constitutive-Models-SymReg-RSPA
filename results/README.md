The logs in this folder are produced by the script `../src/run_pyoperon.py`.

The logs in each folder for each dataset contain the results for each of the cross-validation folds (folder 0..7). As well as the run with the full dataset `all`. 

The runs using the full dataset as training set were performed four times.

The models reported in the paper and selected for the plots `../plots/models.plt` were selected from the Pareto front containing the best expressions (by MSE and length) found in the first run `all_0_best_expr.csv` with the full dataset. The expression with the best length as found in the cross-validation runs was selected. 

The plots of all Pareto fronts and the selected model length is visualized in `../plots/pareto_fronts_all.eps`. Details on the cross-validation proceedure can be found in the paper. 