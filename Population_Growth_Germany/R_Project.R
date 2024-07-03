install.packages("tidyverse")
library(tidyverse)

population <- read_csv("world_population.csv")

head(population)
colnames(population)

population_2 <- population %>%
  rename("population_2022" = "2022 Population", 
         "population_2020" = "2020 Population", 
         "population_2015" = "2015 Population", 
         "Country" = "Country/Territory")

head(population_2)

european_countries <- select(population_2, Continent, Country, population_2022) %>%
  filter(Continent == "Europe", population_2022 >= "1000000")

View(european_countries)

populated_nations <- european_countries %>%
  arrange(desc(population_2022))

head(populated_nations)

Germany <- population_2 %>%
  select(Country, population_2022, population_2020, population_2015, population_2010) %>%
  filter(Country == "Germany")

head(Germany)

population_n <- c(83369843,83328988,82073226)
year <- c(2022, 2020, 2015)
Germany_population <- data.frame(population_n, year)

View(Germany_population)

ggplot(data=Germany_population) +
  geom_smooth(mapping = aes(x = year, y = population_n)) +
  labs( title = "Germany", subtitle = "The Population Growth of Germany from 2015 to 2022")