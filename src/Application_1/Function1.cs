using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

public static class CallFunc
{
    private static readonly HttpClient httpClient = new HttpClient();

    [Function("CallApp2")]
    public static async Task<IActionResult> Run(
        [HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequest req)
    {
        string functionApp2Url = "https://dns-app2.azurewebsites.net/api/ReceiveCall?code=xxxx";// add your dns-app2 function key here
        // "http://localhost:7218/api/ReceiveCall"; local testing

        try
        {
            HttpResponseMessage response = await httpClient.GetAsync(functionApp2Url);
            string responseBody = await response.Content.ReadAsStringAsync();

            return new OkObjectResult($"Function App 2 responded with: {responseBody}");
        }
        catch (HttpRequestException ex)
        {
            return new StatusCodeResult(500);
        }
    }
}