import Configuration
import Logging

func loadConfig(logger: Logger) async -> ConfigReader {
  let config: ConfigReader
  let envFile = try? await ConfigReader(
    provider: EnvironmentVariablesProvider(
      environmentFilePath: ".env",
    ))
  if let envFile {
    logger.notice("Loadead env file")
    config = envFile
  } else {
    logger.notice("Could not load env file, attempting process env variables")
    config = ConfigReader(provider: EnvironmentVariablesProvider())
  }
  return config
}
