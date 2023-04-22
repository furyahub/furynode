package test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"

	furyapp "github.com/Furynet/furynode/app"
)

func CreateTestApp(isCheckTx bool) (*furyapp.FurynetApp, sdk.Context) {
	app := furyapp.Setup(isCheckTx)
	ctx := app.BaseApp.NewContext(isCheckTx, tmproto.Header{})
	app.AccountKeeper.SetParams(ctx, authtypes.DefaultParams())
	initTokens := sdk.TokensFromConsensusPower(1000, sdk.DefaultPowerReduction)
	_ = furyapp.AddTestAddrs(app, ctx, 6, initTokens)
	return app, ctx
}

func CreateTestAppMargin(isCheckTx bool) (sdk.Context, *furyapp.FurynetApp) {
	furyapp.SetConfig((false))
	app := furyapp.Setup(isCheckTx)
	ctx := app.BaseApp.NewContext(isCheckTx, tmproto.Header{})
	return ctx, app
}

func CreateTestAppMarginFromGenesis(isCheckTx bool, genesisTransformer func(*furyapp.FurynetApp, furyapp.GenesisState) furyapp.GenesisState) (sdk.Context, *furyapp.FurynetApp) {
	furyapp.SetConfig(false)
	app := furyapp.SetupFromGenesis(isCheckTx, genesisTransformer)
	ctx := app.BaseApp.NewContext(isCheckTx, tmproto.Header{})
	return ctx, app
}
