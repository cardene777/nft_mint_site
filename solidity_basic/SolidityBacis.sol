// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ISolidityBasic} from "./ISolidityBasic.sol";

contract SolidityBasic is ERC721, AccessControl, ISolidityBasic {
    // Comment

    /*
    Comment
    Comment
    */

    // boolean
    bool defaultValue = true;

    function changeDefault() public {
        defaultValue = !defaultValue;
    }

    function andValue(bool value1, bool value2) public pure returns (bool) {
        return value1 && value2;
    }

    function orValue(bool value1, bool value2) public pure returns (bool) {
        return value1 || value2;
    }

    function equalValue(bool value1, bool value2) public pure returns (bool) {
        return value1 == value2;
    }

    function notEqualValue(
        bool value1,
        bool value2
    ) public pure returns (bool) {
        return value1 != value2;
    }

    // uint/int

    function equalUint(
        uint256 value1,
        uint256 value2
    ) public pure returns (bool) {
        return value1 == value2;
    }

    function notEqualUint(
        uint256 value1,
        uint256 value2
    ) public pure returns (bool) {
        return value1 != value2;
    }

    function greaterThanOrEqualUint(
        uint256 value1,
        uint256 value2
    ) public pure returns (bool) {
        return value1 >= value2;
    }

    function lessThanOrEqualUint(
        uint256 value1,
        uint256 value2
    ) public pure returns (bool) {
        return value1 <= value2;
    }

    function greaterThanUint(
        uint256 value1,
        uint256 value2
    ) public pure returns (bool) {
        return value1 > value2;
    }

    function lessThanUint(
        uint256 value1,
        uint256 value2
    ) public pure returns (bool) {
        return value1 < value2;
    }

    // bitwise

    uint256 uintA = 12; // (2進数: 1100)
    uint256 uintB = 10; // (2進数: 1010)
    uint256 andResult = uintA & uintB; // 結果: 8 (2進数: 1000)

    uint256 orResult = uintA | uintB; // 結果: 14 (2進数: 1110)

    uint256 exclusiveOrReult = uintA ^ uintB; // 結果: 6 (2進数: 0110)

    uint256 notReult = ~uintA; // 結果: 0011 (2進数: 3)

    // shift

    uint256 shiftA = 1; // (2進数: 1100)
    uint256 leftShiftResult = shiftA << 2; // 結果: 4 (2進数: 100)

    uint256 shiftB = 12; // (2進数: 1100)
    uint256 leftShiftResult2 = shiftB << 2; // 結果: 48 (2進数: 110000)

    uint256 shiftC = 4; // (2進数: 100)
    uint256 rightShiftResult = shiftC >> 1; // 結果: 2 (2進数: 10)

    uint256 shiftD = 48; // (2進数: 110000)
    uint256 rightShiftResult2 = shiftD >> 2; // 結果: 12 (2進数: 1100)

    // arithmetic

    uint256 valueA = 100;
    uint256 valueB = 50;
    uint256 plusResult = valueA + valueB; // 150

    uint256 valueC = 10;
    uint256 plusResult2 = valueA + valueB + valueC; // 160

    uint256 minusResult = valueA - valueB; // 50

    uint256 minusResult2 = valueA - valueB - valueC; // 40

    uint256 multiResult = valueA * valueB; // 50

    uint256 valueD = 100;
    uint256 valueE = 5;
    uint256 valueF = 10;
    uint256 multiResult2 = valueD * valueE * valueF; // 5,000

    uint256 valueG = 10;
    uint256 valueH = 5;
    uint256 divResult = valueG / valueH; // 2

    uint256 result = valueD / valueE / valueF; // 4

    uint256 valueI = 11;
    uint256 valueJ = 5;
    uint256 modResult = valueI % valueJ; // 1

    uint256 valueK = 10;
    uint256 exp = 2;
    uint256 expResult = valueK ** exp; // 100


    uint256 valueL = 10;
    uint256 exp2 = 3;
    uint256 expResult2 = valueL ** exp2; // 1000

    uint256 incrementValue = 10;
    uint256 decrementValue = 10;

    function updateValue() external {
        incrementValue++;
        decrementValue--;
    }

    function checkUpdateValue() external returns(uint256, uint256) {
        uint256 value1 = incrementValue++;
        uint256 value2 = ++incrementValue;
        return (value1, value2);
    }

    uint256 value_ = 10;
    function addValue(uint256 _num) external {
        value_ += _num;
    }

    uint256 uintUnderBar = 100_100_100;
    int256 intUnderBar = 5_000;

    uint256 uintE = 2e10; // 20,000,000,000
    int256 intE = -2e10; // -20,000,000,000

    uint256 scaledValue1 = uint256(.5 * 10); // 5
    uint256 scaledValue2 = uint256(1.3 * 10); // 13
    // uint256 scaledValue3 = uint256(.3);
    // uint256 public scaledValue2 = uint256(1.3 * 5);

    // fixed

    // fixed fixedA = 10;
    // ufixed ufixedA = 5;

    // address
    address address1 = 0x1234567890123456789012345678901234567890;
    address payable address2 = payable(0x0987654321098765432109876543210987654321);
    address payable payableAddress = payable(address1);

    uint256 addressBalance = address1.balance;

    function getBalance(address _addr) public view returns(uint256) {
        return _addr.balance;
    }

    function getCode(address _addr) public view returns (bytes memory, bytes32) {
        return (_addr.code, _addr.codehash);
    }

    function ethTransfer(address _recipient, uint256 _amount) public payable {
        payable(_recipient).transfer(_amount);
    }

    function ethSend(address _recipient, uint256 _amount) public payable {
        bool success = payable(_recipient).send(_amount);
        require(success, "ETH transfer failed");
    }

    function ethCall(address _recipient, uint256 _amount) public payable {
        (bool success, ) = _recipient.call{value: _amount}("");
        require(success, "ETH transfer failed");
    }


    // bytes
    bytes1 bytesA = 0x12;
    bytes3 bytesB = 0x123456;
    bytes32 bytesC = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

    bytes32 bytesIndex = bytesB[1]; // 0x34
    uint256 bytesLength = bytesC.length; // 32

    // string

    string hello = "hello";
    string world = 'world';

    string backslash = "backslash\\";
    string singleQuote = "single\'quote";
    string doubleQuote = "single\"quote";
    string newLine = "new\nline";

    string rocket = unicode"🚀 Rocket";

    // enum

    enum EnumCountry { Japan, UnitedStates, Canada, Germany }

    function getCountry(EnumCountry enumCountry) external pure returns (string memory) {
        if (enumCountry == EnumCountry.Japan) {
            return "Japan";
        } else if (enumCountry == EnumCountry.UnitedStates) {
            return "United States";
        } else if (enumCountry == EnumCountry.Canada) {
            return "Canada";
        } else if (enumCountry == EnumCountry.Germany) {
            return "Germany";
        }

        return "Unknown";
    }

    uint256 supply;
    string description;
    address owner;
    bytes32 constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    uint128 constant MAX_SUPPLY = 10000;
    uint64 constant mintPrice = 0.01 ether;
    uint32 launch;
    uint16 rewardRate;
    uint8 _version;
    bool isDiscount;

    // function

    uint256 num;

    function setNum(uint256 _num) external {
        num = _num;
    }

    function getNum() external view returns(uint256) {
        return num;
    }

    function _internalOrPrivate() external view returns(uint256) {
        return  num * num;
    }

    event Deposit(address from, uint256 value);

    function deposit() public payable {
        emit Deposit(msg.sender, msg.value);
    }

    function getNums() external view returns(uint256, uint256) {
        return (num, num);
    }

    function calculateNum(uint256 _num) external pure returns(uint256 _result) {
        _result = _num * _num;
    }

    // function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
    //     return
    //         interfaceId == type(IERC721).interfaceId ||
    //         interfaceId == type(IERC721Metadata).interfaceId ||
    //         super.supportsInterface(interfaceId);
    // }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, AccessControl) returns (bool) {
        bool isInterface = super.supportsInterface(interfaceId);
        require(!isInterface, "Not supported interface");
        return isInterface;
    }

    constructor(
        // string memory _description,
        // uint32 _launch,
        // uint16 _rewardRate,
        // uint8 version,
        // bool _isDiscount
    ) ERC721("SolidityBasic", "SB") {
        // _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        // description = _description;
        // launch = _launch;
        // rewardRate = _rewardRate;
        // _version = version;
        // isDiscount = _isDiscount;
    }

    // receive

    event Received(address sender, uint256 amount);

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    // fallback

    event FallbackCalled(address sender, uint256 amount, bytes data);

    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value, msg.data);
    }

    // Array

    uint256[5] fixArrayNum = [1, 2, 3, 4, 5];
    string[3] fixArrayString = ["apple", "orange", "banana"];

    uint256[] arrayNum = [1, 2, 3, 4, 5];
    string[] arrayString = ["apple", "orange", "banana"];

    uint256[] public numbers;

    function getArrayLength() public view returns(uint256) {
        return numbers.length;
    }

    function addArrayNum(uint256 _number) public {
        numbers.push(_number);
    }

    function updateArrayNum(uint256 index, uint256 _number) public {
        require(index < numbers.length, "Index out of bounds");
        numbers[index] = _number;
    }

    function removeNumber(uint256 index) public {
        require(index < numbers.length, "Index out of bounds");

        for (uint256 i = index; i < numbers.length - 1; i++) {
            numbers[i] = numbers[i + 1];
        }

        numbers.pop();
    }

    function resetNumber(uint256 index) public {
        require(index < numbers.length, "Index out of bounds");
        delete numbers[index];
    }

    // struct

    struct Person {
        string name;
        uint256 age;
        address addr;
        address[] friends;
    }

    Person public person;

    function addPerson(string memory _name, uint256 _age, address _addr, address[] memory _friends) external {
        person = Person(_name, _age, _addr, _friends);
    }

    Person[] public persons;

    function addPersons(string memory _name, uint256 _age, address _addr, address[] memory _friends) external {
        persons.push(Person({
            name: _name,
            age: _age,
            addr: _addr,
            friends: _friends
        }));
    }

    // mapping
    // mapping(キーの型 => 値の型) public 名前;
    mapping(address => uint256) public balances;

    function setBalance(uint256 _amount) public {
        balances[msg.sender] = _amount;
    }

    function getBalances(address _account) public view returns (uint256) {
        return balances[_account];
    }

    mapping(uint256 => mapping(address => uint256)) public tokenBalances;

    // event

    event BalanceUpdated(address indexed user, uint256 oldBalance, uint256 newBalance);

    mapping(address => uint256) public eventBalances;

    function updateBalance(uint256 newBalance) public {
        uint256 oldBalance = eventBalances[msg.sender];
        eventBalances[msg.sender] = newBalance;
        emit BalanceUpdated(msg.sender, oldBalance, newBalance);
    }

    // if

    function checkRange(uint256 _num) public pure returns (string memory) {
        if (_num < 10) {
            return "Less than 10";
        } else if (_num >= 10 && _num < 15) {
            return "Between 10 and 14";
        } else if (_num >= 15 && _num <= 20) {
            return "Between 15 and 20";
        } else {
            return "Greater than 20";
        }
    }

    // error

    uint256 errorNum;

    function requireSetNum(uint256 _num) external {
        // require(条件, エラーメッセージ）
        require(_num <= 100, "invalid value");
        errorNum += _num;
    }

    uint256 revertBalance = 101;

    // function withdraw(uint256 _amount) public {
    //     if (_amount > revertBalance) {
    //         revert("Insufficient balance");
    //     }
    //     revertBalance -= _amount;
    // }

    // function revertSetNum() external pure {
    //     revert("error!");
    // }

    // error InsufficientBalance(uint256 available, uint256 required);

    uint256 customErrorBalance = 101;

    // function withdrawCustomError(uint256 _amount) public {
    //     if (_amount > customErrorBalance) {
    //         revert InsufficientBalance(customErrorBalance, _amount);
    //     }
    //     customErrorBalance -= _amount;
    // }

    // function withdrawCustomErrorRequire(uint256 _amount) public {
    //     require(
    //         _amount <= customErrorBalance,
    //         InsufficientBalance(customErrorBalance, _amount)
    //     );
    //     customErrorBalance -= _amount;
    // }

    // modifier

    address contractOwner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    address admin;

    modifier onlyAdmin(address to) {
        require(to == admin, "Not admin");
        _;
    }

    function sendETH(address to) public onlyAdmin(to) payable {
        (bool success, ) = to.call{value: msg.value}("");
        require(success, "Transfer failed");
    }

    uint256 constant _NOT_ENTERED = 1;
    uint256 constant _ENTERED = 2;

    uint256 _status = _NOT_ENTERED;

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // ステータスを変更
        _status = _ENTERED;

        // 関数を実行
        _;

        // ステータスをリセット
        _status = _NOT_ENTERED;
    }

    mapping(address => uint256) public reentrantBalances;

    function withdraw(uint256 amount) external nonReentrant {
        require(reentrantBalances[msg.sender] >= amount, "Insufficient balance");
        reentrantBalances[msg.sender] -= amount;

        // ETHを送信
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }

    // for

    // uint256[] nums;

    // function findNumber(uint256 _target) public view returns (bool, uint256) {
    //     // for (初期値; 条件; 値の増減)
    //     for (uint256 i = 0; i < numbers.length; i++) {
    //         if (numbers[i] == _target) {
    //             return (true, i);
    //         }
    //     }
    //     return (false, 0);
    // }

    uint256[] nums = [1, 0, 3, 0, 5];

    function skipZeroes() public view returns (uint256) {
        uint256 sum = 0;

        for (uint256 i = 0; i < nums.length; i++) {
            if (nums[i] == 0) {
                continue;
            }
            sum += nums[i];
        }

        return sum;
    }

    // while

    function addNumbers(uint256 _num) public {
        uint256 counter = 0; // 初期化

        while (counter < _num) {
            numbers.push(counter); // 配列に値を追加
            counter++; // カウンタをインクリメント
        }
    }

    // memory / calldata

    string contractName;

    // function setName(string memory _name) external {
    //     contractName = _name;
    // }

    function setName(string calldata _name) external {
        contractName = _name;
    }

    // abi.encodePacked

    function encodePack(string calldata name, uint256 age, address addr) external pure returns(string memory) {
        return string(
            abi.encodePacked(
                "User: ",
                name,
                "Age: ",
                age,
                "Address: ",
                addr
            )
        );
    }

    function concat(string calldata name, string calldata age, string calldata addr) external pure returns(string memory) {
        return string.concat(name, age, addr);
    }

    modifier onlyOperator() {
        require(hasRole(OPERATOR_ROLE, msg.sender), "Not operator");
        _;
    }

    function mint(
        uint256 amount
    ) public override payable onlyOperator returns (uint256[] memory tokenIds) {
        require(block.timestamp >= launch, "Not launched yet");
        if (supply + amount > MAX_SUPPLY) revert MaxSupplyReached();
        uint64 price = calculateMintPrice();
        if (msg.value < price * amount) revert InsufficientFunds();

        tokenIds = new uint256[](amount);
        for (uint256 i = 0; i < amount; i++) {
            _mint(msg.sender, supply + 1);
            tokenIds[i] = supply + 1;
            supply++;
        }
    }

    function calculateMintPrice() public view returns (uint64) {
        return isDiscount ? mintPrice / 2 : mintPrice;
    }

    function bulkBurn(uint256[] memory tokenIds) public {
        uint256 length = tokenIds.length;
        while (length > 0) {
            _burn(tokenIds[length - 1]);
            length--;
        }
    }

    function calculateDecimals(
        uint256 decimals,
        uint256 value1,
        uint256 value2
    ) public pure override returns (uint256) {
        uint256 value = (value1 * (10 ** decimals)) / value2;
        return value;
    }

    // library

    using MathLibrary for uint256;

}

