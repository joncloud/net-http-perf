using BenchmarkDotNet.Attributes;
using BenchmarkDotNet.Running;
using System.Threading.Tasks;

namespace App.Net461
{
    [MemoryDiagnoser]
    public class Program
    {
        static void Main(string[] args) => BenchmarkRunner.Run<Program>();

        readonly Library.Net461.HttpTests _net461 = new Library.Net461.HttpTests();
        readonly Library.NetStandard20.HttpTests _netStandard20 = new Library.NetStandard20.HttpTests();

        [Benchmark(Baseline = true)]
        public Task<string> Net461_HttpClient() => _net461.HttpClient();

        [Benchmark]
        public string Net461_HttpWebRequest() => _net461.HttpWebRequest();

        [Benchmark]
        public Task<string> NetStandard20_HttpClient() => _netStandard20.HttpClient();

        [Benchmark]
        public string NetStandard20_HttpWebRequest() => _netStandard20.HttpWebRequest();
    }
}
