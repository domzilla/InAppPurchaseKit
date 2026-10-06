---
id: '261005-1NRT6H6'
title: IAPPaymentMode description/init(String) round-trip broken
author: Dominic Rodemer
created_at: '2026-10-05T15:17:46.631793Z'
status: open
labels:
- bug
---

> **Note:** Produced during an autonomous agent run (test-suite review, 2026-10-05) and not verified by a human. This may be totally wrong — analyze and confirm before fixing.

## Parent

261006-0RTYF81

## Problem

`IAPPaymentMode` conforms to `LosslessStringConvertible` (`src/InAppPurchaseKit/Classes/IAPProduct.swift:76`), but:

- `description` returns camelCase (`"freeTrial"`, `"payAsYouGo"`, `"payUpFront"`, ~lines 145-156);
- `init(_: String)` only accepts snake_case (`"free_trial"`, …, ~lines 131-141).

## Repro

`IAPPaymentMode(IAPPaymentMode.freeTrial.description)`.

- Expected: `.freeTrial`
- Actual: `.undefined`

The same happens for `payAsYouGo` and `payUpFront`.

## Test

`IAPPaymentModeTests/DescriptionTests/roundTripProducesSameCase` in `src/InAppPurchaseKitTests/` is a known-issue test.
