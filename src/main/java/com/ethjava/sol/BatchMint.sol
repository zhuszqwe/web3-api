/**
 *Submitted for verification at Etherscan.io on 2023-05-05
*/

/**
 *Submitted for verification at Etherscan.io on 2023-05-04
*/

pragma solidity ^0.8.0;
interface Clip {
    function mintClips() external;

    function transfer(address to, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}
/*
定义了一个 claimer 合约，构造函数接受一个地址参数 receiver。
构造函数使用 Clip 接口的实例 clip 调用 mintClips 函数生成一个新的 Clip 代币，并将其转移到 receiver 地址。
*/
contract claimer {
    constructor (address receiver) {
        Clip clip = Clip(0x8080606508cA52eAeB4c78649E37d1067184C558);
        clip.mintClips();
        clip.transfer(receiver, clip.balanceOf(address(this)));
    }
}


contract BatchMintClips {
    address public owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner.");
        _;
    }
    constructor() {
        owner = msg.sender;
    }

/*它接受一个整数 count 作为参数，并使用一个 for 循环来调用 claimer 合约 count 次，
从而生成 count 个新的 Clip 代币。循环体中的 unchecked 关键字用于告诉编译器这个循环不会无限循环，从而避免编译器抛出警告。
最后，batchMint 函数通过 Clip 接口的实例 clip 将生成的代币转移给调用者和 owner。
调用者获得 95 % 的代币，owner 获得剩余的 5 %*/
    function batchMint(uint count) external {
        for (uint i = 0; i < count;) {
            new claimer(address(this));
            unchecked {
                i++;
            }
        }

        Clip clip = Clip(0x8080606508cA52eAeB4c78649E37d1067184C558);
        clip.transfer(msg.sender, clip.balanceOf(address(this)) * 95 / 100);
        clip.transfer(owner, clip.balanceOf(address(this)));
    }
}
