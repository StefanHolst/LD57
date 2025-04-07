using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;

namespace LD57;

public class Program
{
  public static void Main(string[] args)
  {
    var builder = WebApplication.CreateBuilder(args);

    builder.Services.AddCors(options =>
    {
        options.AddDefaultPolicy(policyBuilder =>
        {
            policyBuilder.AllowAnyMethod();
            policyBuilder.AllowAnyHeader();
            policyBuilder.AllowAnyOrigin();
        });
    });

    var app = builder.Build();
    app.UseCors();

    var highScores = new HighScoreList();
    app.MapGet("/highscores", () =>
    {
        lock (highScores)
        return highScores.Scores.ToList();
    });
    app.MapPost("/highscores", (HighScore highScore) =>
    {
        lock (highScores)
        {
            if (highScore.Score < 0 || string.IsNullOrWhiteSpace(highScore.Name))
                return Results.BadRequest("Invalid score or name.");
            highScore.Date = DateTime.UtcNow;

            highScores.Scores.Add(highScore);
            highScores.Scores.Sort((x, y) => y.Score.CompareTo(x.Score));
            if (highScores.Scores.Count > 10)
                highScores.Scores.RemoveRange(10, highScores.Scores.Count - 10);
            
            return Results.Ok();
        }
    });

    app.Run();
  }
}

public class HighScore
{
    public int Score { get; set; }
    public string Name { get; set; } = string.Empty;
    public DateTime Date { get; set; } = DateTime.UtcNow;
}

public class HighScoreList
{
    public List<HighScore> Scores { get; set; } = new List<HighScore>();
}