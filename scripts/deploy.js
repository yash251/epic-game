const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
      ["Shiva", "Ganesha", "Hanuman"],
      ["https://i.imgur.com/uuhHEbk.jpeg",
      "https://i.imgur.com/hBFmGg5.jpeg",
      "https://i.imgur.com/Vy1H7TH.jpeg"],
      [500, 450, 475],
      [300, 270, 250],
      "Thanos", // Boss name
      "https://i.imgur.com/7IvIR2v.jpeg", // Boss img
      10000, // Boss HP
      50 // Boss attack damage
    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);

    let txn;
    txn = await gameContract.mintCharacterNFT(0);
    await txn.wait();
    console.log("Minted NFT #1");

    txn = await gameContract.mintCharacterNFT(1);
    await txn.wait();
    console.log("Minted NFT #2");

    txn = await gameContract.mintCharacterNFT(2);
    await txn.wait();
    console.log("Minted NFT #3");

    txn = await gameContract.mintCharacterNFT(0);
    await txn.wait();
    console.log("Minted NFT #4");

    console.log("Done deploying and minting!");

    // Get the value of NFT's URI
    let returnedTokenUri = await gameContract.tokenURI(1);
    console.log("Token URI : ", returnedTokenUri);
};
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
};
  
runMain();