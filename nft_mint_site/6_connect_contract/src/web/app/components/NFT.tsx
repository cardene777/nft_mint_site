"use client";

import { useState } from "react";
import Image from "next/image";
import { useWriteContract } from "wagmi";
import abi from "../abis/DappsNFT.json";
import { ShoppingCart, Loader2 } from "lucide-react";

const NFTCard = () => {
  const [to, setTo] = useState("");
  const [uri, setUri] = useState("");
  const [txHash, setTxHash] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const { writeContractAsync } = useWriteContract();

  const handleMint = async () => {
    setIsLoading(true);
    setTxHash("");
    try {
      const tx = await writeContractAsync({
        abi: abi.abi,
        address: "0x1B41A542CA821B211d141540672a804A3e8e0B68",
        functionName: "safeMint",
        args: [to, uri],
      });
      setTxHash(tx);
    } catch (error) {
      console.error("トランザクションエラー:", error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="relative space-y-6">
      {isLoading && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center">
          <div className="flex flex-col items-center">
            <Loader2 className="animate-spin w-16 h-16 text-white" />
            <p className="mt-4 text-white text-lg">トランザクション処理中...</p>
          </div>
        </div>
      )}

      <div className="flex flex-col justify-center gap-4 w-full">
        <div className="w-1/2 self-center">
          <label
            htmlFor="to"
            className="block text-sm font-medium text-gray-300 mb-1"
          >
            To
          </label>
          <input
            id="to"
            type="text"
            value={to}
            onChange={(e) => setTo(e.target.value)}
            className="w-full bg-nft-secondary/50 border border-gray-600 rounded-lg px-4 py-2 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
            placeholder="送信先アドレス"
          />
        </div>
        <div className="w-1/2 self-center">
          <label
            htmlFor="uri"
            className="block text-sm font-medium text-gray-300 mb-1"
          >
            URI
          </label>
          <input
            id="uri"
            type="text"
            value={uri}
            onChange={(e) => setUri(e.target.value)}
            className="w-full bg-nft-secondary/50 border border-gray-600 rounded-lg px-4 py-2 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
            placeholder="Image URI"
          />
        </div>
      </div>

      {txHash && (
        <div className="mt-4 text-center">
          <a
            href={`https://holesky.etherscan.io/tx/${txHash}`}
            target="_blank"
            rel="noopener noreferrer"
            className="text-white underline"
          >
            トランザクションを確認する
          </a>
        </div>
      )}

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
          <p className="text-gray-400">Dapps開発のサンプルNFT。</p>
          <div className="flex justify-between items-center">
            <button
              onClick={handleMint}
              disabled={isLoading}
              className={`${
                isLoading
                  ? "bg-gray-500 cursor-not-allowed"
                  : "bg-gradient-to-r from-indigo-500 to-indigo-600 hover:from-indigo-600 hover:to-indigo-700"
              } text-white px-6 py-2 rounded-full flex items-center gap-2 transition-all duration-300`}
            >
              {isLoading ? (
                <Loader2 className="animate-spin w-5 h-5" />
              ) : (
                <>
                  <ShoppingCart className="w-5 h-5" />
                  Mint Now
                </>
              )}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default NFTCard;
