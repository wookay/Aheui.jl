push!(LOAD_PATH, "src")
push!(LOAD_PATH, "../src")
using Aheui

using Base.Test

@test "" == 아희("")
@test "" == 아희("아희")
@test "" == 아희("밯망희")
@test "45" == 아희("발밞따망희")
@test "5" == 아희("반받다망희")
