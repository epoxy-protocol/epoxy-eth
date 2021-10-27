import { expect } from "chai";
import { ethers } from "hardhat";

describe("EpoxyBridge", function () {
  it("Should return the new greeting once it's changed", async function () {
    const EpoxyBridge = await ethers.getContractFactory("EpoxyBridge");
    const bridge = await EpoxyBridge.deploy();
    await bridge.deployed();

    expect(await bridge.getNextLockId()).to.equal(0);

    const initiateLockTx = await bridge.initiateLock("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266");

    await initiateLockTx.wait();

    expect(await bridge.getNextLockId()).to.equal(1);
  });
});
