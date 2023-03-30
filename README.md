#  Darc
> Dart로 작성된 현대적인 C/C++ 빌드 도구

`Dart + C`를 합친 Darc(다르크)는 yaml을 바탕으로 현대적이고 친숙한 빌드 환경을 제공합니다.

## Darc CLI
### 프로젝트 설정하기

### 프로젝트 빌드
darc build 명령을 통해 Darc 프로젝트를 컴파일할 수 있습니다.
```shell
darc build
```

이외에도 아래와 같은 다양한 옵션을 제공합니다:
 * `-c`, `--compiler`: 빌드에 사용할 컴파일러의 명칭을 지정합니다.
   * 기본값: `g++`
 * (예정) `-t`, `--toolchain`: 빌드에 사용할 툴체인을 지정합니다.
   * 툴체인의 디렉터리 경로를 입력하여야 합니다.
 * `-d`, `--debug`: 디버그 가능한 바이너리를 빌드합니다.

## darc.yml
빌드하기를 원하는 디렉터리에 `darc.yml`을 정의하여 원하는 C/C++ 프로젝트를 손쉽게 바이너리로 빌드할 수 있습니다.

```yaml
project:
  name: first-cpp-app
  author: Eric Lee
  version: 1.0.0 Alpha

dependency:
  - include: ${DEFAULT_INCLUDE}
    link: wiringPi
  - include: ./libtensorflow/include
    link: ./libtensorflow/libtensorflowlite.a
```

### 환경 변수 사용
darc.yml은 환경변수를 지원합니다.