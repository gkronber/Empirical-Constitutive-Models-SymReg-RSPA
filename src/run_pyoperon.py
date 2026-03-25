import pandas as pd
import numpy as np
from sklearn.metrics import mean_squared_error
from sklearn.ensemble import RandomForestRegressor

from pyoperon.sklearn import SymbolicRegressor
import pyoperon as Operon

import random, time, sys, os #, json
import gzip

def main():
    reps = 1
    folds = 8
    for maxlen in [100]:
        for file in [
                    "2021/AA6082_interpolated_gt350_tomax_cv.csv", 
                    "2021/AA6082_interpolated_gt350_cv.csv", 
                    "2025/abb_2_preproc_interpolated_tomax_cv.csv", "2025/abb_2_preproc_interpolated_cv.csv"
                    ]:

            # uncomment the following for the cv-runs
            # for cv_fold in range(0, folds):
            #     filewithoutext = os.path.splitext(os.path.basename(file))[0]
            #     targetfolder = f'../results/{filewithoutext}_{maxlen}/{cv_fold}'
            #     if not os.path.exists(targetfolder):
            #         os.makedirs(targetfolder)
            #     for rep in range(0, reps):
            #         run_operon_via_bindings(f'../data/{file}', cv_fold, folds, maxlen, f'{targetfolder}/run_{rep}.txt.gz')
            
            # uncomment the following for the final runs:
            filewithoutext = os.path.splitext(os.path.basename(file))[0]
            targetfolder = f'../results/{filewithoutext}_{maxlen}/all'
            if not os.path.exists(targetfolder):
                os.makedirs(targetfolder)
            for rep in range(0, reps):
                run_operon_via_bindings(f'../data/{file}', -1, folds, maxlen, f'{targetfolder}/run_{rep}.txt.gz')
            

    
