import logging
import os
import time
import json
import pytest
import string
import random
from dispensation_envutils import create_online_singlekey_txn, create_new_furyaddr_and_key, send_sample_fury, balance_check, \
query_block_claim, create_online_singlekey_txn_with_runner, run_dispensation

# AUTOMATED TEST TO VALIDATE ONLINE TXN
@pytest.mark.parametrize("claimType", ['ValidatorSubsidy'])
def test_run_online_morethan10distribution_txn(claimType):
    distributor_address, distributor_name = create_new_furyaddr_and_key()
    runner_address, runner_name = create_new_furyaddr_and_key()
    logging.info(f"distributor_address = {distributor_address}, distributor_name = {distributor_name}")
    logging.info(f"runner_address = {runner_address}, runner_name = {runner_name}")
    destaddress1, destname1 = create_new_furyaddr_and_key()
    destaddress2, destname2 = create_new_furyaddr_and_key()
    destaddress3, destname3 = create_new_furyaddr_and_key()
    destaddress4, destname4 = create_new_furyaddr_and_key()
    destaddress5, destname5 = create_new_furyaddr_and_key()
    destaddress6, destname6 = create_new_furyaddr_and_key()
    destaddress7, destname7 = create_new_furyaddr_and_key()
    destaddress8, destname8 = create_new_furyaddr_and_key()
    destaddress9, destname9 = create_new_furyaddr_and_key()
    from_address = 'furynodeadmin'
    keyring_backend = 'test'
    chain_id = 'localnet'
    amount = '100000000fury'
    fee = '150000'
    currency = 'fury'
    sampleamount = '1000fury'

    # THESE 4 TXNS ARE TO REGISTER NEW ACCOUNTS ON CHAIN
    send_sample_fury(from_address, runner_address, amount, keyring_backend, chain_id, "")
    time.sleep(5)
    send_sample_fury(from_address, distributor_address, amount, keyring_backend, chain_id, "")
    time.sleep(5)
    send_sample_fury(from_address, destaddress1, sampleamount, keyring_backend, chain_id, "")
    time.sleep(5)
    send_sample_fury(from_address, destaddress2, sampleamount, keyring_backend, chain_id, "")
    time.sleep(5)
    send_sample_fury(from_address, destaddress3, sampleamount, keyring_backend, chain_id, "")
    time.sleep(5)
    send_sample_fury(from_address, destaddress4, sampleamount, keyring_backend, chain_id, "")
    time.sleep(5)
    send_sample_fury(from_address, destaddress5, sampleamount, keyring_backend, chain_id, "")
    time.sleep(5)
    send_sample_fury(from_address, destaddress6, sampleamount, keyring_backend, chain_id, "")
    time.sleep(5)
    send_sample_fury(from_address, destaddress7, sampleamount, keyring_backend, chain_id, "")
    time.sleep(5)
    send_sample_fury(from_address, destaddress8, sampleamount, keyring_backend, chain_id, "")
    time.sleep(5)
    send_sample_fury(from_address, destaddress9, sampleamount, keyring_backend, chain_id, "")
    time.sleep(5)

    sorted_dest_address_list = sorted([destaddress1, destaddress2, destaddress3, destaddress4, destaddress5, destaddress6, destaddress7, destaddress8, destaddress9])
    logging.info(f"sorted_dest_address_list = {sorted_dest_address_list}")

    # CREATING TEST DATA HERE MIMICKING OUTPUT.JSON TO BE SUPPLIED BY NIKO'S API
    dict1 = {"denom": "fury", "amount": "5000"}
    dict2 = {"denom": "fury", "amount": "7000"}
    dict3 = {"denom": "fury", "amount": "8000"}
    dict4 = {"denom": "fury", "amount": "9000"}
    dict5 = {"denom": "fury", "amount": "10000"}
    dict6 = {"denom": "fury", "amount": "11000"}
    dict7 = {"denom": "fury", "amount": "12000"}
    dict8 = {"denom": "fury", "amount": "13000"}
    dict9 = {"denom": "fury", "amount": "14000"}

    dict13 = {"address": destaddress1, "coins": [dict1]}
    dict14 = {"address": destaddress2, "coins": [dict2]}
    dict15 = {"address": destaddress3, "coins": [dict3]}
    dict16 = {"address": destaddress4, "coins": [dict4]}
    dict17 = {"address": destaddress5, "coins": [dict5]}
    dict18 = {"address": destaddress6, "coins": [dict6]}
    dict19 = {"address": destaddress7, "coins": [dict7]}
    dict20 = {"address": destaddress8, "coins": [dict8]}
    dict21 = {"address": destaddress9, "coins": [dict9]}

    dict25 = {"Output": [dict13, dict14, dict15, dict16, dict17, dict18, dict19, dict20, dict21]}
    data = json.dumps(dict25)
    with open("output.json", "w") as f:
        f.write(data)

    # READ OUTPUT.JSON WITH CLAIMING ADDRESSES AND AMOUNT
    with open("output.json", "r") as f:
        data = f.read()

    d = json.loads(data)
    one_claiming_address = str(d['Output'][0]['address'])
    logging.info(f"one claiming address = {one_claiming_address}")

    # SENDER AND RECIPENT INITIAL BALANCE
    sender_initial_balance = int(balance_check(distributor_address, currency))
    claiming_address_initial_balance = int(balance_check(one_claiming_address, currency))
    logging.info(f"sender initial balance = {sender_initial_balance}")
    logging.info(f"one claiming address initial balance = {claiming_address_initial_balance}")

    # CREATE DISPENSATION TXN; GET TXN HASH
    txhash = str((create_online_singlekey_txn_with_runner(claimType, runner_address, distributor_name, chain_id)))
    logging.info(f"txn hash for creatng a dispensation = {txhash}")
    time.sleep(5)

    # QUERY BLOCK USING TXN HASH
    resp = query_block_claim(txhash)
    distribution_msg = resp['tx']['body']['messages'][0]
    msg_type = distribution_msg['@type']
    distributor = distribution_msg['distributor']
    authorized_runner = distribution_msg['authorized_runner']
    distribution_type = distribution_msg['distribution_type']

    # RUN DISPENSATION TXN; GET TXN HASH
    distribution_name = f"{str(resp['height'])}_{str(distributor)}"
    distribution_count = str(20)
    runtxnhash = run_dispensation(distribution_name, claimType, distribution_count, runner_address, chain_id)
    logging.info(f"txn hash for running dispensation = {runtxnhash}")
    time.sleep(5)

    # QUERY BLOCK USING TXN HASH
    runresp = query_block_claim(runtxnhash)
    logging.info(f"response from block for run dispensation = {runresp}")
    rundistributiontag = runresp['logs'][0]['events'][11]['type']
    rundistname = runresp['logs'][0]['events'][11]['attributes'][0]['value']
    runrunneraddress = runresp['logs'][0]['events'][11]['attributes'][1]['value']

    # RUN DISTRIBUTION TXN JSON TAGS ASSERTIONS
    assert str(rundistributiontag) == 'distribution_run'
    assert str(rundistname) == distribution_name
    assert str(runrunneraddress) == runner_address

    # READING TAGS FROM RUN DISPENSATION CMD
    temprundistamount1 = runresp['logs'][0]['events'][0]['attributes'][1]['value']
    temprundistamount2 = runresp['logs'][0]['events'][0]['attributes'][3]['value']
    temprundistamount3 = runresp['logs'][0]['events'][0]['attributes'][5]['value']
    temprundistamount4 = runresp['logs'][0]['events'][0]['attributes'][7]['value']
    temprundistamount5 = runresp['logs'][0]['events'][0]['attributes'][9]['value']
    temprundistamount6 = runresp['logs'][0]['events'][0]['attributes'][11]['value']
    temprundistamount7 = runresp['logs'][0]['events'][0]['attributes'][13]['value']
    temprundistamount8 = runresp['logs'][0]['events'][0]['attributes'][15]['value']
    temprundistamount9 = runresp['logs'][0]['events'][0]['attributes'][17]['value']

    my_list = [temprundistamount1, temprundistamount2, temprundistamount3, temprundistamount4, temprundistamount5, temprundistamount6, temprundistamount7, temprundistamount8, temprundistamount9]
    rundistamount = [int(i[:-5]) for i in my_list]
    amount_distributed = [rundistamount[0], rundistamount[1], rundistamount[2], rundistamount[3], rundistamount[4], rundistamount[5], rundistamount[6], rundistamount[7], rundistamount[8]]
    total_amount_distributed = sum(int(i) for i in amount_distributed)

    runrecipientaddress1 = runresp['logs'][0]['events'][0]['attributes'][0]['value']
    runrecipientaddress2 = runresp['logs'][0]['events'][0]['attributes'][2]['value']
    runrecipientaddress3 = runresp['logs'][0]['events'][0]['attributes'][4]['value']
    runrecipientaddress4 = runresp['logs'][0]['events'][0]['attributes'][6]['value']
    runrecipientaddress5 = runresp['logs'][0]['events'][0]['attributes'][8]['value']
    runrecipientaddress6 = runresp['logs'][0]['events'][0]['attributes'][10]['value']
    runrecipientaddress7 = runresp['logs'][0]['events'][0]['attributes'][12]['value']
    runrecipientaddress8 = runresp['logs'][0]['events'][0]['attributes'][14]['value']
    runrecipientaddress9 = runresp['logs'][0]['events'][0]['attributes'][16]['value']
    recipient_dispensation_addresses = [runrecipientaddress1, runrecipientaddress2, runrecipientaddress3, runrecipientaddress4, runrecipientaddress5, runrecipientaddress6, runrecipientaddress7, runrecipientaddress8, runrecipientaddress9]
    sortedrundistreceiverlist = sorted(recipient_dispensation_addresses)

    assert sortedrundistreceiverlist[0] == sorted_dest_address_list[0]
    assert sortedrundistreceiverlist[1] == sorted_dest_address_list[1]
    assert sortedrundistreceiverlist[2] == sorted_dest_address_list[2]
    assert sortedrundistreceiverlist[3] == sorted_dest_address_list[3]
    assert sortedrundistreceiverlist[4] == sorted_dest_address_list[4]
    assert sortedrundistreceiverlist[5] == sorted_dest_address_list[5]
    assert sortedrundistreceiverlist[6] == sorted_dest_address_list[6]
    assert sortedrundistreceiverlist[7] == sorted_dest_address_list[7]
    assert sortedrundistreceiverlist[8] == sorted_dest_address_list[8]

    recipient_with_respective_distributed_amount = dict(zip(recipient_dispensation_addresses, amount_distributed))
    logging.info(f"recipients and their respective distributed amounts = {recipient_with_respective_distributed_amount}")
    logging.info(f"total amount distributed = {total_amount_distributed}")
    claimed_amount_single_recipient = int(recipient_with_respective_distributed_amount[one_claiming_address])
    sender_final_balance = int(balance_check(distributor_address, currency))
    recipient_address_final_balance = int(balance_check(one_claiming_address, currency))
    logging.info(f"sender initial balance = {sender_initial_balance}")
    logging.info(f"sender final balance = {sender_final_balance}")

    # BALANCES ASSERTIONS
    assert int(total_amount_distributed) == int((sender_initial_balance - sender_final_balance) - int(fee))
    assert int(claimed_amount_single_recipient) == (recipient_address_final_balance - claiming_address_initial_balance)
    logging.info(f"balance transferred including fee from sender's address  = {(sender_initial_balance - sender_final_balance)}")
    logging.info(f"total amount distributed  = {total_amount_distributed}")
    logging.info(f"amount claimed by one recipient  = {claimed_amount_single_recipient}")
    logging.info(f"balance transferred in one recipient address  = {(recipient_address_final_balance - claiming_address_initial_balance)}")