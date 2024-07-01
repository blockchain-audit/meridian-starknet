use starknet::ContractAddress;

#[starknet::contract]
mod LQTYToken {
    #[storge]
    struct Storage {
        _NAME: felt252,
        _SYMBOL: felt252,
        _VERSION: felt252,
        _DECIMALS: felt252,
        _balances: LegacyMap::<contractAddress, felt252>,
        _allowance: LegacyMap::<(ContractAddress, ContractAddress), felt252>,
        _totalSupply: felt252,
        _PERMIT_TYPEHASH: felt252,
        _TYPE_HASH: felt252,
        _CACHED_DOMAIN_SEPARATOR: felt252,
        _CACHED_CHAIN_ID: felt252,
        _HASHED_NAME: felt252,
        _HASHED_VERSION: felt252,
        _nonces: Legacy<ContractAddress, felt252>,
        ONE_YEAR_IN_SECONDS: felt252,
        _1_MILLION: felt252,
        deploymentStartTime: felt252,
        multisigAddress: ContractAddress,
        communityIssuanceAddress: ContractAddress,
        lqtyStakingAddress: ContractAddress,
        lpRewardsEntitlement: ContractAddress,
        lockupContractFactory: ILockupContractFactory,
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CommunityIssuanceAddressSet: CommunityIssuanceAddressSet,
        LQTYStakingAddressSet: LQTYStakingAddressSet,
        LockupContractFactoryAddressSet: LockupContractFactoryAddressSet,
    }

