using LunchVoteApi.Data;
using LunchVoteApi.Middleware;
using LunchVoteApi.Services;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Configure DbContext - check if already configured externally (e.g., by tests)
// In testing scenarios, skip SQL Server registration entirely
var isTestEnvironment = builder.Environment.EnvironmentName == "Testing";
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
var useInMemoryDatabase = string.IsNullOrEmpty(connectionString);

if (!isTestEnvironment)
{
    builder.Services.AddDbContext<LunchVoteDbContext>(options =>
    {
        if (useInMemoryDatabase)
        {
            // Use in-memory database when no connection string is configured
            options.UseInMemoryDatabase("LunchVoteInMemoryDb");
        }
        else
        {
            options.UseSqlServer(connectionString);
        }
    });
}

// Register application services
builder.Services.AddScoped<IPollService, PollService>();
builder.Services.AddScoped<IVoteService, VoteService>();

// Configure CORS
var allowedOrigins = builder.Configuration.GetSection("AllowedOrigins").Get<string[]>() 
    ?? new[] { "http://localhost:5173" };

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowSPA", policy =>
    {
        policy.WithOrigins(allowedOrigins)
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Global exception handler
app.UseMiddleware<ExceptionHandlerMiddleware>();

app.UseHttpsRedirection();

app.UseCors("AllowSPA");

app.UseAuthorization();

app.MapControllers();

// Apply migrations on startup in development (only for SQL Server, not for tests)
if (app.Environment.IsDevelopment())
{
    using var scope = app.Services.CreateScope();
    var dbContext = scope.ServiceProvider.GetRequiredService<LunchVoteDbContext>();
    
    try
    {
        // Check if we're using SQL Server before calling EnsureCreated
        if (dbContext.Database.IsSqlServer())
        {
            dbContext.Database.EnsureCreated();
        }
    }
    catch (Exception ex)
    {
        Console.WriteLine(ex.ToString());
        // Ignore if database creation fails (e.g., SQL Server not available)
    }
}

// Seed mock data when using in-memory database
if (useInMemoryDatabase && !isTestEnvironment)
{
    using var scope = app.Services.CreateScope();
    var dbContext = scope.ServiceProvider.GetRequiredService<LunchVoteDbContext>();
    
    MockDataSeeder.Seed(dbContext);
    Console.WriteLine("??? Using in-memory database with mock data (no connection string configured)");
}

app.Run();

// Make Program class accessible for integration tests
public partial class Program { }



