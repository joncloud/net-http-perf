# .NET HTTP Performance Test
This project tests the performance of the `HttpClient` and `HttpWebRequest` classes using both .NET Framework and .NET Core.

## Requirements
.NET Framework 4.6.1 SDK or Mono 5.2
.NET Core SDK 2.0

## Implementation
The solution is made up of three types of projects:
* App - Console application executing all Library tests using BenchmarkDotNet
* Library - Library that exposes a class responsible for testing `HttpClient` and `HttpWebRequest`
* Reflector - Web application that simply echoes a request's body as the response's body

The `App` and `Library` projects are configured for both `net461` and `netcoreapp20`/`netstandard20`.

## Tests
Make sure that `dotnet` is available in the CLI `PATH` environment variable prior to executing.  The test will output the current test run into the `./results` directory, as well as `stdout`.

### Windows Tests
Using PowerShell execute `run.ps1`.

### Linux Tests
In order to run tests on Linux the environment variable `FrameworkPathOverride` must be specified to the `net461` API path.  See [dotnet/sdk Issue #335](https://github.com/dotnet/sdk/issues/335#issuecomment-324431853) for more information.
Using Bash execute `run.sh`.

## Results
The results show that `HttpWebRequest` degrades in performance significantly when running under .NET Core.

### Windows Azure VM
```powershell
dotnet --info
.NET Command Line Tools (2.0.0)

Product Information:
 Version:            2.0.0
 Commit SHA-1 hash:  cdcd1928c9

Runtime Environment:
 OS Name:     Windows
 OS Version:  10.0.15063
 OS Platform: Windows
 RID:         win10-x64
 Base Path:   C:\Program Files\dotnet\sdk\2.0.0\

Microsoft .NET Core Shared Framework Host

  Version  : 2.0.0
  Build    : e8b8861ac7faf042c87a5c2f9f2d04c98b69f28d
```

#### App.Net461
``` ini
BenchmarkDotNet=v0.10.9, OS=Windows 10 Redstone 2 (10.0.15063)
Processor=Intel Xeon CPU E5-2673 v3 2.40GHzIntel Xeon CPU E5-2673 v3 2.40GHz, ProcessorCount=20
  [Host]     : .NET Framework 4.7 (CLR 4.0.30319.42000), 64bit RyuJIT-v4.7.2102.0
  DefaultJob : .NET Framework 4.7 (CLR 4.0.30319.42000), 64bit RyuJIT-v4.7.2102.0
```
 |                       Method |     Mean |    Error |   StdDev | Scaled | ScaledSD |  Gen 0 | Allocated |
 |----------------------------- |---------:|---------:|---------:|-------:|---------:|-------:|----------:|
 |            Net461_HttpClient | 640.1 us | 12.80 us | 33.94 us |   1.00 |     0.00 | 3.4180 |  22.15 KB |
 |        Net461_HttpWebRequest | 584.6 us | 11.66 us | 19.16 us |   0.92 |     0.06 | 0.9766 |  19.62 KB |
 |     NetStandard20_HttpClient | 770.0 us | 18.23 us | 53.74 us |   1.21 |     0.10 | 2.9297 |  21.99 KB |
 | NetStandard20_HttpWebRequest | 816.9 us | 16.11 us | 34.32 us |   1.28 |     0.09 | 0.9766 |  19.62 KB |

#### App.NetCoreApp20
``` ini
BenchmarkDotNet=v0.10.9, OS=Windows 10 Redstone 2 (10.0.15063)
Processor=Intel Xeon CPU E5-2673 v3 2.40GHz, ProcessorCount=20
.NET Core SDK=2.0.0
  [Host]     : .NET Core 2.0.0 (Framework 4.6.00001.0), 64bit RyuJIT
  DefaultJob : .NET Core 2.0.0 (Framework 4.6.00001.0), 64bit RyuJIT
```
 |                       Method |       Mean |    Error |   StdDev |     Median | Scaled | ScaledSD | Allocated |
 |----------------------------- |-----------:|---------:|---------:|-----------:|-------:|---------:|----------:|
 |            Net461_HttpClient |   571.6 us | 12.58 us | 37.10 us |   554.7 us |   1.00 |     0.00 |   2.24 KB |
 |        Net461_HttpWebRequest | 2,835.8 us | 36.56 us | 34.20 us | 2,841.7 us |   4.98 |     0.31 |  15.77 KB |
 |     NetStandard20_HttpClient |   770.3 us | 15.39 us | 41.07 us |   789.1 us |   1.35 |     0.11 |   2.24 KB |
 | NetStandard20_HttpWebRequest | 2,698.2 us | 18.89 us | 16.74 us | 2,695.9 us |   4.74 |     0.29 |  15.77 KB |

### Windows MBP
```powershell
dotnet --info
.NET Command Line Tools (2.0.0)

Product Information:
 Version:            2.0.0
 Commit SHA-1 hash:  cdcd1928c9

Runtime Environment:
 OS Name:     Windows
 OS Version:  10.0.15063
 OS Platform: Windows
 RID:         win10-x64
 Base Path:   C:\Program Files\dotnet\sdk\2.0.0\

Microsoft .NET Core Shared Framework Host

  Version  : 2.0.0
  Build    : e8b8861ac7faf042c87a5c2f9f2d04c98b69f28d
```

#### App.Net461
``` ini
BenchmarkDotNet=v0.10.9, OS=Windows 10 Redstone 2 (10.0.15063)
Processor=Intel Core i5-4258U CPU 2.40GHz (Haswell), ProcessorCount=4
Frequency=2343750 Hz, Resolution=426.6667 ns, Timer=TSC
  [Host]     : .NET Framework 4.7 (CLR 4.0.30319.42000), 64bit RyuJIT-v4.7.2102.0
  DefaultJob : .NET Framework 4.7 (CLR 4.0.30319.42000), 64bit RyuJIT-v4.7.2102.0
```
 |                       Method |       Mean |    Error |    StdDev | Scaled | ScaledSD |   Gen 0 | Allocated |
 |----------------------------- |-----------:|---------:|----------:|-------:|---------:|--------:|----------:|
 |            Net461_HttpClient | 1,336.9 us | 56.36 us | 158.97 us |   1.00 |     0.00 | 14.6484 |   23.1 KB |
 |        Net461_HttpWebRequest | 1,127.4 us | 22.29 us |  61.03 us |   0.85 |     0.11 | 12.6953 |   19.7 KB |
 |     NetStandard20_HttpClient |   891.3 us | 29.04 us |  79.02 us |   0.68 |     0.10 | 14.6484 |  23.11 KB |
 | NetStandard20_HttpWebRequest |   713.2 us | 15.79 us |  45.31 us |   0.54 |     0.07 | 12.6953 |   19.7 KB |

#### App.NetCoreApp20
 ``` ini
BenchmarkDotNet=v0.10.9, OS=Windows 10 Redstone 2 (10.0.15063)
Processor=Intel Core i5-4258U CPU 2.40GHz (Haswell), ProcessorCount=4
Frequency=2343750 Hz, Resolution=426.6667 ns, Timer=TSC
.NET Core SDK=2.0.0
  [Host]     : .NET Core 2.0.0 (Framework 4.6.00001.0), 64bit RyuJIT
  DefaultJob : .NET Core 2.0.0 (Framework 4.6.00001.0), 64bit RyuJIT
```
 |                       Method |       Mean |     Error |      StdDev |     Median | Scaled | ScaledSD |  Gen 0 | Allocated |
 |----------------------------- |-----------:|----------:|------------:|-----------:|-------:|---------:|-------:|----------:|
 |            Net461_HttpClient | 1,015.0 us |  20.03 us |    43.12 us | 1,010.5 us |   1.00 |     0.00 | 3.9063 |   2.24 KB |
 |        Net461_HttpWebRequest | 9,202.3 us | 541.78 us | 1,588.93 us | 8,374.9 us |   9.08 |     1.61 |      - |  15.52 KB |
 |     NetStandard20_HttpClient |   916.5 us |  18.16 us |    46.56 us |   919.4 us |   0.90 |     0.06 | 3.9063 |   2.24 KB |
 | NetStandard20_HttpWebRequest | 4,822.5 us | 125.25 us |   123.01 us | 4,830.6 us |   4.76 |     0.23 | 7.8125 |  15.52 KB |

### Linux Debian 9
```bash
dotnet --info
.NET Command Line Tools (2.0.0)

Product Information:
 Version:            2.0.0
 Commit SHA-1 hash:  cdcd1928c9

Runtime Environment:
 OS Name:     debian
 OS Version:  9
 OS Platform: Linux
 RID:         linux-x64
 Base Path:   /home/jdberube/.dotnet/sdk/2.0.0/

Microsoft .NET Core Shared Framework Host

  Version  : 2.0.0
  Build    : e8b8861ac7faf042c87a5c2f9f2d04c98b69f28d

mono --version
Mono JIT compiler version 5.2.0.215 (tarball Mon Aug 14 15:44:25 UTC 2017)
Copyright (C) 2002-2014 Novell, Inc, Xamarin Inc and Contributors. www.mono-project.com
        TLS:           __thread
        SIGSEGV:       altstack
        Notifications: epoll
        Architecture:  amd64
        Disabled:      none
        Misc:          softdebug
        LLVM:          supported, not enabled.
        GC:            sgen (concurrent by default)
```
#### App.Net461
``` ini
BenchmarkDotNet=v0.10.9, OS=debian 9
Processor=Intel Core i5-2400 CPU 3.10GHz (Sandy Bridge), ProcessorCount=4
  [Host]     : Mono 5.2.0.215 (tarball Mon), 64bit
  DefaultJob : Mono 5.2.0.215 (tarball Mon), 64bit
```
 |                       Method |     Mean |    Error |   StdDev | Scaled | ScaledSD |  Gen 0 | Allocated |
 |----------------------------- |---------:|---------:|---------:|-------:|---------:|-------:|----------:|
 |            Net461_HttpClient |       NA |       NA |       NA |      ? |        ? |    N/A |       N/A |
 |        Net461_HttpWebRequest | 330.2 us | 3.492 us | 3.096 us |      ? |        ? | 6.1035 |       0 B |
 |     NetStandard20_HttpClient |       NA |       NA |       NA |      ? |        ? |    N/A |       N/A |
 | NetStandard20_HttpWebRequest | 335.0 us | 2.963 us | 2.627 us |      ? |        ? | 5.8594 |       0 B |

Benchmarks with issues:
* Program.Net461_HttpClient: DefaultJob
* Program.NetStandard20_HttpClient: DefaultJob

#### App.NetCoreApp20
``` ini
BenchmarkDotNet=v0.10.9, OS=debian 9
Processor=Intel Core i5-2400 CPU 3.10GHz (Sandy Bridge), ProcessorCount=4
.NET Core SDK=2.0.0
  [Host]     : .NET Core 2.0.0 (Framework 4.6.00001.0), 64bit RyuJIT
  DefaultJob : .NET Core 2.0.0 (Framework 4.6.00001.0), 64bit RyuJIT
```
 |                       Method |     Mean |    Error |   StdDev |   Median | Scaled | ScaledSD |  Gen 0 | Allocated |
 |----------------------------- |---------:|---------:|---------:|---------:|-------:|---------:|-------:|----------:|
 |            Net461_HttpClient | 272.3 us | 12.46 us | 35.94 us | 260.1 us |   1.00 |     0.00 | 1.9531 |    2600 B |
 |        Net461_HttpWebRequest |       NA |       NA |       NA |       NA |      ? |        ? |    N/A |       N/A |
 |     NetStandard20_HttpClient | 271.7 us | 14.37 us | 41.23 us | 258.5 us |   1.01 |     0.20 | 1.9531 |    2600 B |
 | NetStandard20_HttpWebRequest |       NA |       NA |       NA |       NA |      ? |        ? |    N/A |       N/A |

Benchmarks with issues:
* Program.Net461_HttpWebRequest: DefaultJob
* Program.NetStandard20_HttpWebRequest: DefaultJob