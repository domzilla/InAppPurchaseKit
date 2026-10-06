---
id: '261006-0R816GA'
title: IAPTransactionObserver.isObserving ignores finished listener tasks
author: Dominic Rodemer
created_at: '2026-10-06T06:53:53.262487Z'
status: open
labels:
- bug
---

> **Note:** Agent-generated from an automated doc/code review. This may be a false positive — analyze and confirm against the code before fixing.

`isObserving` (`src/InAppPurchaseKit/Classes/IAPTransactionObserver.swift:42-50`) only checks `isCancelled`. `Transaction.unfinished` is a finite sequence, so `unfinishedListenerTask` completes on its own, but `isObserving` still reports `true`.
Impact: low. The updates listener is still running, so "observing" is mostly accurate. But the state doesn't match the doc ("both tasks started"), and a task that ended (e.g. after throwing) is never detected or restarted.
Fix: decide on the semantics. Either base `isObserving` on the updates task only, or track completion (e.g. a flag set when each task exits) and update the doc to match.
