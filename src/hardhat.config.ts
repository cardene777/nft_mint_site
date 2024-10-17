import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

const { PRIVATE_KEY } = process.env;

if (!PRIVATE_KEY) {
  throw new Error("PRIVATE_KEY is not set");
}

const config: HardhatUserConfig = {
  solidity: "0.8.27",
  networks: {
    holesky: {
      url: "https://holesky.drpc.org",
      accounts: [PRIVATE_KEY],
    },
  },
};

export default config;
