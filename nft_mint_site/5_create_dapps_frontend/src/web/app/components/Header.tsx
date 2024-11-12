"use client";

import { Wallet } from "lucide-react";
import { useConnect, useAccount } from "wagmi";
import { injected } from "wagmi/connectors";

const Header = () => {
  const { connect } = useConnect();
  const { address } = useAccount();

  return (
    <header className="fixed top-0 left-0 right-0 z-50 bg-nft-secondary backdrop-blur-sm">
      <div className="container mx-auto px-12 py-4 flex justify-between items-center">
        <div className="text-2xl font-bold text-white">
          NFT<span className="text-indigo-500">Mint</span>
        </div>
        {address ? (
          <p className="text-white">{address}</p>
        ) : (
          <button
            onClick={() => connect({ connector: injected() })}
            className="bg-gradient-to-r from-indigo-500 to-indigo-600 hover:from-indigo-600 hover:to-indigo-700 text-white px-6 py-2 rounded-full flex items-center gap-2 transition-all duration-300"
          >
            <Wallet className="w-5 h-5" />
            Connect Wallet
          </button>
        )}
      </div>
    </header>
  );
};

export default Header;
