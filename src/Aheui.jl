module Aheui

export 아희
export 스택, 큐, 통로, 순방향, 역방향
export 없음, 끝냄
export 덧셈, 곱셈, 뺄셈, 나눗셈, 나머지 
export 집어넣기, 뽑기, 중복, 바꿔치기
export 선택, 이동, 비교, 조건
export 가자, 종성획수

type 진행방향
  어느쪽::Function
end
순방향 = 진행방향(+)
역방향 = 진행방향(-)

abstract 저장공간
type 스택 <: 저장공간
  공간::Vector
	방향::진행방향
  출력::Vector
end
type 큐 <: 저장공간
  공간::Vector
	방향::진행방향
  출력::Vector
end
type 통로 <: 저장공간
  공간::Vector
	방향::진행방향
  출력::Vector
end

없음(저장::저장공간, _) = nothing
끝냄(저장::저장공간, _) = isempty(저장.공간) ? 0 : 뽑(저장)
덧셈(저장::저장공간, _) = 집어넣기(저장, +(뽑(저장), 뽑(저장)))
곱셈(저장::저장공간, _) = 집어넣기(저장, *(뽑(저장), 뽑(저장)))
뺄셈(저장::저장공간, _) = 집어넣기(저장, -(뽑(저장), 뽑(저장)))
나눗셈(저장::저장공간, _) = 집어넣기(저장, /(뽑(저장), 뽑(저장)))
나머지(저장::저장공간, _) = 집어넣기(저장, %(뽑(저장), 뽑(저장)))


뽑(저장::스택) = pop!(저장.공간)
뽑(저장::저장공간) = pop!(저장.공간)
뽑기(저장::스택, _) = 출력(저장, 뽑(저장))
function 뽑기(저장::스택, n::Symbol)
  isempty(저장.공간) ? nothing : 출력(저장, 뽑(저장))
end
function 뽑기(저장::스택, n::Int)
  isempty(저장.공간) ? nothing : 출력(저장, 뽑(저장))
end
뽑기(저장::저장공간, _) = 출력(저장, 뽑(저장))
출력(저장::저장공간, n) = push!(저장.출력, n)

function 집어넣기(저장::저장공간, n::Symbol)
  # TODO
  # ㅁ에 ㅇ받침이 있으면 저장공간에서 뽑아낸 값을 숫자로, ㅎ받침이 있으면 그 값에 해당하는 유니코드 문자로 출력합니다. 나머지 받침은 뽑아낸 값을 그냥 버립니다. ㅂ도 마찬가지로 ㅇ받침이 있으면 입력받은 숫자를, ㅎ받침이 있으면 입력받은 문자의 유니코드 코드값을 저장공간에 집어넣습니다.
  nothing
end
집어넣기(저장::저장공간, n::Int) = push!(저장.공간, n)

중복(저장::스택) = 집어넣기(저장, last(저장.공간))
중복(저장::저장공간) = 집어넣기(저장, last(저장.공간))
function 바꿔치기(저장::스택)
  저장.공간[end], 저장.공간[end-1] = 저장.공간[end-1], 저장.공간[end]
end
바꿔치기(저장::저장공간) = nothing
선택(공간들::Dict, 공간키) = 공간들[공간키]
function 이동(저장::저장공간, 공간들, 공간키)
	공간 = 선택(공간들, 공간키)
	집어넣기(공간, 뽑기(저장))
	저장
end
function 비교(저장::저장공간)
  n = 뽑기(저장) >= 뽑기(저장) ? 1 : 0
  집어넣기(저장, n)
end
function 조건(저장::저장공간)
  저장.방향 = 0 == 뽑기(저장) ? 역방향 : 순방향
	저장
end
가자(f, s...) = f(s...)


abstract 커서타입
type 그냥내비둠 <: 커서타입
end
type 칸이동 <: 커서타입
  얼만큼::Int
  어느쪽::Function
end

내비둠 = 그냥내비둠()
한칸 = 칸이동(1, identity)
두칸 = 칸이동(2, identity)
import Base: +, -
+(칸::칸이동) = 칸이동(칸.얼만큼, +)
-(칸::칸이동) = 칸이동(칸.얼만큼, -)


function 커서이동(상하::칸이동, 좌우::그냥내비둠)
  function 어디로(커서)
    m,n = 커서.위치
    커서.이전위치 = [m n]
    커서.위치 = [상하.어느쪽(상하.얼만큼, m) n]
    커서
  end
  어디로
end
function 커서이동(상하::그냥내비둠, 좌우::칸이동)
  function 어디로(커서)
    m,n = 커서.위치
    커서.이전위치 = [m n]
    커서.위치 = [m 좌우.어느쪽(좌우.얼만큼, n)]
    커서
  end
  어디로
end
function 기능없음(커서)
  커서
end

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
  기능없음 # ㅡ
  기능없음 # ㅢ
  기능없음 # ㅣ
]
const 종성획수표 = [0 2 4 4 2 5 5 3 5 7 9 9 7 9 9 8 4 4 6 2 4 :ㅇ 3 4 3 4 4 :ㅎ]

type 커서움직임
  이전위치
  위치
  방향
end

const Ga = 0xAC00
const Hih = 0xD7A3
const ChosungOffset = 21 * 28
const JungsungOffset = 28
function 기능(저장::저장공간, 소리::Char, 커서::커서움직임)
  n = Int(소리)
  if n >= Ga && n <= Hih
    n = n - Ga
    n1 = trunc(Int, n / ChosungOffset) + 1
    n = n % ChosungOffset
    n2 = trunc(Int, n / JungsungOffset) + 1
    n3 = trunc(Int, n % JungsungOffset) + 1
    초 = 닿소리표[n1]
    중 = 홀소리표[n2]
    종 = 종성획수표[n3]
    초,중,종
  else
  end 
end

function 아희(입력::AbstractString)
  여러줄 = split(입력, "\n")
  m,n = length(여러줄), maximum(map(length, 여러줄))
  a = Array(Char, m, n)
  for (i,줄) in enumerate(여러줄)
    for (j,글자) in enumerate(줄)
      a[i,j] = 글자
    end
  end
  아희(a)
end

function 아희(입력::Array{Char,2})
  isempty(입력) && return ""
  공간들 = Dict(:큐=>큐([], 순방향, []), :스택=>스택([], 순방향, []), :통로=>통로([], 순방향, []))
  저장 = 가자(선택, 공간들, :스택)
  커서 = 커서움직임([0 0], [1 1], 기능없음)
  while true
    소리 = 입력[커서.위치...]
    초,중,종 = 기능(저장, 소리, 커서)
    if 끝냄==초
      break
    else
      가자(초, 저장, 종)
      커서 = 중(커서)
    end
  end
  join(저장.출력)
end

end
