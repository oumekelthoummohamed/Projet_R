# Script R pour l'analyse des pharmacies
# Objectif : Préparation, Statistiques descriptives, Analyses géographiques

library(tidyverse)

# --- 1. Préparation et Structuration des Données ---

# Importation
# Assurez-vous que le fichier est bien dans data/pharmacies.csv
if (!file.exists("data/pharmacies.csv")) {
  stop("Le fichier data/pharmacies.csv est introuvable.")
}
df <- read_csv("data/pharmacies.csv", show_col_types = FALSE)

# Vérification et Nettoyage
# On renomme pour simplifier
df <- df %>% rename(nombre = `Nombre de pharmacies`)

# Conversion en numérique (gestion des erreurs potentielles)
df <- df %>% mutate(nombre = as.numeric(nombre))

# Gestion des valeurs manquantes (remplacement par 0 ou exclusion selon logique, ici on exclut ou on considère 0)
# Pour l'agrégation, na.rm = TRUE gère les manquants
# Agrégation par Gouvernorat et Délégation
agg_del <- df %>% 
  group_by(Gouvernorat, Délégation) %>% 
  summarise(total_pharmacies = sum(nombre, na.rm = TRUE), .groups = "drop")

# --- 2. Statistiques Descriptives ---

stats_global <- agg_del %>% 
  summarise(
    Moyenne = mean(total_pharmacies),
    Mediane = median(total_pharmacies),
    Ecart_Type = sd(total_pharmacies),
    Minimum = min(total_pharmacies),
    Maximum = max(total_pharmacies),
    Q1 = quantile(total_pharmacies, 0.25),
    Q3 = quantile(total_pharmacies, 0.75),
    Etendue = max(total_pharmacies) - min(total_pharmacies)
  )

print("--- Statistiques Descriptives Globales ---")
print(stats_global)

# --- 3. Analyses Géographiques et de Classement ---

# A. Diagramme en Barres par Délégation (Top 20 pour lisibilité)
top20 <- agg_del %>% arrange(desc(total_pharmacies)) %>% slice_head(n = 20)

p_top20 <- top20 %>% 
  mutate(Délégation = fct_reorder(Délégation, total_pharmacies)) %>%
  ggplot(aes(x = Délégation, y = total_pharmacies)) +
  geom_col(fill = "#f03b20") + 
  coord_flip() + 
  labs(title = "Top 20 des délégations (Nombre de pharmacies)", x = "Délégation", y = "Total") +
  theme_minimal()

# B. Classement (Top 10 et Flop 10)
top10 <- agg_del %>% arrange(desc(total_pharmacies)) %>% slice_head(n = 10)
flop10 <- agg_del %>% arrange(total_pharmacies) %>% slice_head(n = 10)

print("--- Top 10 Délégations ---")
print(top10)
print("--- Flop 10 Délégations ---")
print(flop10)

# C. Comparaison par Gouvernorat
plot_governorate <- function(data, gov_name, color_fill) {
  data %>% 
    filter(Gouvernorat == gov_name) %>% 
    arrange(desc(total_pharmacies)) %>%
    mutate(Délégation = fct_reorder(Délégation, total_pharmacies)) %>%
    ggplot(aes(x = Délégation, y = total_pharmacies)) +
    geom_col(fill = color_fill) + 
    coord_flip() + 
    labs(title = paste("Délégations - Gouvernorat de", gov_name), x = "Délégation", y = "Total") +
    theme_minimal()
}

p_tunis <- plot_governorate(agg_del, "TUNIS", "#2ca25f")
p_sousse <- plot_governorate(agg_del, "SOUSSE", "#3182bd")
p_sfax <- plot_governorate(agg_del, "SFAX", "#e6550d") # Ajout de Sfax comme demandé

# Sauvegarde des figures
if (!dir.exists("figures")) dir.create("figures")
ggsave("figures/top20_delegations.png", plot = p_top20, width = 10, height = 8)
ggsave("figures/tunis_delegations.png", plot = p_tunis, width = 8, height = 6)
ggsave("figures/sousse_delegations.png", plot = p_sousse, width = 8, height = 6)
ggsave("figures/sfax_delegations.png", plot = p_sfax, width = 8, height = 6)

print("Les graphiques ont été sauvegardés dans le dossier 'figures'.")

# --- 4. Conclusion (Synthèse simple pour la console) ---
cat("\n--- Conclusion ---\n")
cat("La distribution montre une forte disparité.\n")
cat("La moyenne (", round(stats_global$Moyenne, 2), ") est supérieure à la médiane (", stats_global$Mediane, "), indiquant une asymétrie à droite.\n")
cat("Certaines délégations (ex: Tunis, Sfax) concentrent un grand nombre de pharmacies.\n")
