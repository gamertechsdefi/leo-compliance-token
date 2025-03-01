import credits.aleo;
import token_registry.aleo;
program compliancetoken.aleo;

struct TokenMetadata:
    token_id as field;
    name as u128;
    symbol as u128;
    decimals as u8;
    supply as u128;
    max_supply as u128;
    admin as address;
    external_authorization_required as boolean;
    external_authorization_party as address;

struct TokenOwner:
    account as address;
    token_id as field;

record SpendLimit:
    owner as address.private;
    amount_spent as u128.private;
    epoch_spent as u32.private;

mapping has_minted:
    key as u8.public;
    value as boolean.public;

mapping has_spend_limit:
    key as field.public;
    value as boolean.public;

mapping whitelist_enabled:
    key as u8.public;
    value as boolean.public;

mapping whitelist:
    key as address.public;
    value as boolean.public;

mapping blacklist:
    key as address.public;
    value as boolean.public;

function transfer_private:
    input r0 as token_registry.aleo/Token.record;
    input r1 as SpendLimit.record;
    input r2 as u128.private;
    input r3 as address.private;
    input r4 as u32.public;
    lt r1.epoch_spent r4 into r5;
    add r2 r1.amount_spent into r6;
    ternary r5 r2 r6 into r7;
    lte r7 10_000_000_000u128 into r8;
    assert.eq r8 true;
    cast r1.owner r7 r4 into r9 as SpendLimit.record;
    call token_registry.aleo/prehook_private r0 r2 4294967295u32 into r10 r11 r12;
    call token_registry.aleo/transfer_private r3 r2 r11 into r13 r14 r15;
    async transfer_private r12 r15 r4 r1.owner r3 into r16;
    output r9 as SpendLimit.record;
    output r10 as token_registry.aleo/Token.record;
    output r13 as token_registry.aleo/Token.record;
    output r14 as token_registry.aleo/Token.record;
    output r16 as compliancetoken.aleo/transfer_private.future;

finalize transfer_private:
    input r0 as token_registry.aleo/prehook_private.future;
    input r1 as token_registry.aleo/transfer_private.future;
    input r2 as u32.public;
    input r3 as address.public;
    input r4 as address.public;
    await r0;
    await r1;
    rem block.height 28_800u32 into r5;
    assert.eq r2 r5;
    contains blacklist[r3] into r6;
    get blacklist[r3] into r7;
    and r6 r7 into r8;
    contains blacklist[r4] into r9;
    get blacklist[r4] into r10;
    and r9 r10 into r11;
    not r8 into r12;
    assert.eq r12 true;
    not r11 into r13;
    assert.eq r13 true;
    contains whitelist_enabled[0u8] into r14;
    get whitelist_enabled[0u8] into r15;
    and r14 r15 into r16;
    branch.eq r16 false to end_then_0_0;
    contains whitelist[r3] into r17;
    get whitelist[r3] into r18;
    and r17 r18 into r19;
    contains whitelist[r4] into r20;
    get whitelist[r4] into r21;
    and r20 r21 into r22;
    assert.eq r19 true;
    assert.eq r22 true;
    branch.eq true true to end_otherwise_0_1;
    position end_then_0_0;
    position end_otherwise_0_1;

function initialize:
    assert.eq self.caller aleo157jceqdlj2hesq7dvxq53nzaqcq3pxjc3ypde98jy8tmks0xpuyq2l9j83;
    call token_registry.aleo/register_token 71619063553950105623552field 71619063553950105623552u128 71619063553950105623552u128 6u8 10_000_000_000_000_000u128 true compliancetoken.aleo into r0;
    async initialize r0 into r1;
    output r1 as compliancetoken.aleo/initialize.future;

finalize initialize:
    input r0 as token_registry.aleo/register_token.future;
    await r0;

function mint_private:
    assert.eq self.caller aleo157jceqdlj2hesq7dvxq53nzaqcq3pxjc3ypde98jy8tmks0xpuyq2l9j83;
    call token_registry.aleo/mint_private 71619063553950105623552field aleo157jceqdlj2hesq7dvxq53nzaqcq3pxjc3ypde98jy8tmks0xpuyq2l9j83 1_000_000_000_000_000u128 true 4294967295u32 into r0 r1;
    async mint_private r1 into r2;
    output r0 as token_registry.aleo/Token.record;
    output r2 as compliancetoken.aleo/mint_private.future;

finalize mint_private:
    input r0 as token_registry.aleo/mint_private.future;
    await r0;
    contains has_minted[0u8] into r1;
    not r1 into r2;
    assert.eq r2 true;
    set true into has_minted[0u8];
    set false into whitelist_enabled[0u8];

function toggle_whitelist:
    input r0 as boolean.private;
    assert.eq self.caller aleo157jceqdlj2hesq7dvxq53nzaqcq3pxjc3ypde98jy8tmks0xpuyq2l9j83;
    async toggle_whitelist r0 into r1;
    output r1 as compliancetoken.aleo/toggle_whitelist.future;

finalize toggle_whitelist:
    input r0 as boolean.public;
    set r0 into whitelist_enabled[0u8];

function add_to_whitelist:
    input r0 as address.private;
    assert.eq self.caller aleo157jceqdlj2hesq7dvxq53nzaqcq3pxjc3ypde98jy8tmks0xpuyq2l9j83;
    async add_to_whitelist r0 into r1;
    output r1 as compliancetoken.aleo/add_to_whitelist.future;

finalize add_to_whitelist:
    input r0 as address.public;
    set true into whitelist[r0];

function remove_from_whitelist:
    input r0 as address.private;
    assert.eq self.caller aleo157jceqdlj2hesq7dvxq53nzaqcq3pxjc3ypde98jy8tmks0xpuyq2l9j83;
    async remove_from_whitelist r0 into r1;
    output r1 as compliancetoken.aleo/remove_from_whitelist.future;

finalize remove_from_whitelist:
    input r0 as address.public;
    set false into whitelist[r0];

function add_to_blacklist:
    input r0 as address.private;
    assert.eq self.caller aleo157jceqdlj2hesq7dvxq53nzaqcq3pxjc3ypde98jy8tmks0xpuyq2l9j83;
    async add_to_blacklist r0 into r1;
    output r1 as compliancetoken.aleo/add_to_blacklist.future;

finalize add_to_blacklist:
    input r0 as address.public;
    set true into blacklist[r0];

function remove_from_blacklist:
    input r0 as address.private;
    assert.eq self.caller aleo157jceqdlj2hesq7dvxq53nzaqcq3pxjc3ypde98jy8tmks0xpuyq2l9j83;
    async remove_from_blacklist r0 into r1;
    output r1 as compliancetoken.aleo/remove_from_blacklist.future;

finalize remove_from_blacklist:
    input r0 as address.public;
    set false into blacklist[r0];

function issue_limit:
    input r0 as address.private;
    assert.eq self.caller aleo157jceqdlj2hesq7dvxq53nzaqcq3pxjc3ypde98jy8tmks0xpuyq2l9j83;
    cast r0 0u128 0u32 into r1 as SpendLimit.record;
    output r1 as SpendLimit.record;
