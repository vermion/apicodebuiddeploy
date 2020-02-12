#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 27300

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["ECSTestAPI/ECSTestAPI.csproj", "ECSTestAPI/"]
RUN dotnet restore "ECSTestAPI/ECSTestAPI.csproj"
COPY . .
WORKDIR "/src/ECSTestAPI"
RUN dotnet build "ECSTestAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ECSTestAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ECSTestAPI.dll"]