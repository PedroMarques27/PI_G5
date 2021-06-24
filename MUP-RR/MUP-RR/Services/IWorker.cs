using System.Threading;
using System.Threading.Tasks;


namespace MUP_RR.Services
{
    public interface IWorker
    {        
        Task DoWork(CancellationToken cancellationToken);
    }
}