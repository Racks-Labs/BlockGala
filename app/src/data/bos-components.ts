import type { NetworkId } from "@/utils/types";

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
  },
};
