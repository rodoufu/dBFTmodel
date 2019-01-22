using LinearAlgebra
using LinearFractional
using JuMP, Cbc
using Clp
using JSON

s = "{\"a_number\" : 5.0, \"an_array\" : [\"string\", 9]}"
j = JSON.parse(s)

n_i = 5
i = [1:n_i]

f = n_i - 2
N = 3 * f + 1
M = 2 * f + 1

n_b = 5
b = [1:n_b]
n_h = 5
h = [1:n_h]
n_v = 5
h = [1:n_v]
n_t = 5
t = [1:n_t]

# Maximization problem
m = Model(solver=CbcSolver())

primary_i_h_v = zeros(Bool, n_i, n_h, n_v)
@variable(m, primary_i_h_v, Bin)
initialized_i_h_v_t = zeros(Bool, n_i, n_h, n_v, n_t)
@variable(m, initialized_i_h_v_t, Bin)

SendPrepReq_i_h_b_v_t = zeros(Bool, n_i, n_h, n_b, n_v, n_t)
@variable(m, SendPrepReq_i_h_b_v_t, Bin)
SendPrepResp_i_h_b_v_t = zeros(Bool, n_i, n_h, n_b, n_v, n_t)
@variable(m, SendPrepResp_i_h_b_v_t, Bin)
n_j = n_i
RecvPrepReq_i_j_h_b_v_t = zeros(Bool, n_i, n_j, n_h, n_b, n_v, n_t)
@variable(m, RecvPrepReq_i_j_h_b_v_t, Bin)
RecvPrepResp_i_j_h_b_v_t = zeros(Bool, n_i, n_j, n_h, n_b, n_v, n_t)
@variable(m, RecvPrepResp_i_j_h_b_v_t, Bin)

BlockRelay_i_h_b_t = zeros(Bool, n_i, n_h, n_b, n_t)
@variable(m, BlockRelay_i_h_b_t, Bin)
RecvBlkPersist_i_j_h_b_t = zeros(Bool, n_i, n_j, n_h, n_b, n_t)
@variable(m, RecvBlkPersist_i_j_h_b_t, Bin)

sentPrepReq_i_h_b_v_t = zeros(Bool, n_i, n_h, n_b, n_v, n_t)
@variable(m, sentPrepReq_i_h_b_v_t, Bin)
sentPrepResp_i_h_b_v_t = zeros(Bool, n_i, n_h, n_b, n_v, n_t)
@variable(m, sentPrepResp_i_h_b_v_t, Bin)
recevdPrepReq_i_j_h_b_v_t = zeros(Bool, n_i, n_j, n_h, n_b, n_v, n_t)
@variable(m, recevdPrepReq_i_j_h_b_v_t, Bin)
recvdPrepResp_i_j_h_b_v_t = zeros(Bool, n_i, n_j, n_h, n_b, n_v, n_t)
@variable(m, recvdPrepResp_i_j_h_b_v_t, Bin)

sentBlkPersist_i_h_b_t = zeros(Bool, n_i, n_h, n_b, n_t)
@variable(m, sentBlkPersist_i_h_b_t, Bin)
recvdBlkPersist_i_j_h_b_t = zeros(Bool, n_i, n_j, n_h, n_b, n_t)
@variable(m, recvdBlkPersist_i_j_h_b_t, Bin)
blockRelayed_b = zeros(Bool, n_b)
@variable(m, blockRelayed_b, Bin)

# Objective: maximize profit
@objective(m, Max, sum(blockRelayed_b))

for it_i = 1:n_i
    @constraint(m, initialized_i_h_v_t[i[it_i], h[1], v[1], t[1]] == 1)
    for it_h = 1:n_h
        for it_v = 1:n_v
            @constraint(m, initialized_i_h_v_t[i[it_i], h[it_h], v[it_v], t[1]] == 0)
        end
    end
end

# Constraint: can carry all
# @constraint(m, dot(weight, x) <= capacity)

# Solve problem using MIP solver
status = solve(m)

println("Objective is: ", getobjectivevalue(m))
println("Solution is:")
for i = 1:5
    print("x[$i] = ", getvalue(x[i]))
    println(", p[$i]/w[$i] = ", profit[i]/weight[i])
end
