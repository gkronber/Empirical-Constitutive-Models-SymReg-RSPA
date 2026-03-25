using DataFrames,DelimitedFiles

function preproc(filename, targetDelta=-10)
    data,header = readdlm(filename, ',', header=true)
    header = vec(header)
    df = DataFrame(data, header)
    target = last(header)
    
    deltatarget = [0, (df[2:end, target] - df[1:end-1, target])...]
    jump = ifelse.(deltatarget .<= targetDelta, 1, 0)
    insertcols!(df, 1, "group" => accumulate(+, jump))
    insertcols!(df, 5, "log10_epsp" => log10.(df[:, 4]))
    header = names(df)
    print_header = true
    for gdf in groupby(df, :group)
        ndf = interpolate!(gdf, 1200)[1:1200,header]
        println("$(nrow(gdf)) $(nrow(ndf))")
        if "phip" in names(gdf)
            write_alu(ndf, replace(filename, ".csv" => "_interpolated.csv"), print_header = print_header)
            write_alu(ndf, replace(filename, ".csv" => "_interpolated_gt350.csv"), minTemp = 350, print_header = print_header)
        elseif "epsp" in names(gdf)
            write_steel(ndf, replace(filename, ".csv" => "_interpolated.csv"),  print_header = print_header)
        end
        print_header = false
    end
    
    # again but cut off at maximum 
    print_header = true
    for gdf in groupby(df, :group)
        ndf = interpolate!(gdf, 400, stop_at_max=true)[1:400, header]
        println("$(nrow(gdf)) $(nrow(ndf))")
        if "phip" in names(gdf)
            write_alu(ndf, replace(filename, ".csv" => "_interpolated_tomax.csv"), print_header = print_header)
            write_alu(ndf, replace(filename, ".csv" => "_interpolated_gt350_tomax.csv"), minTemp = 350, print_header = print_header)
        elseif "epsp" in names(gdf)
            write_steel(ndf, replace(filename, ".csv" => "_interpolated_tomax.csv"), print_header = print_header)
        end
        print_header = false
    end
end

function write_alu(df, filename; minTemp = 0, print_header = false)
    # AA6082
    phip = df[1, :phip]
    temp = sum(df[:, :temp]) / nrow(df)
    temp = (temp ÷ 25) * 25
    temp >= minTemp || return

    header = names(df)
    open(replace(filename, ".csv" => "_train.csv"), print_header ? "w" : "a") do train_io
        open(replace(filename, ".csv" => "_test.csv"), print_header ? "w" : "a") do test_io
            open(replace(filename, ".csv" => "_cv.csv"), print_header ? "w" : "a") do cv_io
                if print_header
                    println(train_io, join(header, ","))
                    println(test_io, join(header, ","))
                    println(cv_io, join(header, ","))
                end
                if phip == 0.001 && (temp == 200 || temp == 275 || temp == 350 || temp == 425  || temp == 500) ||
                   phip == 0.01  && (temp == 225 || temp == 300 || temp == 375 || temp == 450) ||
                   phip == 0.1   && (temp == 250 || temp == 325 || temp == 400 || temp == 475) ||
                   phip == 1     && (temp == 200 || temp == 275 || temp == 350 || temp == 425  || temp == 500) ||
                   phip == 10    && (temp == 225 || temp == 300 || temp == 375 || temp == 450)
                    writedlm(train_io, eachrow(df), ",")
                    writedlm(cv_io, eachrow(df), ",")
                elseif phip != 3.16 && phip != 0.316 # remove these two values completely
                    writedlm(test_io, eachrow(df), ",")
                    writedlm(cv_io, eachrow(df), ",")
                end
            end
        end
    end
end

function write_steel(df, filename; print_header = false)
    header = names(df)

    open(replace(filename, ".csv" => "_train.csv"), print_header ? "w" : "a") do train_io
        open(replace(filename, ".csv" => "_test.csv"), print_header ? "w" : "a") do test_io
            open(replace(filename, ".csv" => "_cv.csv"), print_header ? "w" : "a") do cv_io
                if print_header
                    println(train_io, join(header, ","))
                    println(test_io, join(header, ","))
                    println(cv_io, join(header, ","))
                end

                # Johanna Eisenträger (Abb. 2 and Abb. 3)
                epsp = df[1, :epsp]
                temp = df[1, :temp]

                # # remove outlier curves
                # if epsp == 5e-5 && temp == 673 ||
                #    epsp == 1e-3 && (temp == 673 || temp == 773) 
                #    return
                # end

                if epsp == 1e-3 && (temp == 673 || temp == 773 || temp == 873) ||
                   epsp == 1e-4 && (temp == 723 || temp == 823) ||
                   epsp == 5e-5 && (temp == 673 || temp == 773 || temp == 873)
                    writedlm(train_io, eachrow(df), ",")
                    writedlm(cv_io, eachrow(df), ",")
                elseif temp != 923 # remove this test completely
                    writedlm(test_io, eachrow(df), ",")
                    writedlm(cv_io, eachrow(df), ",")
                end
            end
        end
    end
end

function interpolate!(df, steps; stop_at_max=false)
    colnames = names(df)
    phiSy = "phi" in colnames ? Symbol("phi") : "eps" in colnames ? Symbol("eps") : Symbol("Hin")
    phi = df[:, phiSy]
    start = 0.0002
    if stop_at_max
        max_target,idx = findmax(max, df[:, end]) # last col is target variable
        stop = phi[idx]
    else
        stop = maximum(phi)
    end
    step = (stop - start) / (steps + 1)
    phi_grid = start:step:stop
    newdf = DataFrame(string(phiSy) => phi_grid, "grid" => true)
    df = DataFrame(df)
    insertcols!(df, :grid => false)
    append!(df, newdf; cols=:union)
    sort!(df, phiSy)
    df = df[df[!, string(phiSy)] .>= start, :]
    for colidx in 1:ncol(df) 
        xs = df[!, string(phiSy)]
        ys = df[!, colidx]
        for rowidx in 1:length(ys) 
            if ismissing(ys[rowidx]) 
                prevrow = rowidx;
                while prevrow > 1 && ismissing(ys[prevrow]) 
                    prevrow -= 1
                end
                nextrow = rowidx
                while nextrow < length(ys) && ismissing(ys[nextrow])
                    nextrow += 1
                end
                if !ismissing(ys[prevrow]) && !ismissing(ys[nextrow]) 
                    deltay = ys[nextrow] - ys[prevrow]
                    deltax = xs[nextrow] - xs[prevrow]
                    df[rowidx, colidx] = df[prevrow, colidx] + deltay *  (xs[rowidx] - xs[prevrow]) / deltax 
                end
            end
        end
    end
    df[(!).(ismissing.(df.temp)), colnames]
end


function main()
    preproc("2025/abb_2_preproc.csv", -25)
    preproc("2025/abb_2_preproc_with_outliers.csv", -25)
    preproc("2021/AA6082.csv", -10)
end