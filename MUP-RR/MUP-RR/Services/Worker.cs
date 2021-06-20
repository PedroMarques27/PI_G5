using Microsoft.Extensions.Logging;
using System.Threading;
using System.Threading.Tasks;
using MUP_RR.Models;

namespace MUP_RR.Services
{

    public class Worker: IWorker
    {
        private readonly ILogger<Worker> logger;
        private Program obj = new Program();
        public Worker(ILogger<Worker> logger)
        {
            this.logger = logger;
        }
 
        public async Task DoWork(CancellationToken cancellationToken)
        {
            while (!cancellationToken.IsCancellationRequested)
            {
                obj.database.addLog(LOG.INFO, "Starting Database Update");
                obj.updateDatabaseWithNewBrbData();
                obj.updateNewBRBUsers();
                Program.INITIALIZING = false;
                await Task.Delay(Program.NEW_USERS_PERIOD, cancellationToken);

            }
        }
    }
}