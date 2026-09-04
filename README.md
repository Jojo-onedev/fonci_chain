# 🎓 DiploChain - Certification de Diplômes sur Blockchain

> **Projet Hackathon MIABEE 2026 - GovTech Blockchain**  
> Groupe **ChainUp** · Burkina Faso

DiploChain est une solution complète de certification et de vérification de diplômes académiques basée sur la blockchain **Polygon**. Elle rend la falsification de diplômes techniquement impossible grâce à la cryptographie et aux Smart Contracts.

---

## 🏗️ Architecture du Projet

```
ChainUp/
├── blockchain/          # Smart Contract Solidity + Hardhat
├── admin-web/           # Portail Web (Ministère, Université, Diplômé)
├── mobile-verify/       # App Mobile (Vérification Online/Offline)
└── GUIDE_PROJET/        # Documentation pédagogique
```

---

## ⚙️ Stack Technique

| Couche | Technologie |
|--------|------------|
| **Blockchain** | Solidity 0.8.24, Hardhat 2.22.17 |
| **Réseau** | Polygon Amoy Testnet (Chainid: 80002) |
| **Frontend Web** | React 18, Vite, Tailwind CSS, GSAP |
| **Application Mobile** | React Native (Expo SDK 51) |
| **Connexion Blockchain** | Ethers.js v6 |
| **Signature Offline** | Cryptographie JSON Signée (HMAC-like) |
| **Vérification** | Hybride (On-chain & Signature locale) |

---

## 🔐 Sécurité & Cryptographie

DiploChain utilise une approche de sécurité à deux niveaux :

### 1. Niveau On-Chain (Preuve de Vérité)
Chaque diplôme possède une empreinte numérique (**Hash SHA-256**) stockée de manière indélébile sur le réseau Polygon. L'adresse du contrat sur Amoy est : `0x78b7813df1e6a5907744aff6E4FfA91D8EAf3A9d`.

### 2. Niveau Off-Chain (Preuve d'Intégrité)
Le QR Code généré est un **Objet JSON Signé** contenant les données de l'étudiant et une signature cryptographique calculée par l'université. 

---

## 📶 Mode Hors-Ligne (Offline-First)

C'est l'innovation majeure pour le contexte Burkinabè. 
- **Problème** : Les agents de contrôle n'ont pas toujours accès à internet.
- **Solution** : L'app mobile recalcule la signature localement. Si elle correspond, le diplôme est déclaré **"Authentifié Hors-Ligne"**.

---

## 📦 Modules du Projet

### 1. Portails Web (admin-web)
Interface regroupant tous les acteurs :
- 🏛️ **Portail Ministère** : Accréditation souveraine des universités.
- 🏢 **Portail Université** : Émission massive et sécurisée.
- 🎓 **Espace Diplômé** : Coffre-fort numérique personnel.

### 2. App Mobile (mobile-verify)
Outil pour les recruteurs et agents de l'État :
- Scanner QR Code (Vérification instantanée).
- Saisie manuelle de Hash.
- Historique des scans récents.

---

## 📱 Build & Export Mobile (APK)

1. **Configuration** : `cd mobile-verify && npx eas-cli build:configure`
2. **Générer l'APK** : `npx eas build -p android --profile preview`
3. **Installation** : Téléchargez et installez le fichier `.apk` généré par Expo.

---

## 👥 Équipe ChainUp

Projet développé avec passion pour le **Hackathon MIABEE 2026**.
Groupe : **ChainUp** (Burkina Faso)

---

## 📄 Licence

MIT - Libre d'utilisation pour des projets académiques et gouvernementaux.