pragma solidity 0.8.27;

library MathLibrary {

    function add(uint256 a, uint256 b) external pure returns (uint256) {
        return a + b;
    }

    function multiply(uint256 a, uint256 b) external pure returns (uint256) {
        return a * b;
    }
}

// import "./MathLibrary.sol";  // MathLibraryをインポート。今回は同じファイル内に定義しているため不要。

contract MathContract {
    using MathLibrary for uint256;

    function addNumbers(uint256 a, uint256 b) public pure returns(uint256 result) {
        result = a.add(b);
    }

    function multiplyNumbers(uint256 a, uint256 b) public pure returns(uint256 result) {
        result = a.multiply(b);
    }
}

pragma solidity 0.8.27;

library MathLibraryV2 {

    // 定数の定義
    uint256 constant MULTIPLIER = 10;

    // 構造体の定義
    struct Result {
        uint256 value;
        bool success;
    }

    // エラー定義
    error DivisionByZero();

    function multiplyByConstant(uint256 a) external pure returns (uint256) {
        return a * MULTIPLIER;
    }

    function getResult(uint256 a, uint256 b) external pure returns (Result memory) {
        uint256 sum = a + b;
        return Result(sum, sum > 0);  // 0 より大きければ成功
    }

    function divide(uint256 a, uint256 b) external pure returns (uint256) {
        if (b == 0) {
            revert DivisionByZero();  // b が 0 の場合エラー
        }
        return a / b;
    }
}

