import datetime
from typing import Tuple
from furytool.common import *
from furytool import cosmos, furynet


def get_block_times(furynoded: furynet.Furynoded, first_block: int, last_block: int) -> List[Tuple[int, datetime.datetime]]:
    result = [(block, cosmos.parse_iso_timestamp(furynoded.query_block(block)["block"]["header"]["time"]))
        for block in range(first_block, last_block)]
    return result
