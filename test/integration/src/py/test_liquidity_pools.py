import logging
import os
import time
import json
import pytest

import burn_lock_functions
from burn_lock_functions import EthereumToFurynetTransferRequest
import test_utilities
from pytest_utilities import generate_test_account
from test_utilities import get_required_env_var, FurynetcliCredentials, get_optional_env_var, ganache_owner_account, \
    get_shell_output_json, get_shell_output, detect_errors_in_furynd_output, get_transaction_result, amount_in_wei, furynd_binary

smart_contracts_dir = get_required_env_var("SMART_CONTRACTS_DIR")
bridgebank_address = get_required_env_var("BRIDGE_BANK_ADDRESS")
bridgetoken_address = get_required_env_var("BRIDGE_TOKEN_ADDRESS")

#LOCAL UTILITIES
def generate_new_currency(symbol, amount, solidity_json_path, operator_address, ethereum_network):
    logging.info(f"create new currency: "+symbol)
    new_currency = test_utilities.create_new_currency(
        amount,
        symbol,
        token_name=symbol,
        decimals=18,
        smart_contracts_dir=smart_contracts_dir,
        bridgebank_address=bridgebank_address,
        solidity_json_path=solidity_json_path,
        operator_address=operator_address,
        ethereum_network=ethereum_network
    )
    return new_currency

def get_pools(furynd_node):
    node = f"--node {furynd_node}" if furynd_node else ""
    command_line = f"{furynd_binary} q clp pools {node} --output json"
    # returns error when empty
    try:
        json_str = get_shell_output_json(command_line)
        return json_str
    except Exception as e:
        logging.debug(f"get_pools is empty.")

def create_pool(
        transfer_request: EthereumToFurynetTransferRequest,
        credentials: FurynetcliCredentials
):
    logging.debug(f"create_pool")
    yes_entry = f"yes {credentials.keyring_passphrase} | " if credentials.keyring_passphrase else ""
    keyring_backend_entry = f"--keyring-backend {credentials.keyring_backend}" if credentials.keyring_backend else ""
    chain_id_entry = f"--chain-id {transfer_request.chain_id}" if transfer_request.chain_id else ""
    node = f"--node {transfer_request.furynd_node}" if transfer_request.furynd_node else ""
    furynet_fees_entry = f"--fees {transfer_request.furynet_fees}" if transfer_request.furynet_fees else ""
    cmd = " ".join([
        yes_entry,
        f"{furynd_binary} tx clp create-pool",
        f"--from {transfer_request.furynet_address}",
        f"--symbol {transfer_request.furynet_symbol}",
        f"--nativeAmount {transfer_request.amount}",
        f"--externalAmount {transfer_request.amount}",
        keyring_backend_entry,
        chain_id_entry,
        node,
        furynet_fees_entry,
        f"--home {credentials.furynd_homedir} ",
        "-y --output json"
    ])
    return get_shell_output_json(cmd)

def swap_pool(
        transfer_request: EthereumToFurynetTransferRequest,
        sent_symbol, received_symbol,
        credentials: FurynetcliCredentials
):
    logging.debug(f"swap_pool")
    yes_entry = f"yes {credentials.keyring_passphrase} | " if credentials.keyring_passphrase else ""
    keyring_backend_entry = f"--keyring-backend {credentials.keyring_backend}" if credentials.keyring_backend else ""
    chain_id_entry = f"--chain-id {transfer_request.chain_id}" if transfer_request.chain_id else ""
    node = f"--node {transfer_request.furynd_node}" if transfer_request.furynd_node else ""
    furynet_fees_entry = f"--fees {transfer_request.furynet_fees}" if transfer_request.furynet_fees else ""
    cmd = " ".join([
        yes_entry,
        f"{furynd_binary} tx clp swap",
        f"--from {transfer_request.furynet_address}",
        f"--sentSymbol {sent_symbol}",
        f"--receivedSymbol {received_symbol}",
        f"--sentAmount {transfer_request.amount}",
        f"--minReceivingAmount {int(transfer_request.amount * 0.99)}",
        keyring_backend_entry,
        chain_id_entry,
        node,
        furynet_fees_entry,
        f"--home {credentials.furynd_homedir} ",
        "-y --output json"
    ])
    json_str = get_shell_output_json(cmd)
    txn = get_transaction_result(json_str["txhash"], transfer_request.furynd_node, transfer_request.chain_id)
    tx = txn["tx"]
    logging.debug(f"resulting tx: {tx}")
    return txn

