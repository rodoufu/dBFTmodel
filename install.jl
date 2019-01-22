using Pkg

Pkg.add("JuMP")
Pkg.add("Test")
Pkg.add("Compat")
Pkg.add("MathOptInterface")
Pkg.add("GLPK")
Pkg.add("GLPKMathProgInterface")
Pkg.add("LinearFractional")

Pkg.add("Cbc")
Pkg.add("Clp")
Pkg.add("ECOS")
Pkg.add("Ipopt")
Pkg.add("NLopt")
Pkg.add("SCS")
# Pkg.add("CPLEX") # Needs working installation
# Pkg.add("Gurobi") # Needs working installation
Pkg.add("AmplNLWriter")
# Pkg.add("CoinOptServices")

Pkg.add("JSON")

Pkg.update()
