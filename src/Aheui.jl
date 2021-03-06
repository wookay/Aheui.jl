module Aheui

export 아희
export 스택, 큐, 통로, 순방향, 역방향
export 없음, 끝냄
export 덧셈, 곱셈, 뺄셈, 나눗셈, 나머지 
export 집어넣기, 뽑기, 중복, 바꿔치기
export 선택, 이동, 비교, 조건
export 가자, 종성획수

abstract type 저장공간 end
abstract type 커서타입 end

mutable struct 진행방향
  어느쪽::Function
end

mutable struct 스택 <: 저장공간
  공간::Vector
  출력::Vector
  방향::진행방향
end
struct 큐 <: 저장공간
  공간::Vector
  출력::Vector
  방향::진행방향
end
struct 통로 <: 저장공간
  공간::Vector
  출력::Vector
  방향::진행방향
end

순방향 = 진행방향(+)
역방향 = 진행방향(-)

없음(저장::저장공간, _) = nothing
끝냄(저장::저장공간, _) = isempty(저장.공간) ? 0 : 뽑(저장)
덧셈(저장::저장공간, _) = 집어넣기(저장, +(뽑(저장), 뽑(저장)))
곱셈(저장::저장공간, _) = 집어넣기(저장, *(뽑(저장), 뽑(저장)))
뺄셈(저장::저장공간, _) = 집어넣기(저장, -뽑(저장)+뽑(저장))
나눗셈(저장::저장공간, _) = 집어넣기(저장, \(뽑(저장), 뽑(저장)))
나머지(저장::저장공간, _) = 집어넣기(저장, ((a,b)->%(b,a))(뽑(저장), 뽑(저장)))

뽑(저장::저장공간) = pop!(저장.공간)

function 뽑기(저장::저장공간, 받침::Symbol)
  if isempty(저장.공간)
    nothing
  else
    값 = 뽑(저장)
    출력(저장, :ㅎ==받침 ? Char(값) : 값)
  end
end
뽑기(저장::저장공간, ::Union{Int,Float64}) = isempty(저장.공간) ? nothing : 출력(저장, 뽑(저장))
뽑기(저장::저장공간) = 뽑기(저장, 0)

function 출력(저장::저장공간, 값)
  push!(저장.출력, 값)
  값
end

집어넣기(저장::저장공간, ::Symbol) = nothing
집어넣기(저장::저장공간, 값::Union{Int,Float64}) = push!(저장.공간, 값)

중복(저장::저장공간, _) = 집어넣기(저장, last(저장.공간))

바꿔치기(저장::저장공간, _) = 저장.공간[end], 저장.공간[end-1] = 저장.공간[end-1], 저장.공간[end]
선택(공간들::Dict, 공간키) = 공간들[공간키]
function 이동(저장::저장공간, 공간들::Dict, 공간키)
  공간 = 선택(공간들, 공간키)
  집어넣기(공간, 뽑기(저장))
  저장
end
function 비교(저장::저장공간)
  값 = 뽑기(저장) >= 뽑기(저장) ? 1 : 0
  집어넣기(저장, 값)
end
function 조건(저장::저장공간)
  저장.방향 = 0 == 뽑기(저장) ? 역방향 : 순방향
  저장
end
가자(f, a...) = f(a...)

struct 그냥내비둠 <: 커서타입
end
struct 칸이동 <: 커서타입
  얼만큼::Int
  어느쪽::Function
end

mutable struct 커서움직임
  이전위치
  위치
  방향::Function
end

내비둠 = 그냥내비둠()
한칸 = 칸이동(1, identity)
두칸 = 칸이동(2, identity)
import Base: +, -
+(칸::칸이동) = 칸이동(칸.얼만큼, +)
-(칸::칸이동) = 칸이동(칸.얼만큼, -)

function 커서이동(상하::칸이동, 좌우::그냥내비둠)
  function 어디로(저장::저장공간, 커서::커서움직임)
    행값,렬값 = 커서.위치
    커서.이전위치 = [행값 렬값]
    커서.위치 = [상하.어느쪽(행값, 상하.얼만큼) 렬값]
    저장.방향.어느쪽 = 상하.어느쪽
    커서
  end
  어디로
end
function 커서이동(상하::그냥내비둠, 좌우::칸이동)
  function 어디로(저장::저장공간, 커서::커서움직임)
    행값,렬값 = 커서.위치
    커서.이전위치 = [행값 렬값]
    커서.위치 = [행값 좌우.어느쪽(렬값, 좌우.얼만큼)]
    저장.방향.어느쪽 = 좌우.어느쪽
    커서
  end
  어디로
end
기능없음(저장::저장공간, 커서::커서움직임) = 커서

const 닿소리표 = [없음 없음 나눗셈 덧셈 곱셈 나머지 뽑기 집어넣기 중복 선택 이동 없음 비교 없음 조건 없음 뺄셈 바꿔치기 끝냄]
const 홀소리표 = [
  커서이동(내비둠, +한칸)
  기능없음
  커서이동(내비둠, +두칸)
  기능없음
  커서이동(내비둠, -한칸)
  기능없음
  커서이동(내비둠, -두칸)
  기능없음
  커서이동(-한칸, 내비둠)
  기능없음
  기능없음
  기능없음
  커서이동(-두칸, 내비둠)
  커서이동(+한칸, 내비둠)
  기능없음
  기능없음
  기능없음
  커서이동(+두칸, 내비둠)
  기능없음 # ㅡ  FIXME: 방향 바꾸기 처리 추가
  기능없음 # ㅢ
  기능없음 # ㅣ
]
const 종성획수표 = [0 2 4 4 2 5 5 3 5 7 9 9 7 9 9 8 4 4 6 2 4 :ㅇ 3 4 3 4 4 :ㅎ]
const 유니코드_가 = 0xAC00
const 유니코드_히흫 = 0xD7A3
const 초성오프셋 = 21 * 28
const 중성오프셋 = 28

function 기능(저장::저장공간, 소리::Char, 커서::커서움직임)
  값 = Int(소리)
  if 값 >= 유니코드_가 && 값 <= 유니코드_히흫
    값 = 값 - 유니코드_가
    초성인덱스 = trunc(Int, 값 / 초성오프셋) + 1
    값 = 값 % 초성오프셋
    중성인덱스 = trunc(Int, 값 / 중성오프셋) + 1
    종성인덱스 = trunc(Int, 값 % 중성오프셋) + 1
    닿소리표[초성인덱스], 홀소리표[중성인덱스], 종성획수표[종성인덱스]
  else
  end 
end

function 아희(입력::String)
  여러줄 = split(입력, "\n")
  행,렬 = length(여러줄), maximum(map(length, 여러줄))
  격자 = Array{Char}(undef, 행, 렬)
  for (행값,줄) in enumerate(여러줄)
    for (렬값,글자) in enumerate(줄)
      격자[행값,렬값] = 글자
    end
  end
  아희(격자)
end

function 아희(입력::Array{Char,2})
  isempty(입력) && return ""
  공간들 = Dict(:큐=>큐([], [], 순방향), :스택=>스택([], [], 순방향), :통로=>통로([], [], 순방향))
  저장 = 가자(선택, 공간들, :스택)
  커서 = 커서움직임([0 0], [1 1], 기능없음)
  while true
    소리 = 입력[커서.위치...]
    초,중,종 = 기능(저장, 소리, 커서)
    if 끝냄==초
      break
    else
      가자(초, 저장, 종)
      커서 = 중(저장, 커서)
    end
  end
  join(저장.출력)
end

end
