# ============================================================================
# PFAS Bioconcentration Factor (BCF) Kinetic Model
# ============================================================================
# One-compartment kinetic model: dC/dt = kup * Cw - kel * C
# where C = tissue concentration, Cw = water concentration,
# kup = uptake rate, kel = elimination rate
# ============================================================================

library(deSolve)

# create.params: Returns kinetic parameters (kup, kel) for specified PFAS and study
create.params <- function(user_input){
    with(as.list(user_input),{
        # Assign kinetic parameters based on PFAS compound and study number
        # kup = uptake rate constant (L/kg/day)
        # kel = elimination rate constant (1/day)
        # Data from: data/summarised_kinetic_data.csv

        if(PFAS == "F-53B"){
            if(study == 2){
                kup <- 0.11
                kel <- 0.05
            }else if(study == 4){
                kup <- 39.7666666666667
                kel <- 0.05
            }
        }else if(PFAS == "OBS"){
            if(study == 4){
                kup <- 62.5333333333333
                kel <- 0.24
            }
        }else if(PFAS == "PFBA"){
            if(study == 5){
                kup <- 1.75
                kel <- 1.61
            }else if(study == 6){
                kup <- 0.61
                kel <- 1.06
            }else if(study == 9){
                kup <- 1.66
                kel <- 0.08
            }
        }else if(PFAS == "PFBS"){
            if(study == 4){
                kup <- 0.85
                kel <- 0.34
            }else if(study == 5){
                kup <- 1.59
                kel <- 1.38
            }else if(study == 6){
                kup <- 1.8
                kel <- 1.21
            }else if(study == 7){
                kup <- 1.81
                kel <- 1.1
            }else if(study == 8){
                kup <- 1.725
                kel <- 0.82
            }else if(study == 9){
                kup <- 4.23
                kel <- 0.185
            }
        }else if(PFAS == "PFDA"){
            if(study == 5){
                kup <- 20.4
                kel <- 0.17
            }else if(study == 6){
                kup <- 41.9
                kel <- 0.03
            }else if(study == 7){
                kup <- 38.1
                kel <- 0.03
            }else if(study == 8){
                kup <- 39.8
                kel <- 0.04
            }else if(study == 9){
                kup <- 433.5
                kel <- 0.01
            }
        }else if(PFAS == "PFDoA"){
            if(study == 5){
                kup <- 99.9
                kel <- 0.19
            }else if(study == 6){
                kup <- 162
                kel <- 0.01
            }else if(study == 7){
                kup <- 179
                kel <- 0.02
            }else if(study == 8){
                kup <- 179
                kel <- 0.02
            }else if(study == 9){
                kup <- 698.5
                kel <- 0.01
            }
        }else if(PFAS == "PFDPA"){
            if(study == 9){
                kup <- 12.45
                kel <- 0.05
            }
        }else if(PFAS == "PFHpA"){
            if(study == 5){
                kup <- 5.03
                kel <- 0.88
            }else if(study == 6){
                kup <- 5.87
                kel <- 0.78
            }else if(study == 7){
                kup <- 5.38
                kel <- 0.76
            }else if(study == 8){
                kup <- 4.915
                kel <- 0.64
            }
        }else if(PFAS == "PFHxA"){
            if(study == 5){
                kup <- 2.39
                kel <- 1.37
            }else if(study == 6){
                kup <- 2.95
                kel <- 1.47
            }else if(study == 7){
                kup <- 2.59
                kel <- 1.41
            }else if(study == 8){
                kup <- 2.49
                kel <- 1.025
            }else if(study == 9){
                kup <- 1.285
                kel <- 0.13
            }
        }else if(PFAS == "PFHxPA"){
            if(study == 9){
                kup <- 1.62
                kel <- 0.0025
            }
        }else if(PFAS == "PFHxS"){
            if(study == 4){
                kup <- 4.81666666666667
                kel <- 0.183333333333333
            }else if(study == 9){
                kup <- 18.35
                kel <- 0.075
            }
        }else if(PFAS == "PFNA"){
            if(study == 5){
                kup <- 28.1
                kel <- 0.33
            }else if(study == 6){
                kup <- 18.9
                kel <- 0.05
            }else if(study == 7){
                kup <- 15.2
                kel <- 0.05
            }else if(study == 8){
                kup <- 19.3
                kel <- 0.1
            }else if(study == 9){
                kup <- 109.8
                kel <- 0.055
            }
        }else if(PFAS == "PFOA"){
            if(study == 1){
                kup <- 0.02
                kel <- 0.1
            }else if(study == 3){
                kup <- 3.67
                kel <- 0.12
            }else if(study == 6){
                kup <- 7.56
                kel <- 0.15
            }else if(study == 7){
                kup <- 7.41
                kel <- 0.15
            }else if(study == 8){
                kup <- 9.33
                kel <- 0.26
            }else if(study == 9){
                kup <- 16.05
                kel <- 0.205
            }
        }else if(PFAS == "PFOPA"){
            if(study == 9){
                kup <- 5.09
                kel <- 0.005005
            }
        }else if(PFAS == "PFOS"){
            if(study == 4){
                kup <- 32.4333333333333
                kel <- 0.05
            }else if(study == 6){
                kup <- 37.6
                kel <- 0.02
            }else if(study == 7){
                kup <- 40.2
                kel <- 0.02
            }else if(study == 8){
                kup <- 41.3
                kel <- 0.03
            }else if(study == 9){
                kup <- 141.1
                kel <- 0.02
            }
        }else if(PFAS == "PFPeA"){
            if(study == 5){
                kup <- 1.74
                kel <- 1.18
            }else if(study == 6){
                kup <- 1.45
                kel <- 1.72
            }else if(study == 7){
                kup <- 1.36
                kel <- 1.65
            }else if(study == 8){
                kup <- 1.12
                kel <- 1.12
            }
        }else if(PFAS == "PFTeDA"){
            if(study == 9){
                kup <- 7865
                kel <- 0.011
            }
        }else if(PFAS == "PFTrDA"){
            if(study == 9){
                kup <- 1509
                kel <- 0.01
            }
        }else if(PFAS == "PFUnA"){
            if(study == 5){
                kup <- 47
                kel <- 0.16
            }else if(study == 6){
                kup <- 61.9
                kel <- 0.03
            }else if(study == 7){
                kup <- 62.9
                kel <- 0.03
            }else if(study == 8){
                kup <- 64.7
                kel <- 0.03
            }else if(study == 9){
                kup <- 454
                kel <- 0.01
            }
        }else{
            stop("Unknown PFAS: ", PFAS)
        }
        return(list(kup = kup, kel = kel, Cw = Cw, Cw_times = Cw_times))
    })
}