def remove_pool_liquidity(
        transfer_request: EthereumToFurynetTransferRequest,
        credentials: FurynetcliCredentials,
        wBasis
):
    logging.debug(f"remove_pool_liquidity")
    yes_entry = f"yes {credentials.keyring_passphrase} | " if credentials.keyring_passphrase else ""
    keyring_backend_entry = f"--keyring-backend {credentials.keyring_backend}" if credentials.keyring_backend else ""
    chain_id_entry = f"--chain-id {transfer_request.chain_id}" if transfer_request.chain_id else ""
    node = f"--node {transfer_request.furynd_node}" if transfer_request.furynd_node else ""
    furynet_fees_entry = f"--fees {transfer_request.furynet_fees}" if transfer_request.furynet_fees else ""
    cmd = " ".join([
        yes_entry,
        f"{furynd_binary} tx clp remove-liquidity",
        f"--from {transfer_request.furynet_address}",
        f"--symbol {transfer_request.furynet_symbol}",
        f"--wBasis {wBasis}",
        f"--asymmetry 0",
        keyring_backend_entry,
        chain_id_entry,
        node,
        furynet_fees_entry,
        f"--home {credentials.furynd_homedir} ",
        "-y --output json"
    ])
    json_str = get_shell_output_json(cmd)
    txn = get_transaction_result(json_str["txhash"], transfer_request.furynd_node, transfer_request.chain_id)
    tx = txn["tx"]
    logging.debug(f"resulting tx: {tx}")
    return txn

def add_pool_liquidity(
        transfer_request: EthereumToFurynetTransferRequest,
        credentials: FurynetcliCredentials
):
    logging.debug(f"add_pool_liquidity")
    yes_entry = f"yes {credentials.keyring_passphrase} | " if credentials.keyring_passphrase else ""
    keyring_backend_entry = f"--keyring-backend {credentials.keyring_backend}" if credentials.keyring_backend else ""
    chain_id_entry = f"--chain-id {transfer_request.chain_id}" if transfer_request.chain_id else ""
    node = f"--node {transfer_request.furynd_node}" if transfer_request.furynd_node else ""
    furynet_fees_entry = f"--fees {transfer_request.furynet_fees}" if transfer_request.furynet_fees else ""
    cmd = " ".join([
        yes_entry,
        f"{furynd_binary} tx clp add-liquidity",
        f"--from {transfer_request.furynet_address}",
        f"--symbol {transfer_request.furynet_symbol}",
        f"--nativeAmount {transfer_request.amount}",
        f"--externalAmount {transfer_request.amount}",
        keyring_backend_entry,
        chain_id_entry,
        node,
        furynet_fees_entry,
        f"--home {credentials.furynd_homedir} ",
        "-y --output json"
    ])
    json_str = get_shell_output_json(cmd)
    txn = get_transaction_result(json_str["txhash"], transfer_request.furynd_node, transfer_request.chain_id)
    tx = txn["tx"]
    logging.debug(f"resulting tx: {tx}")
    return txn

@pytest.mark.skip(reason="not now")
def test_create_pools(
        basic_transfer_request: EthereumToFurynetTransferRequest,
        source_ethereum_address: str,
        fury_source_integrationtest_env_credentials: FurynetcliCredentials,
        fury_source_integrationtest_env_transfer_request: EthereumToFurynetTransferRequest,
        furynet_fees_int
):
    basic_transfer_request.ethereum_address = source_ethereum_address
    basic_transfer_request.check_wait_blocks = True
    target_fury_balance = 10 ** 19
    target_ceth_balance = 10 ** 19
    request, credentials = generate_test_account(
        basic_transfer_request,
        fury_source_integrationtest_env_transfer_request,
        fury_source_integrationtest_env_credentials,
        target_ceth_balance=target_ceth_balance,
        target_fury_balance=target_fury_balance
    )

    furyaddress = request.furynet_address
    # wait for balance
    test_utilities.wait_for_furynet_addr_balance(furyaddress, "fury", target_fury_balance, basic_transfer_request.furynd_node)
    test_utilities.wait_for_furynet_addr_balance(furyaddress, "ceth", target_ceth_balance, basic_transfer_request.furynd_node)

    pools = get_pools(basic_transfer_request.furynd_node)
    change_amount = 10 ** 18
    basic_transfer_request.amount = change_amount
    basic_transfer_request.furynet_symbol = "ceth"
    basic_transfer_request.furynet_address = furyaddress
    current_ceth_balance = target_ceth_balance
    current_fury_balance = target_fury_balance

    # Only works the first time, fails later.  Make this flexible for manual and private net testing for now.
    if pools is None:
        create_pool(basic_transfer_request, credentials)
        get_pools(basic_transfer_request.furynd_node)
        current_ceth_balance = current_ceth_balance - change_amount
        current_fury_balance = current_fury_balance - change_amount - furynet_fees_int
        assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury") == current_fury_balance)
        assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "ceth") == current_ceth_balance)

    # check for failure if we try to create a pool twice
    txn = create_pool(basic_transfer_request, credentials)
    assert(txn["code"] == 14)
    get_pools(basic_transfer_request.furynd_node)
    current_fury_balance = current_fury_balance - furynet_fees_int
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury") == current_fury_balance)
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "ceth") == current_ceth_balance)

