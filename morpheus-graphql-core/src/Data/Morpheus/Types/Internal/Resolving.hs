{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Data.Morpheus.Types.Internal.Resolving
  ( Event (..),
    Resolver,
    LiftOperation,
    runRootResModel,
    lift,
    SubEvent,
    Eventless,
    Failure (..),
    eventChannels,
    ResponseEvent (..),
    ResponseStream,
    cleanEvents,
    Result (..),
    ResultT (..),
    unpackEvents,
    ObjectResModel (..),
    ResModel (..),
    FieldResModel,
    WithOperation,
    PushEvents (..),
    subscribe,
    ResolverContext (..),
    unsafeInternalContext,
    RootResModel (..),
    resultOr,
    withArguments,
    -- Dynamic Resolver
    mkBoolean,
    mkFloat,
    mkInt,
    mkEnum,
    mkList,
    mkUnion,
    mkObject,
    mkNull,
    mkString,
    SubscriptionField (..),
    getArguments,
    Channel (..),
    ResolverState,
    liftResolverState,
  )
where

import Data.Morpheus.Types.Internal.AST
  ( FieldName,
    ScalarValue (..),
    Token,
    TypeName,
  )
import Data.Morpheus.Types.Internal.Resolving.Core
import Data.Morpheus.Types.Internal.Resolving.Event
import Data.Morpheus.Types.Internal.Resolving.Resolver
import Data.Morpheus.Types.Internal.Resolving.ResolverState
import Prelude
  ( (.),
    Bool,
    Float,
    Int,
  )

mkString :: Token -> ResModel o e m
mkString = ResScalar . String

mkFloat :: Float -> ResModel o e m
mkFloat = ResScalar . Float

mkInt :: Int -> ResModel o e m
mkInt = ResScalar . Int

mkBoolean :: Bool -> ResModel o e m
mkBoolean = ResScalar . Boolean

mkEnum :: TypeName -> TypeName -> ResModel o e m
mkEnum = ResEnum

mkList :: [ResModel o e m] -> ResModel o e m
mkList = ResList

mkUnion :: TypeName -> Resolver o e m (ResModel o e m) -> ResModel o e m
mkUnion = ResUnion

mkNull :: ResModel o e m
mkNull = ResNull

mkObject ::
  TypeName ->
  [(FieldName, Resolver o e m (ResModel o e m))] ->
  ResModel o e m
mkObject __typename objectFields =
  ResObject
    ( ObjectResModel
        { __typename,
          objectFields
        }
    )
