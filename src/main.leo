program devrel_cedric_testtoken.aleo {
    mapping account: address => extra_detail;

    record token {
        owner: address,
        amount: u64,
    }

    struct extra_detail {
        amount: u64,
        last_update: u32,
    }

    async transition mint_public(public receiver: address, public amount: u64) -> Future {
        return finalize_mint_public(receiver, amount);
    }

    async function finalize_mint_public(public receiver: address, public amount: u64) {
        let default_detail: extra_detail = extra_detail {
            amount: 0u64,
            last_update: 0u32,
        };

        let current_detail: extra_detail = Mapping::get_or_use(account, receiver, default_detail);

        let detail: extra_detail = extra_detail {
            amount: current_detail.amount + amount,
            last_update: block.height
        };

        Mapping::set(account, receiver, detail);
    }

    transition mint_private(receiver: address, amount: u64) -> token {
        return token {
            owner: receiver,
            amount: amount,
        };
    }

    async transition transfer_public(public receiver: address, public amount: u64) -> Future {
        return finalize_transfer_public(self.caller, receiver, amount);
    }

    async function finalize_transfer_public(public sender: address, public receiver: address, public amount: u64) {
        let default_detail: extra_detail = extra_detail {
            amount: 0u64,
            last_update: 0u32,
        };
        let sender_detail: extra_detail = Mapping::get_or_use(account, sender, default_detail);
        let updated_sender_detail: extra_detail = extra_detail {
            amount: sender_detail.amount - amount,
            last_update: block.height
        };
        Mapping::set(account, sender, updated_sender_detail);
        let receiver_detail: extra_detail = Mapping::get_or_use(account, sender, default_detail);
        
        let updated_receiver_detail: extra_detail = extra_detail {
            amount: sender_detail.amount - amount,
            last_update: block.height
        };

        let receiver_amount: extra_detail = Mapping::get_or_use(account, receiver, default_detail);
        
        Mapping::set(account, receiver, updated_receiver_detail);
    }

}