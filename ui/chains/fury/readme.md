For reference when playing with cosmos cain

# Create liquidity pool catk:fury

```
furynd tx clp create-pool \
 --from akasha \
 --symbol catk \
 --nativeAmount 500 \
 --externalAmount 500
```

# Create liquidity pool cbtk:fury

```
furynd tx clp create-pool \
 --from akasha \
 --symbol cbtk \
 --nativeAmount 500 \
 --externalAmount 500
```

# Verify pool created

```
furynd query clp pools
```

# Execute swap

```
furynd tx clp swap \
 --from shadowfiend \
 --sentSymbol catk \
 --receivedSymbol cbtk \
 --sentAmount 20
```
