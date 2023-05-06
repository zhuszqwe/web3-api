// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract MRSBOB {
    //声明三个状态变量，totalSupply_ 存储代币的总供应量，balances_ 存储每个地址的余额，allowances_ 存储每个地址允许其他地址使用的代币数量。
    uint256 public totalSupply_;
    mapping(address => uint256) public balances_;
    mapping(address => mapping(address => uint256)) public allowances;
    //声明三个常量，NAME 和 SYMBOL 分别存储代币的名称和符号，DECIMAL_AMOUNT 存储小数位数。
    string public NAME = "MrsBOB";
    string public SYMBOL = "MrsBOB";
    uint8 public DECIMAL_AMOUNT = 18;

    //Transfer 用于在转移代币时触发
    event Transfer(address indexed from, address indexed to, uint256 value);
    //Approval 用于在授权其他地址使用代币时触发。
    event Approval(address indexed owner, address indexed spender, uint256 value);
    //声明一个构造函数，用于初始化代币总供应量和合约创建者的余额。构造函数在合约创建时被调用。
    constructor() {
        _mint(msg.sender, 690_000_000_000_000 ether);
    }
    //声明五个视图函数，用于查询代币的名称、符号、小数位数、总供应量和指定地址的余额。
    function name() public view virtual returns (string memory)
    {
        return NAME;
    }

    function symbol() public view virtual returns (string memory)
    {
        return SYMBOL;
    }

    function decimals() public view virtual returns (uint8)
    {
        return DECIMAL_AMOUNT;
    }

    function totalSupply() public view virtual returns (uint256)
    {
        return totalSupply_;
    }

    function balanceOf(
        address account
    ) public view virtual returns (uint256)
    {
        return balances_[account];
    }

    //转移代币
    function transfer(
        address to,
        uint256 amount
    ) public virtual returns (bool)
    {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }
    // 查询授权的代币数量
    function allowance(
        address owner,
        address spender
    ) public view virtual returns (uint256)
    {
        return allowances_[owner][spender];
    }
    //授权其他地址使用代币
    function approve(
        address spender,
        uint256 amount
    ) public virtual returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }
    //从指定地址转移代币
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }
    //增加授权的代币数量
    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, allowances_[owner][spender] + addedValue);
        return true;
    }
    //减少授权的代币数量。
    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool)
    {
        address owner = _msgSender();
        uint256 currentAllowance = allowances_[owner][spender];
        require(currentAllowance >= subtractedValue, "Decreased allowance below zero.");
    unchecked {
        _approve(owner, spender, currentAllowance - subtractedValue);
    }

        return true;
    }


    //实现代币转移、
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual
    {
        require(from != address(0), "Transfer from the zero address.");
        require(to != address(0), "Transfer to the zero address.");

        uint256 fromBalance = balances_[from];
        require(fromBalance >= amount, "Transfer amount exceeds balance.");
    unchecked {
        balances_[from] = fromBalance - amount;
    }
        balances_[to] += amount;

        emit Transfer(from, to, amount);
    }
    //代币铸造
    function _mint(
        address account,
        uint256 amount
    ) internal virtual
    {
        require(account != address(0), "Mint to the zero address.");

        totalSupply_ += amount;
        balances_[account] += amount;
        emit Transfer(address(0), account, amount);
    }
    //代币销毁
    function _burn(
        address account,
        uint256 amount
    ) internal virtual
    {
        require(account != address(0), "Burn from the zero address.");

        uint256 accountBalance = balances_[account];
        require(accountBalance >= amount, "Burn amount exceeds balance.");
    unchecked {
        balances_[account] = accountBalance - amount;
    }
        totalSupply_ -= amount;

        emit Transfer(account, address(0), amount);
    }
    //授权其他地址使用代币
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual
    {
        require(owner != address(0), "Approve from the zero address.");
        require(spender != address(0), "Approve to the zero address.");

        allowances_[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    //减少授权的代币数量
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual
    {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "Insufficient allowance.");
        unchecked {
            _approve(owner, spender, currentAllowance - amount);
        }
        }
    }


    //声明两个上下文函数，用于返回当前调用方的地址和数据。
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }


}
