Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146F242846D;
	Tue, 28 Apr 2026 10:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372998; cv=none; b=tGy8hLUO1TAMUk2zKhPTuxk/3RJr3Aj3r8/uOvMdvJW487m4ckuEc2hqjcW9UHy5DwsGu7AhyDEksI+xvnovBBjdfU9LHeXggZXuOnSHstyOqmRWqHvj1StOLGzqaq1ycEPdaxJhISWqNzCMf+Wl1emSNWLXSx8EtWYvY0S6o0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372998; c=relaxed/simple;
	bh=GDqpqBZ0aaPdKXbVkb4HW156HRKwRtK+VRmGjNeJYzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MuBTirH9b4qgP47m2xvuBRidjpSkcsCRhBNqBzE21Vzd5/O7W64XL8vzS608y35K8mxDfS7gRuMiP4QVPTAyz4bvKeVvW36yqETVFzGbhXoHn6jfQyGGpvX/Q1Jzm6ek9inbMEnL7W9cnAj5+2WKMml1I1Gwz7io3IeuSC6/hHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0L95YoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0L95YoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A43EC2BCB5;
	Tue, 28 Apr 2026 10:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372997;
	bh=GDqpqBZ0aaPdKXbVkb4HW156HRKwRtK+VRmGjNeJYzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0L95YoZzRrLvrkeqtlzegPzHlafDFGfeuq76f/su/RA14hMegTHpDLJrDtP8drPz
	 K56ISFxXxTrJ6F/4UFwPxc1UG32xfhiQ+3uRMbsmsYJEvBZw6gAr/izu22t4ag1Il/
	 5Dhb6qrauO5ExkVS/FQWmxHNaUMje7/Ji17W09v9dnVl4ETq7s8zciQVPW6GN85UHg
	 TjNhMNl5Y9Uo0bT4+ZEFmzm7gLT+OWogaYMNv+ND+e8U9MHit+MckfKadtRVoLQ3rS
	 F6a1WK6F0hIwboJ6eZtVvfbaFlMJBX7qixqBC9PW9oivBqpneP94vxjKr0utBkOTsh
	 U3tSA9CQ8sA5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	jejb@linux.ibm.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] scsi: lpfc: Add PCI ID support for LPe42100 series adapters
Date: Tue, 28 Apr 2026 06:41:23 -0400
Message-ID: <20260428104133.2858589-72-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 49b9f31e52b2125125318cb60fe9f5e7fa9c6755 ]

Update supported pci_device_id table to include the values for the G8 ASIC
Device ID utilized by LPe42100 series of adapters.  The default reporting
string will be "LPe42100".

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://patch.msgid.link/20260331205928.119833-10-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to compile a complete analysis.

## Phase 1: Commit Message Forensics

**Step 1.1: Subject line parsing**
Record: Subsystem `scsi: lpfc:`. Action verb "Add" (hardware
enablement). Summary: Adds PCI device ID 0xd300 for the new LPe42100
Fibre Channel adapter (G8 ASIC).

**Step 1.2: Tag inventory**
Record: Tags present:
- `Signed-off-by: Justin Tee <justin.tee@broadcom.com>` (author,
  Broadcom developer for lpfc)
- `Link: https://patch.msgid.link/20260331205928.119833-10-
  justintee8345@gmail.com` (mailing list reference)
- `Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>` (SCSI
  subsystem maintainer)
- No `Cc: stable`, no `Fixes:`, no `Reported-by`, no `Reviewed-by`, no
  `Tested-by`, no syzbot, no `Link` to any bug report.

**Step 1.3: Body text analysis**
Record: Short three-sentence message. No bug description. No stack
trace. No symptom. No reproducer. Explicitly framed as hardware
enablement: "Update supported pci_device_id table to include the values
for the G8 ASIC Device ID utilized by LPe42100 series of adapters."
States the model name reported will be "LPe42100".

**Step 1.4: Hidden bug fix detection**
Record: Not a hidden fix. No "cleanup"/"improve"/"handle"/"ensure"
wording. This is explicitly and exclusively hardware enablement — a new
PCI ID addition.

## Phase 2: Diff Analysis

**Step 2.1: Change inventory**
Record: 3 files, 8 meaningful lines added (plus 2 copyright year bumps):
- `drivers/scsi/lpfc/lpfc_hw.h`: +1 line (`#define
  PCI_DEVICE_ID_LANCER_G8_FC 0xd300`)
- `drivers/scsi/lpfc/lpfc_ids.h`: +2 lines (entry in `lpfc_id_table[]`)
- `drivers/scsi/lpfc/lpfc_init.c`: +3 lines (new `case` in
  `lpfc_get_hba_model_desc()` returning model string "LPe42100")

Scope: single-driver, surgical addition following exact pattern of
existing G6/G7/G7P entries.

