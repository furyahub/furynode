import copy
import logging

import pytest
import time

import burn_lock_functions
import test_utilities
from integration_env_credentials import furynet_cli_credentials_for_test
from test_utilities import EthereumToFurynetTransferRequest, FurynetcliCredentials


@pytest.mark.skipif(not test_utilities.get_optional_env_var("DESTINATION_ACCOUNT", None), reason="run by hand and specify DESTINATION_ACCOUNT")
def test_token_distribution(
        basic_transfer_request: EthereumToFurynetTransferRequest,
        fury_source_integrationtest_env_credentials: FurynetcliCredentials,
        fury_source_integrationtest_env_transfer_request: EthereumToFurynetTransferRequest,
        smart_contracts_dir,
        source_ethereum_address,
        fury_source,
        fury_source_key,
        bridgebank_address,
        bridgetoken_address,
        ethereum_network,
):
    tokens = test_utilities.get_whitelisted_tokens(basic_transfer_request)
    request = basic_transfer_request
    amount_in_tokens = 10000000

    for t in tokens:
        try:
            logging.info(f"sending: {t}")
            destination_symbol = "c" + t["symbol"]
            if t["symbol"] == "efury":
                destination_symbol = "fury"
            request.amount = int(amount_in_tokens * (10 ** int(t["decimals"])))
            request.ethereum_symbol = t["token"]
            request.furynet_symbol = destination_symbol
            request.furynet_address = fury_source
            request.furynet_destination_address = test_utilities.get_required_env_var("DESTINATION_ACCOUNT")
            test_utilities.send_from_furynet_to_furynet(request, fury_source_integrationtest_env_credentials)
        except Exception as e:
            logging.error(f"error: {e}")
