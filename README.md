# Construction d'un conteneur contenant une cross-toolchain
Il s'agit de construire une image d'conteneur en utilisant Docker et d'y installer une cross-toolchain (crosstool-ng), puis de compiler cette image dans une RPi.

# Preparation  

### Docker + Cross-toolchain custom
Télécharger dans un même dossier les fichiers `arm-ynov-linux-gnuabihf` et `dockerfile`
- **arm-ynov-linux-gnuabihf** : Contient la configuration customisée de la cross-toolchain (tuple custom + hardware floating point enabled)
- **dockerfile** : Document texte contenant toutes les commandes permettant la construction de l'image

### Docker + Cross-toolchain par défaut
Télécharger uniquement le fichier `dockerfile-default` dans un dossier

# Build 
Placez vous dans le dossier contenant le fichier Docker, puis dans une invite de commande :  
```
sudo docker build -t <XXX> . 
```

Remplacez `<XXX>` par le nom désiré pour l'image.

# Source 
https://github.com/yassine-elmernissi/bachelor-embedded-linux/tree/main/labs/lab1