**Step 2.2: Code flow change**
Record: Before: `lpfc_id_table[]` did not match 0x10df:0xd300 → lpfc
driver would not bind to LPe42100 hardware. `lpfc_get_hba_model_desc()`
would emit "Unknown" for such a device. After: lpfc binds to
0x10df:0xd300, model string populated as "LPe42100".

**Step 2.3: Bug mechanism**
Record: Category (h) — Hardware workaround / device ID addition. No bug
being fixed; new hardware enablement.

**Step 2.4: Fix quality**
Record: Obviously correct. Pattern-identical to the existing
LANCER_G6_FC / LANCER_G7_FC / LANCER_G7P_FC entries. No new code paths,
no API change, no behavioural change for any existing device.
Essentially zero regression risk — new table entry and new switch case
are only reached when a 0xd300 device is present in the system.

## Phase 3: Git History Investigation

**Step 3.1: Blame**
Record: The `lpfc_id_table[]` and `lpfc_get_hba_model_desc()` code has
been in the tree since the lpfc driver's early days. Neighbouring G7P
entry was added by commit f449a3d7a1530 (James Smart, Jul 2021, "scsi:
lpfc: Add PCI ID support for LPe37000/LPe38000 series adapters") which
first appeared in v5.15. So the surrounding code exists in every active
stable tree from 5.15.y through 7.0.y.

**Step 3.2: Fixes tag follow-up**
Record: No `Fixes:` tag. Not applicable — this is a hardware enablement,
not a fix.

**Step 3.3: File history / series context**
Record: Part of the 10-patch series "Update lpfc to revision 15.0.0.0".
Adjacent commits in the series:
- 39d1d94166da3 — "scsi: lpfc: Introduce 128G link speed selection and
  support" (immediately before)
- 7f1e2c1cce1ca — "scsi: lpfc: Update lpfc version to 15.0.0.0"
  (immediately after)

The 128G commit is a feature addition (not a fix) that enables the
highest link speed the LPe42100 supports. **However**, I verified that
no other code in lpfc mainline references `PCI_DEVICE_ID_LANCER_G8_FC` —
only the three sites this commit touches — so binding and operation at
supported lower speeds does not require the 128G patch.

**Step 3.4: Author context**
Record: Justin Tee (Broadcom) is a regular lpfc contributor. SCSI
maintainer Martin K. Petersen signed off, indicating maintainer review.

**Step 3.5: Dependencies**
Record: No strict dependency on other patches in the series. G8 ASIC
reuses the existing LANCER_G6/G7/G7P code paths; there is no G8-specific
behaviour anywhere else in the driver. Full 128G link speed would
require the 128G patch, but the adapter binds, probes, and operates at
<=64G without it.

## Phase 4: Mailing List Research

**Step 4.1: Original submission**
Record: `b4 dig -c 49b9f31e52b21` located the original patch at https://
lore.kernel.org/all/20260331205928.119833-10-justintee8345@gmail.com/.
Part of series "[PATCH 00/10] Update lpfc to revision 15.0.0.0"
submitted 2026-03-31.

**Step 4.2: Reviewers**
Record: `b4 dig -a` shows only v1 of the series exists (no v2/v3
needed). Thread contains no Reviewed-by / Acked-by / Tested-by tags, no
NAKs, no `Cc: stable` suggestion. Martin K. Petersen accepted the
series.

**Step 4.3: Bug report**
Record: Not applicable — no bug report; new-hardware enablement.

**Step 4.4: Related series patches**
Record: The relevant companion is patch 08/10 (128G support, not a fix
and not for stable). Patch 10/10 is a version bump. No other companion
needed for the PCI ID to function.

**Step 4.5: Stable mailing list history**
Record: No stable list discussion about this commit (it is too recent —
merged early April 2026, well after v7.0).

## Phase 5: Code Semantic Analysis

**Step 5.1–5.4: Impact surface**
Record: Three touched sites:
- `lpfc_id_table[]` — consumed by the PCI core for driver match; no new
  code paths, just a new entry.
- `PCI_DEVICE_ID_LANCER_G8_FC` macro — used only in the new switch case
  in `lpfc_get_hba_model_desc()`.
- `lpfc_get_hba_model_desc()` — called during probe/ioctl to format a
  model string. Reached only when a device with the new ID is present.

`grep PCI_DEVICE_ID_LANCER_G8` across origin/master returns exactly
those three sites — no hidden dependencies.

**Step 5.5: Similar patterns**
Record: Existing LANCER_G6/G7/G7P entries are structurally identical.
This patch is a literal template-follow-up.

## Phase 6: Cross-Referencing and Stable Tree Analysis

**Step 6.1: Does the buggy code exist in stable?**
Record: There is no buggy code. The driver and surrounding structures
(`lpfc_id_table[]`, `lpfc_get_hba_model_desc()` switch) are present in
every active stable tree:
- 5.15.y: confirmed `PCI_DEVICE_ID_LANCER_G7P_FC` at lpfc_ids.h:121,
  lpfc_init.c:2608 — full context present
- 6.1.y: confirmed at lpfc_ids.h:119, lpfc_init.c:2741
- 6.6.y: confirmed at lpfc_ids.h:119, lpfc_init.c:2743
- 6.12.y: confirmed at lpfc_ids.h:119, lpfc_init.c:2732
- 5.10.y: no G7P present; driver older, backport would likely still
  apply but requires verification

**Step 6.2: Backport complications**
Record: Expected clean apply on 5.15.y, 6.1.y, 6.6.y, 6.12.y, 6.18.y,
6.19.y, 7.0.y. The three hunks anchor on G7P/SKYHAWK lines that are
unchanged in all those trees. Copyright bumps may need trivial
adjustment.

**Step 6.3: Related fixes in stable**
Record: N/A — no related fix.

## Phase 7: Subsystem Context

**Step 7.1: Criticality**
Record: `drivers/scsi/lpfc` — Emulex/Broadcom enterprise Fibre Channel
HBA driver. IMPORTANT (used in data-centre storage deployments, often
via enterprise distros that track LTS stable trees).

**Step 7.2: Activity**
Record: Actively maintained by Broadcom with quarterly "Update lpfc to
revision X" series, and many bug fixes are routinely backported to all
recent stable trees.

## Phase 8: Impact and Risk Assessment

**Step 8.1: Affected users**
Record: Users of LPe42100 (and compatible LPe421xx) Fibre Channel HBAs
running a stable/LTS kernel. Without this patch, the HBA does not bind
to the `lpfc` driver — hardware is effectively unusable on those
kernels. Enterprise/distro users often run 6.1.y / 6.6.y / 6.12.y LTS.

**Step 8.2: Trigger**
Record: Device present → driver should bind. Without the patch: driver
does not claim the device on stable kernels. Unprivileged trigger: N/A
(hardware presence is the trigger).

**Step 8.3: Failure mode severity**
Record: On stable kernels lacking this patch, a correctly installed
LPe42100 is unsupported (device is recognized by PCI subsystem but
`lpfc` declines it). User-visible symptom: no FC connectivity. Severity
category: hardware enablement — MEDIUM-HIGH for affected users (full
feature loss of the purchased adapter).

**Step 8.4: Risk-benefit**
Record: Benefit — enables new hardware for stable users (distro
customers). Risk — essentially zero: all new code paths are gated on
matching the new PCI ID; no existing device can reach the added code. 8
lines, trivial content, maintainer-signed.

## Phase 9: Final Synthesis

**Step 9.1: Evidence**
For: (a) Small, contained, obviously correct. (b) Follows the stable
rules' "NEW DEVICE IDs" exception verbatim. (c) Applies cleanly to all
active stable trees. (d) Near-zero regression risk. (e) Broadcom-signed
and maintainer-signed. (f) Strong historical precedent — smartpqi,
iwlwifi, arcmsr, k10temp, hid wacom, etc. all regularly get new-PCI-ID
additions into stable.

Against: (a) Not a bug fix. (b) Not tagged `Cc: stable`. (c) No reviewer
explicitly nominated for stable. (d) 128G link speed support is a
separate (non-stable) feature patch — but the adapter remains functional
at supported lower speeds without it.

**Step 9.2: Stable checklist**
1. Obviously correct and tested: YES (pattern-identical to 3 prior
   entries).
2. Fixes a real bug: NO — but falls under stable's explicit hardware-
   enablement exception.
3. Important issue: MEDIUM-HIGH for LPe42100 owners (no adapter
   operation without it).
4. Small and contained: YES (8 lines, 3 files).
5. No new features/APIs: Adds hardware support only — no new UAPI,
   sysfs, or module param.
6. Can apply to stable trees: YES, clean apply expected on 5.15.y
   through 7.0.y.

**Step 9.3: Exception category**
Record: YES — matches the "NEW DEVICE IDs" exception explicitly
documented in the stable rules. The `lpfc` driver already exists in
every active stable tree; only the ID and a model-string case are new.

**Step 9.4: Decision**
The commit meets the stable "new device ID for existing driver"
exception cleanly: driver pre-exists in all active stable trees, diff is
minimal and template-matches the G6/G7/G7P predecessors, regression risk
for non-G8 users is zero, and affected users (data-centre LPe42100
owners on LTS kernels) genuinely cannot use their hardware without it.

## Verification

- [Phase 1] Parsed commit message: confirmed no Fixes/Reported-by/Cc-
  stable/Reviewed-by/Tested-by tags; only author SOB, Link to
  patch.msgid.link, and maintainer SOB.
- [Phase 2] Counted diff hunks: `git show 49b9f31e52b21` — 3 files, 8
  meaningful lines + copyright bumps.
- [Phase 3] `git log --oneline -- drivers/scsi/lpfc/lpfc_ids.h` —
  confirmed f449a3d7a1530 (G7P addition, 2021) as nearest precedent.
- [Phase 3] `git log --oneline 49b9f31e52b21~3..49b9f31e52b21` —
  confirmed series context (128G link speed is the immediate
  predecessor).
- [Phase 3] `git grep PCI_DEVICE_ID_LANCER_G8 origin/master --
  drivers/scsi/lpfc/` — exactly 3 hits, matching the 3 diff sites; no
  hidden dependencies on other G8-specific code.
- [Phase 3] `git merge-base HEAD 49b9f31e52b21` → 6de23f81a5e08 (Linux
  7.0-rc1) — commit is post-7.0 (targeting 7.1 window) and not yet in
  any stable tree.
- [Phase 4] `b4 dig -c 49b9f31e52b21` — found thread at
  lore.kernel.org/all/20260331205928.119833-10-justintee8345@gmail.com.
- [Phase 4] `b4 dig -c 49b9f31e52b21 -a` — confirmed only v1 exists (no
  v2/v3).
- [Phase 4] Downloaded thread via `b4 dig -m`; grep for
  "stable@|NAK|Reviewed-by|Tested-by" → none beyond maintainer SOB.
- [Phase 6] `git grep PCI_DEVICE_ID_LANCER_G7P_FC` on
  stable/linux-5.15.y, 6.1.y, 6.6.y, 6.12.y — all contain the anchor
  lines the diff applies against; 5.10.y does not have G7P (pre-dates
  it).
- [Phase 6] Verified context around `lpfc_get_hba_model_desc()` and
  `lpfc_id_table[]` is identical in 6.12.y to HEAD (sed -n '110,130p' on
  stable/linux-6.12.y copy) → clean apply expected.
- [Phase 8] Verified that full 128G operation depends on commit
  39d1d94166da3, but basic bind/operation at ≤64G does not — confirmed
  by absence of any other G8 reference in the driver.
- UNVERIFIED: Did not actually run the backport against each stable
  branch; clean-apply assertion is based on source-line comparison, not
  `git cherry-pick` dry-runs.
- UNVERIFIED: Did not confirm whether 5.10.y is still actively
  maintained enough to warrant backport (LPe42100 is new enough that
  users on very old LTS likely aren't the target).

The commit is a textbook application of the stable "new device IDs to
existing drivers" exception: small, surgical, maintainer-signed, zero
regression risk for existing users, and enables real hardware for stable
kernel users. The absence of `Cc: stable` is expected (this is the whole
reason for the review). The companion 128G feature patch would be nice
for full performance but is not required for the device to function.

**YES**

 drivers/scsi/lpfc/lpfc_hw.h   | 3 ++-
 drivers/scsi/lpfc/lpfc_ids.h  | 4 +++-
 drivers/scsi/lpfc/lpfc_init.c | 3 +++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index b2e353590ebb5..6326f7353dd68 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -1771,6 +1771,7 @@ struct lpfc_fdmi_reg_portattr {
 #define PCI_DEVICE_ID_LANCER_G6_FC  0xe300
 #define PCI_DEVICE_ID_LANCER_G7_FC  0xf400
 #define PCI_DEVICE_ID_LANCER_G7P_FC 0xf500
+#define PCI_DEVICE_ID_LANCER_G8_FC  0xd300
 #define PCI_DEVICE_ID_SAT_SMB       0xf011
 #define PCI_DEVICE_ID_SAT_MID       0xf015
 #define PCI_DEVICE_ID_RFLY          0xf095
diff --git a/drivers/scsi/lpfc/lpfc_ids.h b/drivers/scsi/lpfc/lpfc_ids.h
index 0b1616e93cf47..a0a6e2d379b86 100644
--- a/drivers/scsi/lpfc/lpfc_ids.h
+++ b/drivers/scsi/lpfc/lpfc_ids.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -118,6 +118,8 @@ const struct pci_device_id lpfc_id_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_G7P_FC,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_G8_FC,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK_VF,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e9d9ac7da485b..f29e4b8fd02f4 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2752,6 +2752,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 	case PCI_DEVICE_ID_LANCER_G7P_FC:
 		m = (typeof(m)){"LPe38000", "PCIe", "Fibre Channel Adapter"};
 		break;
+	case PCI_DEVICE_ID_LANCER_G8_FC:
+		m = (typeof(m)){"LPe42100", "PCIe", "Fibre Channel Adapter"};
+		break;
 	case PCI_DEVICE_ID_SKYHAWK:
 	case PCI_DEVICE_ID_SKYHAWK_VF:
 		oneConnect = 1;
-- 
2.53.0

