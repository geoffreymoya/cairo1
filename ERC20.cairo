#[contract]
mod ERC20 {

    use starknet::get_caller_address;

    struct Storage {
        name_: felt,
        symbol_: felt,
        decimals_: u8,
        total_supply: u256,
        balances: LegacyMap::<felt, u256>,
        allowances: LegacyMap::<(felt, felt), u256>,
    }

    #[event]
    fn Transfer(from_: felt, to: felt, value: u256) {}

    #[event]
    fn Approval(owner_: felt, spender_: felt, value: u256) {}

    
     #[constructor]
    fn constructor(_name:felt,_symbol:felt,_decimals:u8,_total_supply: u256, recipient: felt) {
        name_::write(_name)
        symbol_::write(_symbol)
        decimals_::write(_decimals)
        total_supply::write(_total_supply)
        balances::write(recipient,_total_supply)

    }

    
    #[view]
    fn name() -> felt {
        name_::read()
    }

    #[view]
    fn symbol() -> felt {
        symbol_::read()
    }

    #[view]
    fn decimals() -> u8 {
        decimals_::read()
    }

    #[view]
    fn totalSupply() -> u256 {
        total_supply::read()
    }

    #[view]
    fn balanceOf(account: felt) -> u256 {
        balances::read(account)
    }

    #[view]
    fn allowance(owner: felt, spender: felt) -> u256 {
        allowances::read((owner,spender))
    }



    #[external]
    fn transfer(recipient: felt, amount: u256) {
        let sender = get_caller_address();
        _transfer(sender,recipient,amount);
    }

    #[external]
    fn approve(spender: felt, amount: u256) {
        let owner = get_caller_address();
        allowances::write((owner,spender),amount);
        Approval(owner,spender,amount);

    }

    #[external]
    fn transferFrom(sender: felt, recipient: felt, amount: u256) {
        let spender = get_caller_address();
        assert(allowances::read((sender,spender)) >= amount,'Insufficient allowance');
        allowances::write((sender,spender),allowances::read((sender,spender)) - amount);
        _transfer(sender,recipient,amount);
    }

    fn _transfer (sender: felt, recipient: felt, amount: u256) {
        assert(balances::read(sender) >= amount , 'Insufficient funds');
        balances::write(sender,balances::read(sender)-amount);
        balances::write(recipient,balances::read(recipient)+amount);
        Transfer(sender, recipient, amount);
    }


}