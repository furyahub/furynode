from typing import Tuple
import pytest

import furytool_path
from furytool import eth, test_utils, furynet, cosmos
from furytool.inflate_tokens import InflateTokens
from furytool.common import *
from furytool.test_utils import EnvCtx

def test_pause_unpause_no_error(ctx: EnvCtx):
    res = ctx.furynode.pause_peggy_bridge(ctx.furynet_ethbridge_admin_account)
    assert res[0]['code'] == 0
    res = ctx.furynode.unpause_peggy_bridge(ctx.furynet_ethbridge_admin_account)
    assert res[0]['code'] == 0

# We assert a tx is successful before pausing because we test the pause
# functionality by 1. An error response and 2. Balance unchanged within timeout.
# We want to make sure #2 is not a false positive due to lock function not
# working in the first place
def test_pause_lock_valid(ctx: EnvCtx):
    # Test a working flow:
    fund_amount_fury = 10 * test_utils.furynode_funds_for_transfer_peggy1
    fund_amount_eth = 1 * eth.ETH

    test_fury_account = ctx.create_furynet_addr(fund_amounts=[[fund_amount_fury, "fury"]])
    ctx.tx_bridge_bank_lock_eth(ctx.eth_faucet, test_fury_account, fund_amount_eth)
    ctx.eth.advance_blocks()
    # Setup is complete, test account has fury AND eth

    test_eth_destination_account = ctx.create_and_fund_eth_account()

    send_amount = 1
    balance_diff, erc_diff = send_test_account(ctx, test_fury_account, test_eth_destination_account, send_amount, erc20_token_addr=ctx.get_bridge_token_sc().address)
    # TODO: fury_tx_fee vs get from envctx vs more lenient assertion
    assert balance_diff.get(furynet.FURY, 0) == (-1 * (send_amount + furynet.fury_tx_fee_in_fury )), "Gas fee and sent amount should be deducted from sender fury acct"
    assert erc_diff == send_amount, "Eth destination should receive fury token"

    res = ctx.furynode.pause_peggy_bridge(ctx.furynet_ethbridge_admin_account)
    assert res[0]['code'] == 0

    balance_diff, erc_diff = send_test_account(ctx, test_fury_account, test_eth_destination_account, send_amount, erc20_token_addr=ctx.get_bridge_token_sc().address)
    assert balance_diff.get(furynet.FURY, 0) == (-1 * furynet.fury_tx_fee_in_fury), "Only gas fee should be deducted for attempted tx"
    assert erc_diff == 0, "Eth destination should not receive fury token"

    res = ctx.furynode.unpause_peggy_bridge(ctx.furynet_ethbridge_admin_account)
    assert res[0]['code'] == 0
    # # Submit lock
    # # Assert tx go through, balance updated correctly.
    send_amount = 15
    balance_diff, erc_diff = send_test_account(ctx, test_fury_account, test_eth_destination_account, send_amount, erc20_token_addr=ctx.get_bridge_token_sc().address)
    # TODO: fury_tx_fee vs get from envctx vs more lenient assertion
    assert balance_diff.get(furynet.FURY, 0) == (-1 * (send_amount + furynet.fury_tx_fee_in_fury )), "Gas fee and sent amount should be deducted from sender fury acct"
    assert erc_diff == send_amount, "Eth destination should receive fury token"

