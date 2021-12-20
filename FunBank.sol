

contract Bank {

    mapping(address=>uint) account_balances;

    function get_balance() external view virtual returns(uint) {
        return account_balances[msg.sender];
    }

    function transfer(address recipient, uint amount) virtual  public {

        // require(account_balances[msg.sender]>=amount, "NSF");
        
        account_balances[msg.sender] -= amount;
        account_balances[recipient] += amount;

    }

    function withdrawl(uint amount) virtual public {

        account_balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    
    }

    receive () external payable {
        account_balances[msg.sender] += msg.value;
    } 


}


contract FunBank is Bank{

    uint number_of_accounts;

    // mapping(address=>uint) override account_balances;
    mapping(address=>uint) account_info_map;    
    
    struct BankAccountRecord {
        uint account_number;
        string fullName;
        string profession;
        string dateOfBrith;
        address wallet_addr;
        string customer_addr;
    }

    BankAccountRecord[] bankAccountRecords;

    function register_account(
            string memory fullName_,
            string memory profession_,
            string memory dateOfBrith_,
            string memory customer_addr_) external {

        require(account_info_map[msg.sender] == 0, "Account already registered");

        bankAccountRecords.push(
            BankAccountRecord({
                account_number:++number_of_accounts,
                fullName:fullName_,
                profession:profession_,
                dateOfBrith:dateOfBrith_,
                wallet_addr:msg.sender,
                customer_addr:customer_addr_
            }));                         

        account_info_map[msg.sender] = number_of_accounts;
    }


    // Todo:
    // register account method
    // onlyRegistered Modifier  [Done!]
    
    modifier onlyRegistered() {
        require(account_info_map[msg.sender] > 0 , "User not Register, please register to use this method.");
        _;
    }

    function get_balance() external view onlyRegistered override returns(uint) {
        return account_balances[msg.sender];
    }

    function transfer(address recipient, uint amount) public override onlyRegistered {

        // require(account_balances[msg.sender]>=amount, "NSF");
        
        account_balances[msg.sender] -= amount;
        account_balances[recipient] += amount;

    }

    function withdrawl(uint amount) public override onlyRegistered {

        account_balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    
    }

}

// Paying loans
// getting loans
// getting approved for a loan:
