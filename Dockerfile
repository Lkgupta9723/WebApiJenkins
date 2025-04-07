# Base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8083

ENV ASPNETCORE_URLS=http://+:8083

# SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["WebApiJenkins/WebApiJenkins.csproj", "WebApiJenkins/"]
RUN dotnet restore "WebApiJenkins/WebApiJenkins.csproj"
COPY . .
WORKDIR "/src/WebApiJenkins"
RUN dotnet build "WebApiJenkins.csproj" -c $configuration -o /app/build

# Publish the application
FROM build AS publish
ARG configuration=Release
RUN dotnet publish "WebApiJenkins.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WebApiJenkins.dll"]
