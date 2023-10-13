# BlockGala, Protocol & Infrastructure Layer
### Vision
Create a subscription solution which boosts earnings and dynamism for customers and companies together. Even with potential replacing conventional ticketing and supplying affiliation programs.

### Description
BlockGala is this new thing in blockchain, designed around what you can call a subscription model. What's cool is that it's not just a regular subscription—you get periodically rewarded with unique experiences or events. Think of it like getting a token for a free movie on Movistar+ or a seat at a Real Madrid game. And guess what? You can sell these tokens in secondary markets, or just give them away to your friends as a kind of referral perk.

But here’s where it gets interesting. You know how you're never sure how much a subscription is really worth? BlockGala solves that with an auction feature. You can put up your subscription for auction, and people bid on it based on what they think these tradeable experiences are worth. So it’s a win-win, and you don’t have to pay full price if you just want one or two specific experiences.

So about the techy stuff, the smart contracts and all. BlockGala uses a Diamond Proxy pattern. This is good for updates and optimizes storage. Here's a quick rundown:

- **DiamondLoupe**: This one manages other smart contracts, like adding or removing them.

- **LiquidEventFacet**: Deals with the tradeable experiences, deploying a thing called NFTCollection to tokenize them.

- **LiquidSubscriptionFacet**: This one’s interesting, it lets you buy subscriptions in different ways. You can go through an auction, or use a proprietary website, and they also have this paymaster thing.

 - **OrganizerFacet**: This is for whoever creates the subscription. They get to manage it, make changes, and deploy a vault called SubscriptorsVault.

- **RedeemsFacet**: This one’s got some strong crypto game. It uses asymmetric keys and ECDSA for secure redemptions.

- **TradingFacet**: Lets you take your internal accounting stuff and move it to secondary markets. You can also sell these experiences peer-to-peer or use other external protocols.

- **EventCollection**: NFT collection, deployed by minimal proxies to further reduce gas costs, used for externalizing the virtual accounting of the protocol logic internal variables to external markets.

- **SubscriptorsVault**: My favourite one, a vault which gives you shares over the token it issues (it can be a DAO Token for Telefonicas Movistar+ users to propose new movies and series to be included, or a token 1:1 pegged to the affilition program one they have. The shares are directly correlated with the amount you have invested in subscriptions. Each type of subscription have their own Vault, each one gets deployed with minimal proxies also.

#### Contracts Diagram

![image](https://github.com/alex-alra-arteaga/BlockGala/assets/108436798/8030da40-24d1-44ab-86d5-7f9d22b0f024)


A lovely part it has, is that the landing of our frontend is stored in NEARs BOS, which means there's a decentralized an permisionless source of truth for accessing and pinning our protocol. A feature that if Uniswap had it implemented a few months ago, would have prevented its DNS attack it suffered, losing millions to its users.

So yeah, BlockGala is sorta redefining how we think about subscriptions by mixing blockchain and tokenized experiences, all backed by a smart contract setup that can adapt and grow.
## Contracts Addresses on Arthera

- **Diamond**: 0x14d52ec925FaA06e78b9E50CD7414AD11419C0f4
- **DiamondLoupeFacet**: 0x0177cEEdC7c471Fbc92E94503Bd0Ea69C71A7429
- **DiamondCutFacet**: 0x2EB8FE4059A2df0cdeB4396f130096309119c4Fb
- **LiquidEventFacet**: 0xc20e36809ae37fEeF6543CC85466E51C91D54f8B
- **LiquidSubscriptionFacet**: 0x64EaE401d1CEEA46845a196a49F8da3a2Dd36FaE
- **OrganizerFacet**: 0xF3Fe973f3Bd3d6ac17A75103c808c375eA74FBFc
- **RedeemsFacet**: 0xf6c41de1Cb1C468cEf1F012b6B234Edb5520d22F
- **TradingFacet**: 0xA6371a12fE38d03c36b5b6F1FC498A4b7AbBFd2c
- **ViewFacet**: 0x60C9729Fe8ebA284cfB54B014AfA2d71D7E8f0F7
- **EventCollection**: 0x8b19afd24d9c02d394154321389cef1bc2a3cff3
- **USDC**: 0xe3d5ca6861a5cabd30aaaf78333b0cc7ea809dff
- **SubscriptorsVault**: 0x1d3a9936bfb01152d6c4b901c220c3c97272777e
