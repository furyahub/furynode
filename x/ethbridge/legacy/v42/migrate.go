package v42

import (
	v039ethbridge "github.com/Furynet/furynode/x/ethbridge/legacy/v39"
	"github.com/Furynet/furynode/x/ethbridge/types"
)

func Migrate(state v039ethbridge.GenesisState) *types.GenesisState {
	return &types.GenesisState{
		CethReceiveAccount: state.CethReceiverAccount.String(),
		PeggyTokens:        state.PeggyTokens,
	}
}