# Burn CETH
def test_pause_burn_valid(ctx: EnvCtx):
    fund_amount_fury = 10 * test_utils.furynode_funds_for_transfer_peggy1
    fund_amount_eth = 1 * eth.ETH

    test_fury_account = ctx.create_furynet_addr(fund_amounts=[[fund_amount_fury, "fury"]])
    fury_account_balance_before = ctx.get_furynet_balance(test_fury_account)
    ctx.tx_bridge_bank_lock_eth(ctx.eth_faucet, test_fury_account, fund_amount_eth)
    ctx.eth.advance_blocks(100)
    # Setup is complete, test account has fury AND eth
    ctx.furynode.wait_for_balance_change(test_fury_account, fury_account_balance_before)
    test_eth_destination_account = ctx.create_and_fund_eth_account()

    send_amount = 1
    balance_diff, erc_diff = send_test_account(ctx, test_fury_account, test_eth_destination_account, send_amount, denom=furynet.CETH, erc20_token_addr=None)
    # TODO: fury_tx_fee vs get from envctx vs more lenient assertion
    gas_cost = 160000000000 * 393000 # Taken from peggy1
    assert balance_diff.get(furynet.FURY, 0) == (-1 * furynet.fury_tx_fee_in_fury), "Gas fee should be deducted from sender fury acct"
    assert balance_diff.get(furynet.CETH, 0) == (-1 * (send_amount + gas_cost)), "Sent amount should be deducted from sender fury acct ceth balance"
    assert erc_diff == send_amount, "Eth destination should receive fury token"

    res = ctx.furynode.pause_peggy_bridge(ctx.furynet_ethbridge_admin_account)
    assert res[0]['code'] == 0

    send_amount = 1
    balance_diff, erc_diff = send_test_account(ctx, test_fury_account, test_eth_destination_account, send_amount, denom=furynet.CETH, erc20_token_addr=None)
    assert balance_diff.get(furynet.FURY, 0) == (-1 * furynet.fury_tx_fee_in_fury), "Only gas fee should be deducted for attempted tx"
    assert balance_diff.get(furynet.CETH, 0) == 0, "Eth amount should'nt be deducted, no tx to evm"
    assert erc_diff == 0, "Eth destination should not receive fury token"


    res = ctx.furynode.unpause_peggy_bridge(ctx.furynet_ethbridge_admin_account)
    assert res[0]['code'] == 0

    send_amount = 15
    balance_diff, erc_diff = send_test_account(ctx, test_fury_account, test_eth_destination_account, send_amount, denom=furynet.CETH, erc20_token_addr=None)
    # TODO: fury_tx_fee vs get from envctx vs more lenient assertion
    gas_cost = 160000000000 * 393000 # Taken from peggy1
    assert balance_diff.get(furynet.FURY, 0) == (-1 * furynet.fury_tx_fee_in_fury), "Gas fee should be deducted from sender fury acct"
    assert balance_diff.get(furynet.CETH, 0) == (-1 * (send_amount + gas_cost)), "Sent amount should be deducted from sender fury acct ceth balance"
    assert erc_diff == send_amount, "Eth destination should receive fury token"

# This is a temporary helper method. It will eventually be incorporated into furytool
def send_test_account(ctx: EnvCtx, test_fury_account, test_eth_destination_account, send_amount, denom=furynet.FURY, erc20_token_addr: str=None) -> Tuple[cosmos.Balance, int]:
    fury_balance_before = ctx.get_furynet_balance(test_fury_account)
    if erc20_token_addr is not None:
        eth_balance_before = ctx.get_erc20_token_balance(erc20_token_addr, test_eth_destination_account)
    else:
        eth_balance_before = ctx.eth.get_eth_balance(test_eth_destination_account)

    ctx.furynode_client.send_from_furynet_to_ethereum(test_fury_account, test_eth_destination_account, send_amount, denom)

    fury_balance_after = ctx.furynode.wait_for_balance_change(test_fury_account, fury_balance_before)
    try:
        eth_balance_after = ctx.wait_for_eth_balance_change(test_eth_destination_account, eth_balance_before, token_addr=erc20_token_addr, timeout=30)
    except Exception as e:
        # wait_for_eth_balance_change raises exception only if timedout, implying old_balance == new_balance
        eth_balance_after = eth_balance_before

    balance_diff = furynet.balance_delta(fury_balance_before, fury_balance_after)
    return balance_diff, (eth_balance_after - eth_balance_before)