# create.inits: Sets initial conditions (C = 0 ng/g, Cw = 0 ng/L)
create.inits <- function(parameters){
    C <- 0; Cw <- 0
    return(c(C = C, Cw = Cw))
}

# create.events: Creates event schedule for time-varying water concentrations
create.events <- function(parameters){
    event.dat <- list(data = data.frame(var = "Cw",
    time = parameters$Cw_times,
    value = parameters$Cw,
    method = "rep"))
    return(event.dat)
}

# custom.func: Placeholder for custom functions (not needed)
custom.func <- function(){
    return()
}

# ode.func: Defines ODEs for one-compartment model
ode.func <- function(time, inits, params, custom.func){
    with(as.list(c(inits, params)),{

        # dC/dt = kup*Cw - kel*C (ng/g/day)
        dC <- kup*Cw - kel*C
        dCw <- 0  # Water concentration constant

        return(list(c(dC, dCw)))
    })
}

# ============================================================================
# Simulation Setup
# ============================================================================

# User input: Define PFAS compound, study number, and exposure scenario
user_input <- list(
    PFAS = "PFOA",
    study = 9,         # Study number (from data/summarised_kinetic_data.csv)
    Cw = c(10),        # Water concentration (ng/L)
    Cw_times = c(0)    # Time points (days)
)

# Generate parameters, initial conditions, and events
params <- create.params(user_input)
inits <- create.inits(params)
events <- create.events(params)

# Run ODE simulation
times <- seq(0, 30, by = 1)  # Time sequence (days)
out <- ode(y = inits, times = times, func = ode.func, parms = params, events = events)
print(out)

# ============================================================================
# Model Deployment
# ============================================================================

# Deploy PBPK model to Jaqpot platform
predicted.feats <- c("C", "Cw")

jaqpotr::deploy.pbpk(user.input = user_input, out.vars = predicted.feats,
    create.params = create.params, create.inits = create.inits,
    create.events = create.events, custom.func = custom.func,
    envFile = ".env"
)