    #[derive(Drop, starknet::Event)]
    struct CommunityIssuanceAddressSet {
        _communityIssuanceAddress: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct LQTYStakingAddressSet {
        _lqtyStakingAddress: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct LockupContractFactoryAddressSet {
        _lockupContractFactoryAddress: ContractAddress,
    }

    #[constructor]
    fn constructor(
        ref self: TContractState,
        _communityIssuanceAddress: ContractAddress,
        _lqtyStakingAddress: ContractAddress,
        _lockupFactoryAddress: ContractAddress,
        _bountyAddress: ContractAddress,
        _lpRewardsAddress: ContractAddress,
        _multisigAddress: ContractAddress
    ) {
        // checkContract(_communityIssuanceAddress);
        // checkContract(_lqtyStakingAddress);
        // checkContract(_lockupFactoryAddress);
        self._NAME.write("LQTY");
        self._SYMBOL.write("LQTY");
        self._VERSION.write("1");
        self._DECIMALS.write(18);
        self
            ._PERMIT_TYPEHASH
            .write(0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9);
        self._TYPE_HASH(0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f);
        self.ONE_YEAR_IN_SECONDS.write(31536000); // 60 * 60 * 24 * 365
        self._1_MILLION.write(1 * *24); // 1e6 * 1e18 = 1e24
        self.multisigAddress.write(_multisigAddress);
        // deploymentStartTime = block.timestamp;

        self.communityIssuanceAddress.write(_communityIssuanceAddress);
        self.lqtyStakingAddress.write(_lqtyStakingAddress);
        self.lockupContractFactory.write(ILockupContractFactory(_lockupFactoryAddress));
        let hashName: felt252 = hash(self._NAME.read());
        let hashedVersion: felt252 = hash(self._VERSION.read());

        self._HASHED_NAME.write(hashName);
        self._HASHED_VERSION.write(hashedVersion);
        // _CACHED_CHAIN_ID = _chainID();
        // _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(_TYPE_HASH, hashedName, hashedVersion);

        let bountyEntitlement: felt252 = self._1_MILLION.read() * 2;
        // _mint(_bountyAddress ,bountyEntitlement );

        let depositorsAndFrontEndsEntitlement: felt252 = _1_MILLION.read()
            * 32; // Allocate 32 million to the algorithmic issuance schedule
        // _mint(_communityIssuanceAddress, depositorsAndFrontEndsEntitlement);

        let _lpRewardsEntitlement: felt252 = _1_MILLION
            * 4
            / 3; // Allocate 1.33 million for LP rewards
        self.lpRewardsEntitlement.write(_lpRewardsEntitlement);
        // _mint(_lpRewardsAddress, _lpRewardsEntitlement);

        // Allocate the remainder to the LQTY Multisig: (100 - 2 - 32 - 1.33) million = 64.66 million
        let multisigEntitlement: felt252 = self._1_MILLION.read() * 100
            - bountyEntitlement
            - depositorsAndFrontEndsEntitlement
            - _lpRewardsEntitlement;
    // _mint(_multisigAddress, multisigEntitlement);

    }

    #[external(v0)]
    impl ILQTYTokenImp of super::ILQTYToken<TContractState> {
        fn totalSupply(self: @TContractState) -> felt252 {
            self._totalSupply.read();
        }
        fn balanceOf(self: @TContractState, account: contractAddress) -> felt252 {
            self.balanceOf.read(acount);
        }

        fn getDeploymentStartTime(self: @TContractState) -> felt252 {
            self.deploymentStartTime.read();
        }

        fn getLpRewardsEntitlement(self: @TContractAddress) -> felt252 {
            self.lpRewardsEntitlement.read();
        }

        fn transfer(self: @TContractState, recipient: ContractAddress, amount: felt252) -> bool {
            // if (_callerIsMultisig() && _isFirstYear()) {
            //     _requireRecipientIsRegisteredLC(recipient);
            // }

            // _requireValidRecipient(recipient);

            // // Otherwise, standard transfer functionality
            // _transfer(msg.sender, recipient, amount);
            true;
        }

        fn allowance(
            self: @ContractState, owner: ContractAddress, spender: ContractAddress
        ) -> felt252 {
            self._allowances.read((owner, spender));
        }

        fn approve(self: @TContractState, spender: ContractAddress, amount: felt252) -> bool {// if (_isFirstYear()) _requireCallerIsNotMultisig();

        // _approve(msg.sender, spender, amount);
        // return true; 
        }

        fn transferFrom(
            self: @contractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: felt252
        ) -> bool {
            // if (_isFirstYear()) _requireSenderIsNotMultisig(sender);

            // _requireValidRecipient(recipient);

            // _transfer(sender, recipient, amount);
            // _approve(
            //     sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance")
            // );
            return true;
        }

        fn increaseAllowance(
            self: @TContractAddress, spender: ContractAddress, addedValue: ContractAddress
        ) -> bool {
            // if (_isFirstYear()) _requireCallerIsNotMultisig();

            // _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
            return true;
        }

        fn decreaseAllowance(
            self: @ContractState, spender: ContractAddress, subtractedValue: felt252
        ) -> bool {
            // if (_isFirstYear()) _requireCallerIsNotMultisig();

            // _approve(
            //     msg.sender,
            //     spender,
            //     _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero")
            // );
            return true;
        }

        fn sendToLQTYStaking(self: @ContractState, _sender: ContractAddress, _amount: felt252) {// _requireCallerIsLQTYStaking();
        // if (_isFirstYear()) _requireSenderIsNotMultisig(_sender); // Prevent the multisig from staking LQTY
        // _transfer(_sender, lqtyStakingAddress, _amount);
        }

        // --- EIP 2612 functionality ---

        fn domainSeparator() -> felt252 {// if (_chainID() == _CACHED_CHAIN_ID) {
        //     return _CACHED_DOMAIN_SEPARATOR;
        // } else {
        //     return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
        // }
        }

        fn permit(
            self: @ContractState,
            owner: ContractAddress,
            spender: ContractAddress,
            amount: felt252,
            deadline: felt252,
            v: u8,
            r: felt252,
            s: felt252
        ) {
        // require(deadline >= now, "LQTY: expired deadline");
        // bytes32 digest = keccak256(
        //     abi.encodePacked(
        //         "\x19\x01",
        //         domainSeparator(),
        //         keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner]++, deadline))
        //     )
        // );
        // address recoveredAddress = ecrecover(digest, v, r, s);
        // require(recoveredAddress == owner, "LQTY: invalid signature");
        // _approve(owner, spender, amount);
        }

        fn nonces(self:@ContractState,owner:ContractAddress) -> u256{
            self._nonces.read(owner);
        }

        // --- Internal operations ---

        fn _chainID() -> u256{
            // assembly {
            //     chainID := chainid()
            // }
        }

        fn _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
            return keccak256(abi.encode(typeHash, name, version, _chainID(), address(this)));
        }
    }
}
