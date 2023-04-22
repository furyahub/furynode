package symbol_translator

import (
	"encoding/json"
	bimap2 "github.com/Furynet/furynode/cmd/ebrelayer/internal/bimap_with_default"
	"github.com/vishalkuo/bimap"
	"io/ioutil"
)

// SymbolTranslator translates between Furynet denoms and Ethereum symbols
type SymbolTranslator struct {
	symbolTable *bimap.BiMap
}

func (s *SymbolTranslator) FurynetToEthereum(denom string) string {
	return bimap2.GetWithDefault(s.symbolTable, denom, denom).(string)
}

func (s *SymbolTranslator) EthereumToFurynet(symbol string) string {
	return bimap2.GetInverseWithDefault(s.symbolTable, symbol, symbol).(string)
}

func NewSymbolTranslator() *SymbolTranslator {
	return &SymbolTranslator{symbolTable: bimap.NewBiMap()}
}

func NewSymbolTranslatorFromJSONFile(filename string) (*SymbolTranslator, error) {
	contents, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, err
	}
	return NewSymbolTranslatorFromJSONBytes(contents)
}

func NewSymbolTranslatorFromJSONBytes(jsonContents []byte) (*SymbolTranslator, error) {
	var symbolMap map[string]interface{}
	err := json.Unmarshal(jsonContents, &symbolMap)
	if err != nil {
		return nil, err
	}
	symbolBiMap := bimap.NewBiMap()
	for k, v := range symbolMap {
		symbolBiMap.Insert(k, v)
	}
	symbolBiMap.MakeImmutable()
	return &SymbolTranslator{symbolTable: symbolBiMap}, nil
}
