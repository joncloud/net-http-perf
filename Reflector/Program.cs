using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;

namespace Reflector
{
    public class Program
    {
        public static void Main(string[] args)
            => BuildWebHost(args).Run();

        public static IWebHost BuildWebHost(string[] args)
            => WebHost.CreateDefaultBuilder(args)
                .UseStartup<Program>()
                .Build();

        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
            => app.Run(context => context.Request.Body.CopyToAsync(context.Response.Body));
    }
}