type Price is uint256; // Price 型を定義（uint256）

contract PriceContract {
    Price public price;

    // function failSetPrice(uint256 _price) public {
    //     price = _price;
    // }

    function setPrice(uint256 _price) public {
        price = Price.wrap(_price);
    }

    function doublePrice(Price _price) public pure returns (Price) {
        uint256 doubledValue = Price.unwrap(_price) * 2;
        return Price.wrap(doubledValue);
    }

    function getPrice() public view returns (uint256) {
        return Price.unwrap(price);
    }
}


pragma solidity 0.8.27;

abstract contract Role {
    mapping(address => bool) private admins;

    // コンストラクタでデプロイしたアドレスを管理者に設定
    constructor() {
        admins[msg.sender] = true;
    }

    // 管理者のみが実行可能な修飾子
    modifier onlyAdmin() {
        require(admins[msg.sender], "Not an admin");
        _;
    }

    // 管理者を追加する関数
    function addAdmin(address newAdmin) public onlyAdmin {
        admins[newAdmin] = true;
    }

    // 管理者かどうかを確認する関数
    function isAdmin(address user) public view returns (bool) {
        return admins[user];
    }

    // 抽象関数（未実装）
    function executeTask(string memory taskName) public virtual;
}

contract CustomTaskManager is Role {
    event TaskExecuted(address indexed admin, string taskName);

    function executeTask(string memory taskName) public override onlyAdmin {
        // カスタムタスクの実行ロジック
        emit TaskExecuted(msg.sender, taskName);
    }
}

pragma solidity 0.8.27;

contract Caller {
    function callFunction(address payable _to) public payable {
        (bool success, bytes memory data) = _to.call{value: msg.value, gas: 100000}(
            abi.encodeWithSignature("someFunction(uint256)", 123)
        );
        require(success, "Call failed");
    }
}

pragma solidity 0.8.27;

contract Logic {
    uint public x;

    function setX(uint _x) public {
        x = _x;
    }
}

contract Proxy {
    uint public x;

    function executeDelegatecall(address _logic, uint256 _x) public {
        (bool success, ) = _logic.delegatecall(
            abi.encodeWithSignature("setX(uint256)", _x)
        );
        require(success, "Delegatecall failed");
    }
}
