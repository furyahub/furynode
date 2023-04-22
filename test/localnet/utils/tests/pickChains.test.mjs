import { pickChains } from "../pickChains.mjs";

test("pick chains", () => {
  const result = pickChains({ chain: "furynode,cosmos,akash" });

  expect(result).toMatchSnapshot();
});
