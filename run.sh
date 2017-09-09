#!/bin/bash
publish() {
    local APP=$1
    local CONFIGURATION=$2
    local SOURCE_PATH=./$APP
    echo publish $APP $CONFIGURATION
    pushd $SOURCE_PATH

    local TARGET_PATH=../bin/$APP
    if [ -d "$TARGET_PATH" ]; then
        rm -rf "$TARGET_PATH"
    fi

    dotnet publish --configuration $CONFIGURATION --output $TARGET_PATH

    popd
}

reflector() {
    local PORT=$1
    echo reflector $PORT
    export ASPNETCORE_URLS=http://127.0.0.1:$PORT
    dotnet ./bin/Reflector/Reflector.dll &
    local PID=$!
    echo reflector on $PORT with $PID
    return $PID
}

test() {
    local NAME=$1
    local EXE=$2
    local APP=$3
    echo test $NAME using $EXE $APP

    echo starting reflector
    local CORE_REFLECTOR=$(reflector 5020)
    echo core started
    local FRAMEWORK_REFLECTOR=$(reflector 5461)
    echo framework started

    $EXE $APP # > /dev/null

    kill -9 $CORE_REFLECTOR
    kill -9 $FRAMEWORK_REFLECTOR

    local TARGET_PATH=./results/$NAME.md
    echo "######### $NAME"
    mv ./BenchmarkDotNet.Artifacts/results/Program-report-github.md $TARGET_PATH
    cat $TARGET_PATH
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR
dotnet restore

publish App.Net461 release
publish App.NetCoreApp20 release
publish Reflector release

TIMESTAMP=$(date +%s)
if [ ! -d ./results ]; then
    mkdir -p ./results
fi

if [ -d ./BenchmarkDotNet.Artifacts ]; then
    rm -rf ./BenchmarkDotNet.Artifacts
fi

test Net461 mono ./bin/App/Net461/App.Net461.exe
test NetCoreApp20 dotnet ./bin/App.NetCoreApp20/App.NetCoreApp20.dll

popd
