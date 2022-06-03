const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
      ["Shiva", "Ganesha", "Hanuman"],
      ["https://i.imgur.com/uuhHEbk.jpeg",
      "https://i.imgur.com/hBFmGg5.jpeg",
      "https://i.imgur.com/Vy1H7TH.jpeg"],
      [500, 450, 475],
      [300, 270, 250]
    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);
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