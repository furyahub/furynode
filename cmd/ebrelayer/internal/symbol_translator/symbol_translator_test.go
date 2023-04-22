package symbol_translator

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

const (
	furynetDenomFeedface = "ibc/FEEDFACEFEEDFACEFEEDFACEFEEDFACEFEEDFACEFEEDFACEFEEDFACEFEEDFACE"
	ethereumSymbolFeeface = "Face"
)

func TestNewSymbolTranslatorFromJsonBytes(t *testing.T) {
	_, err := NewSymbolTranslatorFromJSONBytes([]byte("foo"))
	assert.Error(t, err)

	q := ` {"ibc/FEEDFACEFEEDFACEFEEDFACEFEEDFACEFEEDFACEFEEDFACEFEEDFACEFEEDFACE": "Face"} `
	x, err := NewSymbolTranslatorFromJSONBytes([]byte(q))
	assert.NoError(t, err)
	assert.NotNil(t, x)
	assert.Equal(t, x.FurynetToEthereum(furynetDenomFeedface), ethereumSymbolFeeface)
	assert.Equal(t, x.EthereumToFurynet(ethereumSymbolFeeface), furynetDenomFeedface)
	assert.Equal(t, x.FurynetToEthereum("verbatim"), "verbatim")
	assert.Equal(t, x.EthereumToFurynet("verbatim"), "verbatim")
}

func TestNewSymbolTranslator(t *testing.T) {
	s := NewSymbolTranslator()
	assert.Equal(t, s.FurynetToEthereum("something"), "something")
}
