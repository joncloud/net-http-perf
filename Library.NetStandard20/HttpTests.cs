using System;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

namespace Library.NetStandard20
{
    public class HttpTests
    {
        readonly HttpClient _http = new HttpClient
        {
            BaseAddress = new Uri("http://127.0.0.1:5020")
        };

        public async Task<string> HttpClient()
        {
            var content = new StringContent("{\"lorem\":\"ipsum\"}");
            var response = await _http.PostAsync("/", content);
            return await response.Content.ReadAsStringAsync();
        }

        public string HttpWebRequest()
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://127.0.0.1:5020");
            request.Method = "POST";

            using (var stream = request.GetRequestStream())
            using (var writer = new StreamWriter(stream))
            {
                writer.WriteLine("{\"lorem\":\"ipsum\"}");
            }

            using (var response = request.GetResponse())
            using (var stream = response.GetResponseStream())
            using (var reader = new StreamReader(stream))
            {
                return reader.ReadToEnd();
            }
        }
    }
}
