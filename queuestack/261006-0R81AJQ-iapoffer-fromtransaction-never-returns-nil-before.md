---
id: '261006-0R81AJQ'
title: IAPOffer.fromTransaction never returns nil before iOS 17.2
author: Dominic Rodemer
created_at: '2026-10-06T06:53:53.249822Z'
status: open
labels:
- bug
---

> **Note:** Agent-generated from an automated doc/code review. This may be a false positive — analyze and confirm against the code before fixing.

## Parent

261006-0RTYF81

On the pre-iOS 17.2 / macOS 14.2 path, `IAPOffer.fromTransaction` (`src/InAppPurchaseKit/Classes/IAPOffer.swift:141-149`) always builds an offer, even when `transaction.offerType` is nil. It returns an `.undefined` offer instead of `nil`.
Impact: on older OS versions `IAPTransaction.offer` is never nil, so `offer != nil` checks report an offer that doesn't exist.
Fix: in the legacy branch, `guard transaction.offerType != nil else { return nil }`.
**Doc follow-up:** the `fromTransaction` doc comment (`IAPOffer.swift:126-128`) was changed to describe the current behaviour ("On earlier OS versions an instance is always returned"). Revert it when this is fixed.
