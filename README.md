# Exercices Archetype

Bonjour, bienvenue dans la session d'exercices du langage [Archetype](https://archetype-lang.org/).

# Bases de la syntaxe

## Exercice 1

Écrire, déployer et appeler un premier Smart Contract en Archetype qui permette d’enregistrer une chaîne de caractères et de la modifier avec un point d’entrée qui prend la nouvelle valeur en argument.

Un contrat Archetype commence par le mot clé archetype suivi du nom logique du contrat. Par exemple dans ce cas:

```
archetype hello

...
```

Créer un fichier hello.arl dans VS Code en cliquant droit dans le panneau latéral droit et en sélectionnant “Nouveau Fichier”.

Déployer le contrat avec votre compte de test. Pour cela, importer le compte Faucet dans la CLI de Completium:

```completium-cli import faucet <FAUCET.json> as <ACCOUNT_ALIAS>```

Pour créer le faucet dans l’environnement Gitpod, créer un fichier faucet.json et y copier/coller le contenu du fichier Faucet.

Déclarer ce compte comme le compte courant :

```completium-cli switch account```

Sélectionner le compte que vous venez d’importer.

Déployer le contrat :

```completium-cli deploy hello.arl```

L’URL du contrat apparaît dans la trace de la commande de déploiement. Cliquer dessus pour observer le contrat dans l’indexer Better-Call-Dev.

Appeler le contrat pour changer la chaîne de caractères du contrat :

```completium-cli call hello --with "Hello Archetype World"```

> le contrat n’ayant qu’un point d’entrée, il n’est pas nécessaire de spécifier le nom du point d’entrée. L’option --entry est utilisée pour spécifier le nom du point d’entrée.

## Exercice 2

Une obligation à coupon zéro (zero coupon bond) est la plus simple des obligations entre un émetteur (issuer) et un souscripteur (holder).

La différence entre le prix d'émission (original value) et le prix de rachat (face value) est régie par un coefficient (face rate) tel que:

```face value = face rate * original value```

Le contrat [zcb.arl](./contracts/zcb.arl) implante une obligation à zéro coupon:
le point d’entrée subscribe permet au souscripteur déclaré de transférer les fonds à l’émetteur
le point d’entrée redeem permet à l'émetteur de racheter l’obligation

Parmis les éléments suivants d’une obligation à coupon zéro, 2 ne sont pas implantés par zcb.arl; les trouver et les corriger :
* la date de maturité est calculée comme la date de souscription plus 356 jours
* le rachat de l’obligation ne peut se faire qu’après la date de maturité
* la valeur de rachat (face value) est le prix d’émission multiplié par le coefficient
* le solde du contrat est toujours 0 XTZ

# Collection d'assets

Un token non fongible (non fungible token, NFT) est un token unique que l’on peut transférer d’un propriétaire à un autre.

Le contrat [nft.arl](./contracts/nft.arl) implante un NFT en s’inspirant de la norme du FA 2 de Tezos pour les tokens non fongibles.

Cette norme prévoit que l’on puisse déléguer la capacité de transfert à un tiers. Les informations de délégation (allowance) sont stockées dans une collection d’asset. Le point d’entrée permettant d’autoriser un tiers à transférer son token est allow.

Le tiers délégataire est typiquement un autre contrat qui met en œuvre un processus de vente, comme des enchères par exemple.

Le point d’entrée transfer effectue le transfert de propriété du token en lisant la table des autorisations dans le cas où l'appelant n’est pas le propriétaire du token.

## Exercice 1

Écrire le point d’entrée mint du contrat de token non fongible nft.arl pour ajouter un asset de token au ledger

## Exercice 2

Ajouter des données au token :
* `uri` (adresse IPFS de l’asset digital)
* `creator` (adresse du compte tezos du créateur du NFT)
* `royalties` (pourcentage reversé au créateur à chaque vente)
* `nbtransfers` (nombre de transferts du NFT)

Écrire les points d’entrée :
* `increase` qui augmente de 10% le pourcentage reversé au créateur des tokens ayant été échangés plus de 10 fois
* `rm` qui supprime du ledger les tokens ayant été échangés plus de 20 fois

# Machine à état

## Exercice 1

Écrire une version du contrat zcb.arl avec un état à 4 valeurs:
* `Created`
* `Subscribed`
* `Redeemed`
* `Defaulted`

Transformer le point d’entrée `subscribe` en transition de `Created` vers `Subscribed`.

Transformer le point d’entrée `redeem` en transition de `Subscribed` vers `Redeemed`.

Ajouter une transition `default` appelée par `holder`, qui passe de `Subscribed` vers `Defaulted` si la date d’appel est au-delà de la date de maturité plus la durée de rachat `payback` (à définir).

## Exercice 2

Etablir le point d’entrée `sign` qui doit être appelé par le souscripteur ET l'émetteur pour que le contrat passe de l’état `Created` à `Subscribed`.

Ce point d’entrée mémorise dans deux variables booléennes du Storage si le souscripteur et l’émetteur l’ont appelé.

Lorsque les deux adresses l'ont appelé, `sign` appelle alors la transition `subscribe`.

La transition `subscribe` ne peut donc être appelée que par le contrat lui-même.

> Un contrat peut s’appeler lui-même avec l’instruction transfer:
> `transfer 0tz to entry self.subscribe;`

> L’adresse du contrat est `selfaddress`.




