package furygen

import (
	"fmt"
	"io/ioutil"
	"log"

	"github.com/MakeNowJust/heredoc"

	"github.com/Furynet/furynode/tools/furygen/key"
	"github.com/Furynet/furynode/tools/furygen/network"
	"github.com/Furynet/furynode/tools/furygen/node"
	"github.com/Furynet/furynode/tools/furygen/utils"
)

type Furygen struct {
	chainID *string
}

func NewFurygen(chainID *string) Furygen {
	return Furygen{
		chainID: chainID,
	}
}

func (s Furygen) NewNetwork(keyringBackend string) *network.Network {
	return &network.Network{
		ChainID: *s.chainID,
		CLI:     utils.NewCLI(*s.chainID, keyringBackend),
	}
}

func (s Furygen) NetworkCreate(count int, outputDir, startingIPAddress string, outputFile string) {
	net := network.NewNetwork(*s.chainID)
	summary, err := net.Build(count, outputDir, startingIPAddress)
	if err != nil {
		log.Fatal(err)
		return
	}

	if err = ioutil.WriteFile(outputFile, []byte(*summary), 0600); err != nil {
		log.Fatal(err)
		return
	}
}

func (s Furygen) NetworkReset(networkDir string) {
	if err := network.Reset(*s.chainID, networkDir); err != nil {
		log.Fatal(err)
	}
}

func (s Furygen) NewNode(keyringBackend string) *node.Node {
	return &node.Node{
		ChainID: *s.chainID,
		CLI:     utils.NewCLI(*s.chainID, keyringBackend),
	}
}

func (s Furygen) NodeReset(nodeHomeDir *string) {
	if err := node.Reset(*s.chainID, nodeHomeDir); err != nil {
		log.Fatal(err)
	}
}

func (s Furygen) KeyGenerateMnemonic(name, password string) {
	newKey := key.NewKey(name, password)
	newKey.GenerateMnemonic()
	fmt.Println(newKey.Mnemonic)
}

func (s Furygen) KeyRecoverFromMnemonic(mnemonic string) {
	newKey := key.NewKey("", "")
	if err := newKey.RecoverFromMnemonic(mnemonic); err != nil {
		log.Fatal(err)
	}

	fmt.Println(heredoc.Doc(`
		Address: ` + newKey.Address + `
		Validator Address: ` + newKey.ValidatorAddress + `
		Consensus Address: ` + newKey.ConsensusAddress + `
	`))
}
