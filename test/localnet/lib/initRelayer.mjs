import { sleep } from "zx";
import { createRelayer } from "../utils/createRelayer.mjs";
import { createRelayerRegistry } from "../utils/createRelayerRegistry.mjs";
import { getChainProps } from "../utils/getChainProps.mjs";
import { setupRelayerChannelIds } from "../utils/setupRelayerChannelIds.mjs";
import { send } from "./send.mjs";

export async function initRelayer(props) {
  // 0) retrieve furynet props
  const candidateFuryChainProps = getChainProps({ chain: "furynet" });

  const {
    chainProps: candidateOtherChainProps,
    registryFrom = `/tmp/localnet/config/registry`,
    rpcPortA = 26657,
    p2pPortA = 26656,
    pprofPortA = 6060,
    homeA = `/tmp/localnet/config/${candidateFuryChainProps.chain}/${candidateFuryChainProps.chainId}`,
    rpcPortB = 36657,
    p2pPortB = 36656,
    pprofPortB = 7060,
    homeB = `/tmp/localnet/config/${props.chainProps.chain}/${props.chainProps.chainId}`,
  } = props;

  const furyChainProps = {
    ...candidateFuryChainProps,
    rpcPort: rpcPortA,
    p2pPort: p2pPortA,
    pprofPort: pprofPortA,
    home: homeA,
  };
  const otherChainProps = {
    ...candidateOtherChainProps,
    rpcPort: rpcPortB,
    p2pPort: p2pPortB,
    pprofPort: pprofPortB,
    home: homeB,
  };

  // 1) create global registry for relayers
  await createRelayerRegistry({
    chainsProps: [furyChainProps, otherChainProps],
    registryFrom,
  });

  // 2) create relayer for pair of chain
  const createdRelayer = await createRelayer({
    furyChainProps,
    otherChainProps,
    registryFrom,
  });

  // 3) fund all relayer addresses
  await send(createdRelayer.furySendRequest);

  // 4) wait
  await sleep(1000);

  // 5) generate channel IDs
  await setupRelayerChannelIds({ home: otherChainProps.home });
}
