package dispensation

import (
	"github.com/Furynet/furynode/x/dispensation/keeper"
	types "github.com/Furynet/furynode/x/dispensation/types"
)

const (
	ModuleName        = types.ModuleName
	RouterKey         = types.RouterKey
	StoreKey          = types.StoreKey
	QuerierRoute      = types.QuerierRoute
	DefaultParamspace = types.DefaultParamspace
)

var (
	NewKeeper           = keeper.NewKeeper
	RegisterCodec       = types.RegisterLegacyAminoCodec
	DefaultGenesisState = types.DefaultGenesisState
)

type (
	Keeper          = keeper.Keeper
	GenesisState    = types.GenesisState
)
