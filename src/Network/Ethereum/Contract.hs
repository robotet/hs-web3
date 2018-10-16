{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeSynonymInstances  #-}

-- |
-- Module      :  Network.Ethereum.Contract
-- Copyright   :  Alexander Krupenkin 2018
-- License     :  BSD3
--
-- Maintainer  :  mail@akru.me
-- Stability   :  experimental
-- Portability :  unportable
--
--
--

module Network.Ethereum.Contract where

import           Data.Proxy                       (Proxy)
import           Data.Text                        (Text)

import           Data.HexString                   (HexString)
import           Data.Solidity.Prim.Address       (Address)
import           Network.Ethereum.Account.Class   (Account)
import           Network.Ethereum.Account.Safe    (safeConfirmations, safeSend)
import           Network.Ethereum.Api.Types       (receiptContractAddress)
import           Network.Ethereum.Contract.Method (Method)
import           Network.JsonRpc.TinyClient       (JsonRpcM)

class Contract a where
    -- | Contract Solidity ABI
    -- https://solidity.readthedocs.io/en/latest/abi-spec.html
    abi :: Proxy a -> Text

    -- | Contract bytecode as hex string
    bytecode :: Proxy a -> HexString

-- | Create new contract on blockchain
new :: (Account p t, JsonRpcM m, Method a, Monad (t m))
    => a
    -- ^ Contract constructor
    -> t m (Maybe Address)
    -- ^ Address of deployed contract when transaction success
new = fmap receiptContractAddress . safeSend safeConfirmations