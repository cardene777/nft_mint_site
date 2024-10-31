"use client";

import Header from "./components/Header";
import NFTCard from "./components/NFT";

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-nft-primary to-black">
      <Header />
      <main className="container mx-auto px-4 p-28">
        <div className="max-w-3xl mx-auto text-center mb-12 animate-fade-in">
          <h1 className="text-4xl font-bold text-white mb-4">
            Dapps NFT Collection
          </h1>
        </div>
        <NFTCard />
      </main>
    </div>
  );
}
