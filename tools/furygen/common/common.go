package common

import (
	"github.com/Furynet/furynode/app"
	"github.com/Furynet/furynode/tools/furygen/common/types"
)

// Aliases
type (
	Keys       types.Keys
	ConfigTOML types.ConfigTOML
	AppTOML    types.AppTOML
	Genesis    types.Genesis
)

var (
	DefaultNodeHome = app.DefaultNodeHome
	StakeTokenDenom = types.StakeTokenDenom

	P2PPort             = 26656
	MaxNumInboundPeers  = 1000
	MaxNumOutboundPeers = 1000
	AllowDuplicateIP    = true
)

var (
	MinCLPCreatePoolThreshold = "100"
)
