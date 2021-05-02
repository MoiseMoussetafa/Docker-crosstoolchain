# Construction d'un conteneur contenant une cross-toolchain
Il s'agit de construire une image d'conteneur en utilisant Docker et d'y installer une cross-toolchain (crosstool-ng), puis de compiler cette image dans une RPi.

# Build 
Placer le dockerfile dans le dossier souhaité puis :  
```
sudo docker build -t <XXX> . 
```

Remplacez <XXX> par le nom désiré pour l'image.

# Source 
https://github.com/yassine-elmernissi/bachelor-embedded-linux/tree/main/labs/lab1
