push!(LOAD_PATH, "src")
push!(LOAD_PATH, "../src")
using Aheui

using Base.Test

@test "" == 아희("")
@test "" == 아희("아희")
@test "" == 아희("밯망희")
@test "45" == 아희("발밞따망희")
@test "5" == 아희("반받다망희")
@test "Hello, world!\n" == 아희("""\
밤밣따빠밣밟따뿌
빠맣파빨받밤뚜뭏
돋밬탕빠맣붏두붇
볻뫃박발뚷투뭏붖
뫃도뫃희멓뭏뭏붘
뫃봌토범더벌뿌뚜
뽑뽀멓멓더벓뻐뚠
뽀덩벐멓뻐덕더벅""")
