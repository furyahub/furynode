import {inject, injectable, instanceCachingFactory, registry, singleton} from "tsyringe";
import type {Contract} from 'ethers';
import {BigNumber, ContractFactory} from "ethers";
import {HardhatRuntimeEnvironment} from "hardhat/types";
import {EthereumAddress, NotNativeCurrencyAddress} from "../ethereumAddress";
import {HardhatRuntimeEnvironmentToken,} from "./injectionTokens";
import {FurynetAccounts, FurynetAccountsPromise} from "./furynetAccounts";
import {
    BridgeBank,
    BridgeBank__factory,
    BridgeRegistry,
    BridgeRegistry__factory,
    BridgeToken,
    BridgeToken__factory,
    CosmosBridge__factory
} from "../../build";

@singleton()
export class FurynetContractFactories {
    bridgeBank: Promise<BridgeBank__factory>
    cosmosBridge: Promise<CosmosBridge__factory>
    bridgeRegistry: Promise<BridgeRegistry__factory>
    bridgeToken: Promise<BridgeToken__factory>

    constructor(@inject(HardhatRuntimeEnvironmentToken) hre: HardhatRuntimeEnvironment) {
        this.bridgeBank = hre.ethers.getContractFactory("BridgeBank").then((x: ContractFactory) => x as BridgeBank__factory)
        this.cosmosBridge = hre.ethers.getContractFactory("CosmosBridge").then((x: ContractFactory) => x as CosmosBridge__factory)
        this.bridgeRegistry = hre.ethers.getContractFactory("BridgeRegistry").then((x: ContractFactory) => x as BridgeRegistry__factory)
        this.bridgeToken = hre.ethers.getContractFactory("BridgeToken").then((x: ContractFactory) => x as BridgeToken__factory)
    }
}

export class CosmosBridgeArguments {
    constructor(
        readonly operator: EthereumAddress,
        readonly consensusThreshold: number,
        readonly initialValidators: Array<EthereumAddress>,
        readonly initialPowers: Array<number>,
    ) {
    }

    asArray() {
        return [
            this.operator.address,
            this.consensusThreshold,
            this.initialValidators.map(x => x.address),
            this.initialPowers
        ]
    }
}

export class CosmosBridgeArgumentsPromise {
    constructor(readonly cosmosBridgeArguments: Promise<CosmosBridgeArguments>) {
    }
}

@singleton()
export class CosmosBridgeProxy {
    contract: Promise<Contract>

    constructor(
        @inject(HardhatRuntimeEnvironmentToken) hardhatRuntimeEnvironment: HardhatRuntimeEnvironment,
        furynetContractFactories: FurynetContractFactories,
        cosmosBridgeArgumentsPromise: CosmosBridgeArgumentsPromise,
    ) {
        this.contract = furynetContractFactories.cosmosBridge.then(async cosmosBridgeFactory => {
            const args = await cosmosBridgeArgumentsPromise.cosmosBridgeArguments
            const cosmosBridgeProxy = await hardhatRuntimeEnvironment.upgrades.deployProxy(cosmosBridgeFactory, args.asArray())
            await cosmosBridgeProxy.deployed()
            return cosmosBridgeProxy
        })
    }
}

export function defaultCosmosBridgeArguments(furynetAccounts: FurynetAccounts, power: number = 100): CosmosBridgeArguments {
    const powers = furynetAccounts.validatatorAccounts.map(_ => power)
    const threshold = powers.reduce((acc, x) => acc + x)
    return new CosmosBridgeArguments(
        new NotNativeCurrencyAddress(furynetAccounts.operatorAccount.address),
        threshold,
        furynetAccounts.validatatorAccounts.map(x => new NotNativeCurrencyAddress(x.address)),
        powers
    )
}

@registry([
    {
        token: CosmosBridgeArgumentsPromise,
        useFactory: instanceCachingFactory<CosmosBridgeArgumentsPromise>(c => {
            const accountsPromise = c.resolve(FurynetAccountsPromise)
            return new CosmosBridgeArgumentsPromise(accountsPromise.accounts.then(accts => {
                return defaultCosmosBridgeArguments(accts)
            }))
        })
    }
])

