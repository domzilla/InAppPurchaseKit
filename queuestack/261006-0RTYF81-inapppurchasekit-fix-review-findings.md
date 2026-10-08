---
id: '261006-0RTYF81'
title: 'InAppPurchaseKit: fix review findings'
author: Dominic Rodemer
created_at: '2026-10-06T07:03:58.597079Z'
status: open
labels:
- master
---

## Overview

Fix the bugs found by the automated test-suite and doc/code reviews of InAppPurchaseKit. Offer and payment-mode parsing on the legacy (pre-iOS 17.2) transaction path come first, then the transaction observer's state reporting. Once done, legacy transactions report offers correctly, `IAPPaymentMode` round-trips through its string form, and `isObserving` matches its documented semantics.

## Sub-items

Proposed sequence, top to bottom. Check off each sub-item when it is closed.

- [x] 261006-0R81AJQ — IAPOffer.fromTransaction never returns nil before iOS 17.2 (blocked by: none)
- [x] 261005-1NRT6H6 — IAPPaymentMode description/init(String) round-trip broken (blocked by: none)
- [ ] 261006-0R816GA — IAPTransactionObserver.isObserving ignores finished listener tasks (blocked by: none)