# based on https://github.com/heal-research/pyoperon/blob/d5382c3f63f6dc12e872bb7ccffbf63ddc8e5bb7/example/operon-bindings.py
def run_operon_via_bindings(filename, cv_fold, folds, maxlen, outfilename):
    D      = pd.read_csv(filename, sep=',', decimal='.').to_numpy()

    if cv_fold >= 0:
        trainrows = (D[:,0] % folds) != cv_fold
        testrows  = (D[:,0] % folds) == cv_fold
    
        X_train = D[trainrows,1:-1] # do not use column 0
        X_test  = D[testrows, 1:-1]
        X = np.concat([X_train, X_test])
        y_train = D[trainrows, -1]
        y_test  = D[testrows, -1]
        y = np.concat([y_train, y_test])
        # X, y = D[:,:-1], D[:,-1]
        
        # estimate sigma error for DL and model selection
        y_pred = RandomForestRegressor(n_estimators=100).fit(X_train, y_train).predict(X_test)
        sErr = np.sqrt(mean_squared_error(y_test,  y_pred))
    else:
        X = D[:,1:-1]
        y = D[:, -1]
        y_train = y
        sErr = 1

    # initialize a dataset from a numpy array
    # print(X.shape, y.shape)
    A = np.column_stack((X, y))
    ds             = Operon.Dataset(np.asfortranarray(A))

    # define the training and test ranges
    train_rows = np.shape(y_train)[0]
    training_range = Operon.Range(0, train_rows)
    test_range     = Operon.Range(train_rows, ds.Rows)

    # define the regression target
    target         = ds.Variables[-1] # take the last column in the dataset as the target

    # take all other variables as inputs
    inputs         = [ h for h in ds.VariableHashes if h != target.Hash ]

    # print(cv_fold, folds, trainrows, train_rows, ds.Rows, inputs, sErr)
    # return 


    # initialize a rng
    rng            = Operon.RomuTrio(random.randint(1, 1000000))

    # initialize a problem object which encapsulates the data, input, target and training/test ranges
    problem        = Operon.Problem(ds)
    problem.TrainingRange = training_range
    problem.TestRange = training_range
    problem.Target = target
    problem.InputHashes = inputs

    # initialize an algorithm configuration
    config         = Operon.GeneticAlgorithmConfig(generations=100, 
                                                   max_evaluations=5000000000, 
                                                   local_iterations=10, 
                                                   population_size=1000, 
                                                   pool_size=1000, 
                                                   p_crossover=1.0, 
                                                   p_mutation=0.25, 
                                                   # epsilon=sErr * 1e-5
                                                   )

    # use tournament selection with a group size of 2 for NSGA2
    comparison     = Operon.CrowdedComparison()
    selector       = Operon.TournamentSelector(comparison)
    selector.TournamentSize = 3

    # initialize the primitive set (add, sub, mul, div, exp, log, sin, cos), constants and variables are implicitly added
    problem.ConfigurePrimitiveSet(Operon.NodeType.Constant | Operon.NodeType.Variable | 
                                  Operon.NodeType.Add | Operon.NodeType.Sub | 
                                  Operon.NodeType.Mul | Operon.NodeType.Div | 
                                  Operon.NodeType.Exp | Operon.NodeType.Log |
                                  Operon.NodeType.Square | Operon.NodeType.Sqrt |
                                  Operon.NodeType.Tanh | Operon.NodeType.Aq # |
                                  # Operon.NodeType.Abs | Operon.NodeType.Pow
                                  )
    pset = problem.PrimitiveSet
    pset.SetMinMaxArity(Operon.NodeType.Div, 1, 2)

    # define tree length and depth limits
    minL, maxL     = 1, maxlen
    maxD           = maxlen

    # define a tree creator (responsible for producing trees of given lengths)
    btc              = Operon.BalancedTreeCreator(pset, problem.InputHashes, bias=0.0)
    tree_initializer = Operon.UniformLengthTreeInitializer(btc)
    tree_initializer.ParameterizeDistribution(minL, maxL)
    tree_initializer.MaxDepth = maxD

    # define a coefficient initializer (this will initialize the coefficients in the tree)
    coeff_initializer = Operon.NormalCoefficientInitializer()
    coeff_initializer.ParameterizeDistribution(0, 1)

    # define several kinds of mutation
    mut_onepoint   = Operon.NormalOnePointMutation()
    mut_changeVar  = Operon.ChangeVariableMutation(inputs)
    mut_changeFunc = Operon.ChangeFunctionMutation(pset)
    mut_replace    = Operon.ReplaceSubtreeMutation(btc, coeff_initializer, maxD, maxL)

    # use a multi-mutation operator to apply them at random
    mutation       = Operon.MultiMutation()
    mutation.Add(mut_onepoint, 1)
    mutation.Add(mut_changeVar, 1)
    mutation.Add(mut_changeFunc, 1)
    mutation.Add(mut_replace, 1)

    # define crossover
    crossover_internal_probability = 0.9 # probability to pick an internal node as a cut point
    crossover      = Operon.SubtreeCrossover(crossover_internal_probability, maxD, maxL)

    # define fitness evaluation
    dtable         = Operon.DispatchTable()
    error_metric   = Operon.MSE()
    mseevaluator   = Operon.Evaluator(problem, dtable, error_metric, False) # initialize evaluator, use linear scaling = False
    lenevaluator   = Operon.LengthEvaluator(problem) # initialize evaluator, use linear scaling = False
    evaluator      = Operon.MultiEvaluator(problem)
    evaluator.Add(mseevaluator)
    evaluator.Add(lenevaluator)
    evaluator.Budget = config.Evaluations # computational budget

    optimizer      = Operon.LMOptimizer(dtable, problem, max_iter=config.Iterations)
    local_search   = Operon.CoefficientOptimizer(optimizer)

    # define how new offspring are created
    generator      = Operon.BasicOffspringGenerator(evaluator, crossover, mutation, selector, selector, local_search)

    # define how the offspring are merged back into the population - here we replace the worst parents with the best offspring
    reinserter     = Operon.KeepBestReinserter(comparison)
    sorter         = Operon.RankSorter()
    gp             = Operon.NSGA2Algorithm(config, problem, tree_initializer, coeff_initializer, generator, reinserter, sorter)


    with gzip.open(outfilename, 'wt') as f:
        def report():
            for ind in gp.BestFront:
                if cv_fold >= 0:
                    pred_test = Operon.Evaluate(dtable, ind.Genotype, ds, test_range).reshape(-1,)
                    if np.isfinite(pred_test).all():
                        mse = mean_squared_error(y_test, pred_test)
                    else:
                        mse = np.nan
                else:
                    mse = np.nan
                f.write(f'{filename} {gp.Generation} best front [{ind.GetFitness(0)}, {ind.GetFitness(1)}] mse_test {mse} {Operon.InfixFormatter.Format(ind.Genotype, ds, 12)}\n')
                f.flush()
    
        gp.Run(rng, report)


        # get the best solution and print it
        best = gp.BestModel
        model_string = Operon.InfixFormatter.Format(best.Genotype, ds, 12)
        fitness = evaluator(rng, gp.BestModel)
        if cv_fold >= 0:
            pred_test = Operon.Evaluate(dtable, best.Genotype, ds, test_range).reshape(-1,)
            if np.isfinite(pred_test).all():
                mse = mean_squared_error(y_test, pred_test)
            else:
                mse = np.nan
        else:
            mse = np.nan
        f.write(f'{filename} sErr: {sErr} best fitness: {fitness} mse_test {mse} expr: {model_string}\n')
    
    
    
# count the number of nodes (not available in the pyoperon wrapper yet)
def adjusted_length(model):
        return sum(3 if x.IsVariable else 1 for x in model.Nodes)

    
main()