@injectable()
export class BridgeBankArguments {
    constructor(
        private readonly cosmosBridgeProxy: CosmosBridgeProxy,
        private readonly furynetAccountsPromise: FurynetAccountsPromise
    ) {
    }

    async asArray() {
        const cosmosBridge = await this.cosmosBridgeProxy.contract
        const accts = await this.furynetAccountsPromise.accounts
        const result = [
            accts.operatorAccount.address,
            cosmosBridge.address,
            accts.ownerAccount.address,
            accts.pauserAccount.address
        ]
        return result
    }
}

@singleton()
export class BridgeBankProxy {
    contract: Promise<BridgeBank>

    constructor(
        @inject(HardhatRuntimeEnvironmentToken) h: HardhatRuntimeEnvironment,
        private furynetContractFactories: FurynetContractFactories,
        private bridgeBankArguments: BridgeBankArguments,
    ) {
        this.contract = furynetContractFactories.bridgeBank.then(async bridgeBankFactory => {
            const bridgeBankArguments = await this.bridgeBankArguments.asArray()
            const bridgeBankProxy = await h.upgrades.deployProxy(bridgeBankFactory, bridgeBankArguments, {initializer: "initialize(address,address,address,address)"}) as BridgeBank
            await bridgeBankProxy.deployed()
            const own = await bridgeBankProxy.owner()
            return bridgeBankProxy
        })
    }
}


@singleton()
export class BridgeRegistryProxy {
    contract: Promise<BridgeRegistry>

    constructor(
        @inject(HardhatRuntimeEnvironmentToken) h: HardhatRuntimeEnvironment,
        private furynetContractFactories: FurynetContractFactories,
        private cosmosBridgeProxy: CosmosBridgeProxy,
        private bridgeBankProxy: BridgeBankProxy,
    ) {
        this.contract = furynetContractFactories.bridgeRegistry.then(async bridgeRegistryFactory => {
            const bridgeRegistryProxy = await h.upgrades.deployProxy(bridgeRegistryFactory, [
                (await cosmosBridgeProxy.contract).address,
                (await bridgeBankProxy.contract).address
            ])
            await bridgeRegistryProxy.deployed()
            return bridgeRegistryProxy as BridgeRegistry
        })
    }
}

/**
 * Deploys a BridgeToken named efury
 */
@singleton()
export class FuryContract {
    readonly contract: Promise<BridgeToken>

    constructor(
        private furynetContractFactories: FurynetContractFactories,
    ) {
        this.contract = furynetContractFactories.bridgeToken.then(async bridgeToken => {
            return await (bridgeToken as BridgeToken__factory).deploy("efury") as BridgeToken
        })
    }
}

@singleton()
export class BridgeTokenSetup {
    readonly complete: Promise<boolean>

    private async build(
        fury: FuryContract,
        bridgeBankProxy: BridgeBankProxy,
        furynetAccounts: FurynetAccountsPromise
    ) {
        const efury = await fury.contract
        const owner = (await furynetAccounts.accounts).ownerAccount
        const bridgebank = (await bridgeBankProxy.contract).connect(owner)
        await bridgebank.addExistingBridgeToken(efury.address)
        await efury.approve(bridgebank.address, "10000000000000000000")
        await efury.addMinter(owner.address)
        const accounts = await furynetAccounts.accounts
        const muchFury = BigNumber.from(100000000).mul(BigNumber.from(10).pow(18))
        await efury.mint(accounts.operatorAccount.address, muchFury)
        return true
    }

    constructor(
        fury: FuryContract,
        bridgeBankProxy: BridgeBankProxy,
        furynetAccounts: FurynetAccountsPromise
    ) {
        this.complete = this.build(fury, bridgeBankProxy, furynetAccounts)
    }
}
