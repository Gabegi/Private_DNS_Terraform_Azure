using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.Functions.Worker;

public static class ReceiveFunc
{
    [Function("ReceiveFunc")]
    public static async Task<IActionResult> Run(
        [HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequest req,
        ILogger log)
    {
        log.LogInformation("Function App 2 triggered.");
        return new OkObjectResult("Hello from Function App 2!");
    }
}
