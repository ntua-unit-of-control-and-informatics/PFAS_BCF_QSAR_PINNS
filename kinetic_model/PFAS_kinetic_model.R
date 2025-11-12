# ============================================================================
# PFAS Bioconcentration Factor (BCF) Kinetic Model
# ============================================================================
# One-compartment kinetic model: dC/dt = kup * Cw - kel * C
# where C = tissue concentration, Cw = water concentration,
# kup = uptake rate, kel = elimination rate
# ============================================================================

library(deSolve)

# create.params: Returns kinetic parameters (kup, kel) for specified PFAS
create.params <- function(user_input){
    with(as.list(user_input),{
        # Assign kinetic parameters based on PFAS compound
        # kup = uptake rate constant (L/kg/day)
        # kel = elimination rate constant (1/day)

        if(PFAS == "PFOA"){  # Perfluorooctanoic acid
            kup <- 8.584
            kel <- 0.17
        }else if (PFAS == "PFOS") {
            kup <- 62.325
            kel <- 0.0325
        }else if (PFAS == "PFBA") {
            kup <- 1.42
            kel <- 0.7075
        }else if (PFAS == "PFBS") {
            kup <- 1.966
            kel <- 0.672
        }else if (PFAS == "PFDA") {
            kup <- 167.867
            kel <- 0.0483
        }else if (PFAS == "PFDoA") {
            kup <- 336.15
            kel <- 0.0433
        }else if (PFAS == "PFDPA") {
            kup <- 12.45
            kel <- 0.05
        }else if (PFAS == "PFHpA") {
            kup <- 5.222
            kel <- 0.74
        }else if (PFAS == "PFHxA") {
            kup <- 2.211
            kel <- 0.937
        }else if (PFAS == "PFHxPA") {
            kup <- 1.62
            kel <- 0.0025
        }else if (PFAS == "PFHxS") {
            kup <- 10.23
            kel <- 0.14
        }else if (PFAS == "PFNA") {
            kup <- 50.183
            kel <- 0.107
        }else if (PFAS == "PFOPA") {
            kup <- 5.09
            kel <- 0.005
        }else if (PFAS == "PFPeA") {
            kup <- 1.358
            kel <- 1.358
        }else if (PFAS == "PFTeDA") {
            kup <- 7865
            kel <- 0.011
        }else if (PFAS == "PFTrDA") {
            kup <- 1509
            kel <- 0.01
        }else if (PFAS == "PFUnA") {
            kup <- 190.75
            kel <- 0.045
        }else if (PFAS == "F_53B") {
            kup <- 17.106
            kel <- 0.05
        }else if (PFAS == "OBS") {
            kup <- 62.533
            kel <- 0.24
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

# User input: Define PFAS compound and exposure scenario
user_input <- list(
    PFAS = "PFOA",
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
    envFile = "/Users/vassilis/Documents/GitHub/jaqpotpy/.env"
)