using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

public static class CallFunc
{
    private static readonly HttpClient httpClient = new HttpClient();

    [Function("CallApp2")]
    public static async Task<IActionResult> Run(
        [HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequest req,
        ILogger log)
    {
        log.LogInformation("Triggered Function App 1. Calling Function App 2...");

        string functionApp2Url = "https://dns-app1.azurewebsites.net/api/ReceiveCall"; // Update with the correct function name
        //string functionApp2Url = "https://dns-app2.azurewebsites.net/api/Function2"; // Update with the correct function name

        try
        {
            HttpResponseMessage response = await httpClient.GetAsync(functionApp2Url);
            string responseBody = await response.Content.ReadAsStringAsync();

            log.LogInformation($"Response from Function App 2: {responseBody}");
            return new OkObjectResult($"Function App 2 responded with: {responseBody}");
        }
        catch (HttpRequestException ex)
        {
            log.LogError($"Error calling Function App 2: {ex.Message}");
            return new StatusCodeResult(500);
        }
    }
}