const { expect } = require("chai");

// In describe test struct , beforeEach it afterEach
// Each it are independent of each other
describe("EXM", function () {
  // Type uint256 in solidity corresponds to type bigInt in js.
  let initialSupply = BigInt(1000000);
  beforeEach(async function () {
    const EXM = await ethers.getContractFactory("EXM");
    [owner, addr1, addr2] = await ethers.getSigners();
    // owner will be the accouth which will create a contract case of ERC20Token
    token = await EXM.deploy(initialSupply);
  });
  it("Should assign the total supply of tokens to the owner", async function () {
    const ownerBalance = await token.balanceOf(owner.address);
    expect(await token.totalSupply()).to.equal(ownerBalance);
  });

  it("Should transfer tokens between accounts", async function () {
    // Transfer 50 tokens from owner to addr1
    await token.transfer(addr1.address, 50);
    const addr1Balance = await token.balanceOf(addr1.address);
    expect(addr1Balance).to.equal(50);

    // Transfer 50 tokens from addr1 to addr2
    await token.connect(addr1).transfer(addr2.address, 50);
    const addr2Balance = await token.balanceOf(addr2.address);
    expect(addr2Balance).to.equal(50);
  });

  it("Should fail if sender doesn't have enough tokens", async function () {
    const initialOwnerBalance = await token.balanceOf(owner.address);

    // Try to send 1 token from addr1 (0 tokens) to owner (1000000 tokens).
    await expect(
      token.connect(addr1).transfer(owner.address, 1)
    ).to.be.revertedWith("ERC20: transfer amount exceeds balance");

    // Owner balance shouldn't have changed.
    expect(await token.balanceOf(owner.address)).to.equal(initialOwnerBalance);
  });
});
