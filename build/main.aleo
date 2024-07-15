program devrel_cedric_testtoken.aleo;

record token:
    owner as address.private;
    amount as u64.private;

struct extra_detail:
    amount as u64;
    last_update as u32;


mapping account:
	key as address.public;
	value as extra_detail.public;


function mint_public:
    input r0 as address.public;
    input r1 as u64.public;
    async mint_public r0 r1 into r2;
    output r2 as devrel_cedric_testtoken.aleo/mint_public.future;

finalize mint_public:
    input r0 as address.public;
    input r1 as u64.public;
    cast 0u64 0u32 into r2 as extra_detail;
    get.or_use account[r0] r2 into r3;
    add r3.amount r1 into r4;
    cast r4 block.height into r5 as extra_detail;
    set r5 into account[r0];



function mint_private:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 r1 into r2 as token.record;
    output r2 as token.record;



function transfer_public:
    input r0 as address.public;
    input r1 as u64.public;
    async transfer_public self.caller r0 r1 into r2;
    output r2 as devrel_cedric_testtoken.aleo/transfer_public.future;

finalize transfer_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    cast 0u64 0u32 into r3 as extra_detail;
    get.or_use account[r0] r3 into r4;
    sub r4.amount r2 into r5;
    cast r5 block.height into r6 as extra_detail;
    set r6 into account[r0];
    get.or_use account[r0] r3 into r7;
    sub r4.amount r2 into r8;
    cast r8 block.height into r9 as extra_detail;
    get.or_use account[r1] r3 into r10;
    set r9 into account[r1];

