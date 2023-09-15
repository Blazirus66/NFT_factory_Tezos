LIGO_VERSION=0.72.0
LIGO=docker run --rm -v "C:\Users\chara\Desktop\TEZOS\Exercices":"/ligo" -w "/ligo" ligolang/ligo:$(LIGO_VERSION)

############################

help:
	@echo "This is the Makefile for the Tezos Contract"

############################

ligo-compile: 
	@echo "Compiling Tezos Contract..."
	@$(LIGO) compile contract contracts/main.mligo --output-file compiled/main.tz
	@$(LIGO) compile contract contracts/main.mligo --michelson-format json --output-file compiled/main.json

############################

ligo-test:
	@echo "Running tests on Tezos Contract..."
	@$(LIGO) run test ./tests/ligo/main.test.mligo

############################

nft-compile: 
	@echo "Compiling NFT Factory Contract..."
	@$(LIGO) compile contract contracts/nft_factory/nft_main.mligo --output-file compiled/nft_main.tz
	@$(LIGO) compile contract contracts/nft_factory/nft_main.mligo --michelson-format json --output-file compiled/nft_main.json
