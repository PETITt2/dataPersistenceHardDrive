# PERSISTENCE DES DONNÉES — DISQUE DUR

### Contexte

Dans ce projet nous testons différentes méthodes de suppression de données sur le disque dur d'un ordinateur (avec un système d'exploitation déjà installé et des données présentes), puis nous tentons de récupérer ces données à l'aide de méthodes de forensic.

## Matériel, outils et logiciels

Matériel
- Un ordinateur portable DELL Vostro 15
- Un disque dur Western Digital Black 500 Go

Outils
- Un jeu de tournevis (pour démonter l'ordinateur)
- Une clé USB
- Un second ordinateur (pour créer la clé bootable)

Logiciels
- Rufus
- Systèmes d'exploitation : Windows / Linux
- Autopsy (outil de forensic)

## Installation des systèmes d'exploitation

J'ai installé Ubuntu 24.04.3 LTS. L'installation a été effectuée à l'aide d'une clé USB bootable créée avec Rufus.

## Peuplement du disque dur

Pour remplir le disque, j'ai utilisé un script qui crée des dossiers et des fichiers de différentes extensions (PDF, JPEG, TXT). Attention : les fichiers créés ne sont pas des fichiers complets — ils possèdent uniquement l'extension et un en-tête afin que les outils de forensic les traitent comme des fichiers réels.

Le script génère un nombre de fichiers configurable directement dans le script, ainsi que les emplacements de création, eux aussi modifiables en dur.

Chaque fichier a son hash MD5 associé, enregistré dans un fichier CSV contenant : la date et l'heure de création, le nom du fichier et son emplacement.

Le script se trouve à la racine du projet sous le nom : `peuplerDisqueDur.sh`

## Suppression des données

