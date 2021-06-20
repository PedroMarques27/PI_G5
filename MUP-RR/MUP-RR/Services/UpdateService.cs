using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;
 
namespace MUP_RR.Services
{
    public class UpdateService : IHostedService
    {
        private readonly ILogger<UpdateService> logger;
    

        private Worker worker1;
        public UpdateService(ILogger<UpdateService> logger,
            IWorker worker)
        {
            this.logger = logger;
            this.worker1 = (Worker)worker;
        }
 
 
        public async Task StartAsync(CancellationToken cancellationToken)
        {
            await worker1.DoWork(cancellationToken);
        }
 
        public Task StopAsync(CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }
    }
}