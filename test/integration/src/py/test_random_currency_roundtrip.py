import logging

import pytest

import burn_lock_functions
import test_utilities
from burn_lock_functions import EthereumToFurynetTransferRequest
from pytest_utilities import generate_test_account
from test_utilities import get_required_env_var, get_shell_output, amount_in_wei, \
    FurynetcliCredentials

smart_contracts_dir = get_required_env_var("SMART_CONTRACTS_DIR")
bridgebank_address = get_required_env_var("BRIDGE_BANK_ADDRESS")
bridgetoken_address = get_required_env_var("BRIDGE_TOKEN_ADDRESS")


def do_currency_test(
        new_currency_symbol,
        basic_transfer_request: EthereumToFurynetTransferRequest,
        source_ethereum_address: str,
        fury_source_integrationtest_env_credentials: FurynetcliCredentials,
        fury_source_integrationtest_env_transfer_request: EthereumToFurynetTransferRequest,
        ethereum_network,
        solidity_json_path,
):
    amount = amount_in_wei(9)
    logging.info(f"create new currency")
    new_currency = test_utilities.create_new_currency(
        amount,
        new_currency_symbol,
        new_currency_symbol,
        18,
        smart_contracts_dir=smart_contracts_dir,
        bridgebank_address=bridgebank_address,
        solidity_json_path=solidity_json_path
    )

    logging.info(f"create test account to use with new currency {new_currency_symbol}")
    basic_transfer_request.ethereum_address = source_ethereum_address
    request, credentials = generate_test_account(
        basic_transfer_request,
        fury_source_integrationtest_env_transfer_request,
        fury_source_integrationtest_env_credentials,
        target_ceth_balance=10 ** 17,
        target_fury_balance=10 ** 18
    )
    test_amount = 39000
    logging.info(f"transfer some of the new currency {new_currency_symbol} to the test furynet address")
    request.ethereum_symbol = new_currency["newtoken_address"]
    request.furynet_symbol = ("c" + new_currency["newtoken_symbol"]).lower()
    request.amount = test_amount
    burn_lock_functions.transfer_ethereum_to_furynet(request)

    logging.info("send some new currency to ethereum")
    request.ethereum_address, _ = test_utilities.create_ethereum_address(
        smart_contracts_dir, ethereum_network
    )
    request.amount = test_amount - 1
    burn_lock_functions.transfer_furynet_to_ethereum(request, credentials)


@pytest.mark.usefixtures("operator_private_key")
def test_transfer_tokens_with_some_currency(
        basic_transfer_request: EthereumToFurynetTransferRequest,
        source_ethereum_address: str,
        fury_source_integrationtest_env_credentials: FurynetcliCredentials,
        fury_source_integrationtest_env_transfer_request: EthereumToFurynetTransferRequest,
        ethereum_network,
        solidity_json_path,
):
    new_currency_symbol = ("a" + get_shell_output("uuidgen").replace("-", ""))[:4]
    do_currency_test(
        new_currency_symbol,
        basic_transfer_request,
        source_ethereum_address,
        fury_source_integrationtest_env_credentials,
        fury_source_integrationtest_env_transfer_request,
        ethereum_network,
        solidity_json_path=solidity_json_path
    )


@pytest.mark.usefixtures("operator_private_key")
def test_three_letter_currency_with_capitals_in_name(
        basic_transfer_request: EthereumToFurynetTransferRequest,
        source_ethereum_address: str,
        fury_source_integrationtest_env_credentials: FurynetcliCredentials,
        fury_source_integrationtest_env_transfer_request: EthereumToFurynetTransferRequest,
        ethereum_network,
        solidity_json_path,
):
    new_currency_symbol = ("F" + get_shell_output("uuidgen").replace("-", ""))[:3]
    do_currency_test(
        new_currency_symbol,
        basic_transfer_request,
        source_ethereum_address,
        fury_source_integrationtest_env_credentials,
        fury_source_integrationtest_env_transfer_request,
        ethereum_network,
        solidity_json_path=solidity_json_path
    )
