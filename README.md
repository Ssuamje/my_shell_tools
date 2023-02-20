# my_git_tools
커밋 메시지를 입력하고, stage, unstage로 현재 브랜치에 push하는 프로그램.

### download
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Ssuamje/my_git_tools/main/download.sh)"
```

### 사용 흐름 예시
Usage : gfc [-d : direct] <commit_string>
<br>
gfc는 git fast commit을 의미합니다.
<br>
-d 옵션을 통해, 현재 브랜치의 모든 작업사항을 <commit_string>을 커밋 메시지로 설정, push합니다.
<br>
 ![Feb-20-2023 17-51-27](https://user-images.githubusercontent.com/105692206/220065923-0e1b4e46-d970-4089-9361-f73d91081368.gif)

### 구체적인 사용법
-d 옵션을 넣지 않았다면, 다음과 같이 작동합니다.
<br>

1 - git status를 보여주고, 다음 단계(브랜치와 커밋 메시지 체크)로 넘어갑니다.
![Feb-20-2023 18-25-01](https://user-images.githubusercontent.com/105692206/220066099-7b6f9348-1bc7-48e2-ad53-b68c5ae66495.gif)
<br>
<br>
2 - 브랜치명과 현재 설정한 커밋 메시지를 확인하고, 변경할 수 있습니다(n 입력시).
![Feb-20-2023 18-25-02](https://user-images.githubusercontent.com/105692206/220066693-a46781a8-99a4-4b3d-8b52-d713fb892664.gif)
<br>
<br>
3 - 우선적으로 "git add ."이 진행된 상태에서, 특정 파일을 unstage, stage 할 수 있습니다.
<br>
(y : yes / q : quit / [filename] : file unstage / a [filename] : add file to stage / c : undo / s : stop with commit).
![to_push](https://user-images.githubusercontent.com/105692206/220066737-b6660b70-3d61-48c3-bd52-24c6fdad43e0.gif)
<br>
<br>
4 - 현재 작업 중인 브랜치로 스테이징한 사항을 커밋, 푸시합니다.
<br>
<br>


