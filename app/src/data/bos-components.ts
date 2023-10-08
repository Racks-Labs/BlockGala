import type { NetworkId } from "@/utils/types";
import { ethers, Contract } from "ethers";
import { SubscriberArtheraABI, Diamond} from "../smart_contract/constants"

type NetworkComponents = {
  [k: string]: { id: string; props?: Record<string, unknown> };
};

const getComponent = (...[name]: TemplateStringsArray[]) =>
  `c5d50293c3a3ed146051462e6e02e469acda10b517bfffeb3d34652076f0cb7c/widget/${name}`;

export const componentsByNetworkId: Record<
  NetworkId,
  NetworkComponents | undefined
> = {
  testnet: {},
  mainnet: {
    landing: {
      id: getComponent`BlockgalaLanding`,
      props: {
        fn: () => window.location.href = "/app",
      },
    },
    input: {
      id: getComponent`ArtheraInput`,
      props: {
        fn: () => {
          // do something with the user input
          console.log("input")
        },
        cb: (input: string) => {
          const provider = new ethers.providers.Web3Provider(window.ethereum);
          const signer = provider.getSigner();

          const subscriberArthera = new Contract("0x000000000000000000000000000000000000aa07", SubscriberArtheraABI, signer)
            subscriberArthera.whitelistAccount(Diamond, input).then((tx: any) => {
              tx.wait(1).then(() => {
                alert("Succesfully whitelisted");
                console.log("Succesfully whitelisted");
              });
          });
        }
      },
    },
  },
};
