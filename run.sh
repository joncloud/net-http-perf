#!/bin/bash
publish() {
    readonly APP=$1
    readonly CONFIGURATION=$2
    readonly SOURCE_PATH=./$APP
    pushd $SOURCE_PATH

    TARGET_PATH=../bin/$APP
    if [ -d "$TARGET_PATH" ]; then
        rm -rf "$TARGET_PATH"
    fi

    dotnet publish --configuration $CONFIGURATION --output $TARGET_PATH

    popd
}

reflector() {
    readonly PORT=$1
    dotnet ./bin/Reflector/Reflector.dll > /dev/null &
    readonly PID=$!
    return $PID
}

test() {
    readonly NAME=$1
    readonly EXE=$2
    readonly APP=$3

    readonly CORE_REFLECTOR=$(reflector 5020)
    readonly FRAMEWORK_REFLECTOR=$(reflector 5461)

    $EXE $APP > /dev/null

    kill -9 $CORE_REFLECTOR
    kill -9 $FRAMEWORK_REFLECTOR

    readonly TARGET_PATH=./results/$NAME.md
    echo "######### $NAME"
    mv ./BenchmarkDotNet.Artifacts/results/Program-report-github.md $TARGET_PATH
    cat $TARGET_PATH
}

readonly DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR
dotnet restore

publish App.Net461 release
publish App.NetCoreApp20 release
publish Reflector release

readonly TIMESTAMP=$(date +%s)
if [ ! -d ./results ]; then
    mkdir -p ./results
fi

if [ -d ./BenchmarkDotNet.Artifacts ]; then
    rm -rf ./BenchmarkDotNet.Artifacts
fi

test Net461 mono ./bin/App/Net461/App.Net461.exe
test NetCoreApp20 dotnet ./bin/App.NetCoreApp20/App.NetCoreApp20.dll

popd