# @pytest.mark.skip(reason="not now")
@pytest.mark.usefixtures("operator_private_key")
def test_pools(
        basic_transfer_request: EthereumToFurynetTransferRequest,
        fury_source_integrationtest_env_credentials: FurynetcliCredentials,
        fury_source_integrationtest_env_transfer_request: EthereumToFurynetTransferRequest,
        smart_contracts_dir,
        bridgebank_address,
        solidity_json_path,
        operator_address,
        ethereum_network,
        source_ethereum_address,
        furynet_fees_int
):
    # max symbol length in clp is 71
    new_currency_symbol = "96D7172B711F7F925DFC7579C6CCC3C80B762187215ABD082CDE99F81153DC80"
    target_new_currency_balance = 5 * 10 ** 18
    logging.info(f"create new currency")
    new_currency = test_utilities.create_new_currency(
        1000 * target_new_currency_balance,
        new_currency_symbol,
        token_name=new_currency_symbol,
        decimals=18,
        smart_contracts_dir=smart_contracts_dir,
        bridgebank_address=bridgebank_address,
        solidity_json_path=solidity_json_path,
        operator_address=operator_address,
        ethereum_network=ethereum_network
    )
    furynet_symbol = ("c" + new_currency["newtoken_symbol"]).lower()

    basic_transfer_request.ethereum_address = source_ethereum_address
    basic_transfer_request.check_wait_blocks = True
    target_fury_balance = 5 * 10 ** 18
    target_ceth_balance = 10 ** 18
    request, credentials = generate_test_account(
        basic_transfer_request,
        fury_source_integrationtest_env_transfer_request,
        fury_source_integrationtest_env_credentials,
        target_ceth_balance=target_ceth_balance,
        target_fury_balance=target_fury_balance
    )

    logging.info(f"transfer some of the new currency {new_currency_symbol} to the test furynet address")
    request.ethereum_symbol = new_currency["newtoken_address"]
    request.furynet_symbol = furynet_symbol
    request.amount = target_new_currency_balance
    burn_lock_functions.transfer_ethereum_to_furynet(request)

    furyaddress = request.furynet_address
    # wait for balance
    test_utilities.wait_for_furynet_addr_balance(furyaddress, "fury", target_fury_balance, basic_transfer_request.furynd_node)
    test_utilities.wait_for_furynet_addr_balance(furyaddress, furynet_symbol, target_new_currency_balance, basic_transfer_request.furynd_node)

    request2, credentials2 = generate_test_account(
        basic_transfer_request,
        fury_source_integrationtest_env_transfer_request,
        fury_source_integrationtest_env_credentials,
        target_ceth_balance=target_ceth_balance,
        target_fury_balance=target_fury_balance
    )

    logging.info(f"transfer some of the new currency {new_currency_symbol} to the test furynet address")
    request2.ethereum_symbol = new_currency["newtoken_address"]
    request2.furynet_symbol = furynet_symbol
    request2.amount = target_new_currency_balance
    burn_lock_functions.transfer_ethereum_to_furynet(request2)

    furyaddress2 = request2.furynet_address
    # wait for balance
    test_utilities.wait_for_furynet_addr_balance(furyaddress2, "fury", target_fury_balance, basic_transfer_request.furynd_node)
    test_utilities.wait_for_furynet_addr_balance(furyaddress2, furynet_symbol, target_new_currency_balance, basic_transfer_request.furynd_node)

    pools = get_pools(basic_transfer_request.furynd_node)
    basic_transfer_request.furynet_symbol = furynet_symbol
    basic_transfer_request.furynet_address = furyaddress
    current_coin_balance = target_new_currency_balance
    current_fury_balance = target_fury_balance

    change_amount = 10 ** 19
    basic_transfer_request.amount = change_amount
    logging.info("Fail if amount is greater than user has")
    txn = create_pool(basic_transfer_request, credentials)
    assert(txn["code"] == 12)
    current_fury_balance = current_fury_balance - furynet_fees_int
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury") == current_fury_balance)

    change_amount = 10 ** 17
    basic_transfer_request.amount = change_amount
    logging.info("Fail if amount is less than or equal to minimum")
    txn = create_pool(basic_transfer_request, credentials)
    assert(txn["code"] == 7)
    current_fury_balance = current_fury_balance - furynet_fees_int
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury") == current_fury_balance)

    change_amount = 10 ** 18
    basic_transfer_request.amount = change_amount
    logging.info("Only works the first time, fails later")
    txn = create_pool(basic_transfer_request, credentials2)
    assert(txn.get("code", 0) == 0)
    get_pools(basic_transfer_request.furynd_node)
    current_coin_balance = current_coin_balance - change_amount
    current_fury_balance = current_fury_balance - change_amount - furynet_fees_int
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury") == current_fury_balance)
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, furynet_symbol) == current_coin_balance)

    logging.info("check for failure if we try to create a pool twice")
    txn = create_pool(basic_transfer_request, credentials)
    assert(txn["code"] == 14)
    get_pools(basic_transfer_request.furynd_node)
    current_fury_balance = current_fury_balance - furynet_fees_int
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury") == current_fury_balance)
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, furynet_symbol) == current_coin_balance)

    logging.info("ensure we can add liquidity, money gets transferred")
    txn = add_pool_liquidity(basic_transfer_request, credentials)
    assert(txn.get("code", 0) == 0)
    get_pools(basic_transfer_request.furynd_node)
    current_coin_balance = current_coin_balance - change_amount
    current_fury_balance = current_fury_balance - change_amount - furynet_fees_int
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury") == current_fury_balance)
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, furynet_symbol) == current_coin_balance)

    logging.info("ensure we can remove liquidity, money gets transferred")
    txn = remove_pool_liquidity(basic_transfer_request, credentials, 5000)
    assert(txn.get("code", 0) == 0)
    get_pools(basic_transfer_request.furynd_node)
    current_coin_balance = current_coin_balance + change_amount
    current_fury_balance = current_fury_balance + change_amount - furynet_fees_int

    # check for failure if we try to remove more
    txn = remove_pool_liquidity(basic_transfer_request, credentials, 10000)
    assert(txn["code"] == 26)
    get_pools(basic_transfer_request.furynd_node)
    current_fury_balance = current_fury_balance - furynet_fees_int
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury") == current_fury_balance)
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, furynet_symbol) == current_coin_balance)

    #assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury") == current_fury_balance)
    #assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, furynet_symbol) == current_ceth_balance)
    # no slippage if pool is perfectly balanced.

    # TODO: compute this precisely?
    slip_pct = 0.01
    balance = test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury")
    slip_cost = (slip_pct * current_fury_balance)
    assert(balance >= current_fury_balance - slip_cost and balance <= current_fury_balance + slip_cost )
    current_fury_balance = balance
    balance = test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, furynet_symbol)
    slip_cost = (slip_pct * current_coin_balance)
    assert(balance >= current_coin_balance - slip_cost and balance <= current_coin_balance + slip_cost)
    current_coin_balance = balance

    # check for failure if we try to add too much liquidity
    basic_transfer_request.amount = 10 ** 19
    txn = add_pool_liquidity(basic_transfer_request, credentials)
    assert(txn["code"] == 25)
    get_pools(basic_transfer_request.furynd_node)
    current_fury_balance = current_fury_balance - furynet_fees_int
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury") == current_fury_balance)
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, furynet_symbol) == current_coin_balance)

    # check for failure if we try to swap too much for user
    basic_transfer_request.amount = 10 ** 19
    txn = swap_pool(basic_transfer_request, "fury", furynet_symbol, credentials)
    assert(txn["code"] == 27)
    get_pools(basic_transfer_request.furynd_node)
    current_fury_balance = current_fury_balance - furynet_fees_int
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury") == current_fury_balance)
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, furynet_symbol) == current_coin_balance)

    # check for failure if we try to swap too much for pool
    basic_transfer_request.amount = 5 * 10 ** 17
    txn = swap_pool(basic_transfer_request, "fury", furynet_symbol, credentials)
    assert(txn["code"] == 31)
    get_pools(basic_transfer_request.furynd_node)
    current_fury_balance = current_fury_balance - furynet_fees_int
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury") == current_fury_balance)
    assert(test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, furynet_symbol) == current_coin_balance)

    # now try to do a swap that works
    change_amount = 10 ** 15
    basic_transfer_request.amount = change_amount
    txn = swap_pool(basic_transfer_request, "fury", furynet_symbol, credentials)
    # TODO: compute this precisely?
    slip_pct = 0.01
    balance = test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, "fury")
    assert(balance < current_fury_balance)
    current_fury_balance = balance
    balance = test_utilities.get_furynet_addr_balance(furyaddress, basic_transfer_request.furynd_node, furynet_symbol)
    assert(balance > current_coin_balance)
    current_coin_balance = balance
