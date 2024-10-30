"use client";

import Image from "next/image";
import { ShoppingCart } from "lucide-react";

const NFTCard = () => {
  const handleMint = () => {};

  return (
    <div className="bg-nft-secondary rounded-2xl p-6 max-w-sm mx-auto animate-fade-in mt-16">
      <div className="aspect-square rounded-xl overflow-hidden mb-6">
        <Image
          src="/img/dapps_nft.png"
          alt="NFT Image"
          width={500}
          height={500}
          className="object-cover transform transition-transform duration-300 hover:scale-105"
        />
      </div>
      <div className="space-y-4">
        <h2 className="text-xl font-bold text-white">Dapps NFT</h2>
        <p className="text-gray-400">
          Dapps開発のサンプルNFT。
        </p>
        <div className="flex justify-between items-center">
          {/* <div>
            <p className="text-sm text-gray-400">価格</p>
            <p className="text-xl font-bold text-white">0.001 ETH</p>
          </div> */}
          <button
            onClick={handleMint}
            className="bg-gradient-to-r from-indigo-500 to-indigo-600 hover:from-indigo-600 hover:to-indigo-700 text-white px-6 py-2 rounded-full flex items-center gap-2 transition-all duration-300"
          >
            <ShoppingCart className="w-5 h-5" />
            Mint Now
          </button>
        </div>
      </div>
    </div>
  );
};

export default NFTCard;
