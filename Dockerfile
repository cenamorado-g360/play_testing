FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["play_testing.csproj", "./"]
RUN dotnet restore "play_testing.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "play_testing.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "play_testing.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "play_testing.dll"]
