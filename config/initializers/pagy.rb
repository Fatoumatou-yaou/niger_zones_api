require 'pagy/extras/metadata' # Activer les métadonnées

# Configuration par défaut
Pagy::DEFAULT[:items] = 20       # Nombre d'éléments par page par défaut
Pagy::DEFAULT[:max_items] = 100  # Limite du nombre d'éléments par page


# Pagy::I18n.load({ locale: 'de' },
#                 { locale: 'en' },
#                 { locale: 'es' })
#
Pagy::I18n.load(locale: 'fr')