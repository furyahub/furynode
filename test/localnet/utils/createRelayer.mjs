import { $, nothrow } from "zx";
import { send } from "../lib/send.mjs";

export async function createRelayer({
  furyChainProps,
  otherChainProps,
  registryFrom = `/tmp/localnet/config/registry`,
}) {
  const { chain, home } = otherChainProps;
  const relayerHome = `${home}/relayer`;

  await nothrow($`mkdir -p ${relayerHome}`);
  await nothrow(
    $`ibc-setup init --home ${relayerHome} --registry-from ${registryFrom} --src ${furyChainProps.chain} --dest ${chain}`
  );

  let addresses = await $`ibc-setup keys list --home ${relayerHome}`;
  addresses = addresses.toString().split("\n");

  const furyChainAddress = addresses
    .find((item) => item.includes(`${furyChainProps.chain}`))
    .replace(`${furyChainProps.chain}: `, ``);
  const otherChainAddress = addresses
    .find((item) => item.includes(`${chain}`))
    .replace(`${chain}: `, ``);

  console.log(`furyChainAddress: ${furyChainAddress}`);
  console.log(`otherChainAddress: ${otherChainAddress}`);

  await send({
    ...otherChainProps,
    src: `${chain}-source`,
    dst: otherChainAddress,
    amount: 10e10,
    node: `tcp://127.0.0.1:${otherChainProps.rpcPort}`,
  });

  return {
    furyChainAddress,
    otherChainAddress,
    furySendRequest: {
      ...furyChainProps,
      src: `${furyChainProps.chain}-source`,
      dst: furyChainAddress,
      amount: 10e10,
      node: `tcp://127.0.0.1:${furyChainProps.rpcPort}`,
    },
  };
}
