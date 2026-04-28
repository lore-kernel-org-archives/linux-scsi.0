Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8879B401484;
	Tue, 28 Apr 2026 10:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372943; cv=none; b=ERY6Gjtyvt2DQ5H4zKfONyYp9SCdUmnsEFej/w57peKFbGEDuYdSYzCq2ru4bmCw4rMfwh8JvniD5uPe12K59CxdTvQdn4ytACP7in3kXM2vAEbFVi/2NlINvmFR5a6SJ49WY3g1P8vGJ3+GcbLr6YVY7nApcrbllzivvcCsTvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372943; c=relaxed/simple;
	bh=gIV688uBFlsXlTT0uLql82n27evJwhecVjf4GCACkks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bupkD06cvU4yrBP5dG25/i5PeJhgqL4aDbBGQPi+ypyW7TUOGSaQTU77WY4ks/wq23wHOkUu+j9sYA7Ecg4S8M2f2yYfItIu5w4g4gH+Vp9cbxOoPPQKxA2Iw17dI8pBJfrSnYwACOfBrjjyOmSwXlH8ecwTHDWqt+bz4xGpDHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVjXBWxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVjXBWxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFA5C2BCB8;
	Tue, 28 Apr 2026 10:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372943;
	bh=gIV688uBFlsXlTT0uLql82n27evJwhecVjf4GCACkks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVjXBWxHm+zHlJoH/blcc+TrCd2An7ZaAYi1h09JpnS7E0Yc8yCmi0/iywi/Uh+d9
	 VkRhDi9Nfj0yJaKXpyYCW2LQbxDxof+gB8yhoABS7UpFh1IbRrC+4tn2zliy6IXu6A
	 PR+ggk2oZhSIPjnFPwPF6xsh2TSrp1xWaRT6FWo2yfKbNeHfZTJNr/soaC6fny4PTm
	 E4aYhfh7pBr/kLPGvBN0QLeyf/YX+ohQwu+HNvs9JhizeQipTXSORL2xGLFaXFbtqX
	 v+n9z2Q1vxDxoKXq2eTTfeiXtUl79+D//nr8XH5l2HtFxgCY8xGNbriHgH0+u7ehqs
	 Z1Uubzg5YDSKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jejb@linux.ibm.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] scsi: ufs: ufs-pci: Add support for Intel Nova Lake
Date: Tue, 28 Apr 2026 06:40:46 -0400
Message-ID: <20260428104133.2858589-35-sashal@kernel.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 096cd6b7adf21791827a045d464242d93a6fd54e ]

Add PCI ID to support Intel Nova Lake, same as Intel Meteor Lake (MTL).

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260309085815.55216-1-adrian.hunter@intel.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to complete the analysis.

## Phase 1: Commit Message Forensics

**Step 1.1: Parse Subject Line**
- Record: subsystem `scsi: ufs: ufs-pci:`, action verb `Add`, summary:
  "Add support for Intel Nova Lake" — hardware enablement via PCI ID

**Step 1.2: Parse All Commit Message Tags**
- Record:
  - Signed-off-by: Adrian Hunter (Intel, author, UFS PCI driver
    maintainer-level contributor)
  - Reviewed-by: Bart Van Assche (prolific SCSI/UFS reviewer)
  - Link: https://patch.msgid.link/20260309085815.55216-1-
    adrian.hunter@intel.com
  - Signed-off-by: Martin K. Petersen (SCSI subsystem maintainer)
  - No `Fixes:` tag, no `Cc: stable` (absence is expected per
    guidelines)
  - No `Reported-by:`, no syzbot

**Step 1.3: Analyze Commit Body**
- Record: The body is one sentence: "Add PCI ID to support Intel Nova
  Lake, same as Intel Meteor Lake (MTL)." Explicitly states the new
  platform reuses the existing MTL variant ops. No bug described — this
  is hardware enablement.

**Step 1.4: Detect Hidden Bug Fixes**
- Record: Not a hidden bug fix. This is a straightforward new-hardware-
  enablement PCI ID addition — which is an explicit exception category
  in the stable rules.

## Phase 2: Diff Analysis

**Step 2.1: Inventory**
- Record: 1 file changed (`drivers/ufs/host/ufshcd-pci.c`), +1/-0 lines.
  Scope: single-file, single-line surgical addition. Modified table:
  `ufshcd_pci_tbl[]`.

**Step 2.2: Code Flow Change**
- Record: Before: PCI device 0xD335 (INTEL) not matched → driver would
  not bind. After: PCI device 0xD335 matches and uses
  `ufs_intel_mtl_hba_vops`. Only affects the specific new device.

**Step 2.3: Bug Mechanism**
- Record: Category (h) Hardware workarounds — device ID addition. No bug
  mechanism; enables existing driver logic for a new SKU.

**Step 2.4: Fix Quality**
- Record: Trivially correct — simply matches the vendor/device pair to
  an existing, tested vops struct (`ufs_intel_mtl_hba_vops`). Zero
  regression risk: entries are only evaluated for matching vendor/device
  PCI IDs, so no non-Nova-Lake system can be affected.

## Phase 3: Git History Investigation

**Step 3.1: Blame**
- Record: The MTL vops struct `ufs_intel_mtl_hba_vops` was introduced by
  commit `4049f7acef3eb` ("scsi: ufs: ufs-pci: Add support for Intel
  MTL", Apr 2022, v5.18), which carried `Cc: stable@vger.kernel.org #
  v5.15+`. The MTL infrastructure is therefore in every active stable
  tree (5.15.y and later).

**Step 3.2: Follow Fixes: Tag**
- Record: No Fixes: tag — N/A. This is an enablement, not a fix.

**Step 3.3: File History / Prerequisites**
- Record: The surrounding PCI table has accumulated several similar
  single-line additions: Arrow Lake (`51031cc3f903e`, v6.5), Lunar Lake
  (`0a07d3c7a1d20`, v6.4), Panther Lake (`bdee2f1dcd84d`, v6.11),
  Wildcat Lake (`823f95575d854`, 2025). Each is identical in structure:
  one PCI ID reusing MTL ops. This commit is self-contained and has no
  prerequisites.

**Step 3.4: Author's Other Commits**
- Record: Adrian Hunter (Intel) is the long-time author/maintainer of
  the Intel UFS PCI support code. All past Intel PCI ID additions for
  this driver are his. Strong authority signal.

**Step 3.5: Dependencies**
- Record: The only dependency is `ufs_intel_mtl_hba_vops`, which has
  existed in stable since v5.15+.

## Phase 4: Mailing List Research

**Step 4.1: Find Original Discussion**
- Record: `b4 dig -c 096cd6b7adf21` matched by patch-id and returned htt
  ps://lore.kernel.org/all/20260309085815.55216-1-
  adrian.hunter@intel.com/ (only a single v1, no iterations).

**Step 4.2: Reviewers**
- Record: Bart Van Assche reviewed (Reviewed-by), Martin K. Petersen
  applied (SCSI maintainer). Addressed to linux-scsi@vger.kernel.org.
  Appropriate maintainer chain.

**Step 4.3: Bug Report**
- Record: No Reported-by/bug report — N/A (enablement).

**Step 4.4: Related Patches**
- Record: `b4 dig -a` confirmed only v1; no multi-patch series.
  Standalone.

**Step 4.5: Stable-Specific Discussion**
- Record: No explicit Cc: stable request in thread, but thread is clean
  and contains an Reviewed-by from Bart and a clean apply message from
  Martin. No objections.

## Phase 5: Code Semantic Analysis

**Step 5.1: Functions Modified**
- Record: No functions modified — only the PCI device ID table
  `ufshcd_pci_tbl[]`.

**Step 5.2–5.4: Callers / Callees / Call Chain**
- Record: The table is consumed by the PCI core (`pci_match_id`) for
  driver binding. Reachability: only when a Nova Lake host with PCI ID
  8086:D335 is present. With no such device, the added row is dead data.

**Step 5.5: Similar Patterns**
- Record: Five identical prior commits add single MTL-compatible IDs
  (MTL itself, ARL, LNL, PTL, WCL). Consistent, well-established
  pattern.

## Phase 6: Cross-Referencing / Stable Tree Analysis

**Step 6.1: Buggy Code in Stable?**
- Record: The underlying driver + `ufs_intel_mtl_hba_vops` exist in all
  active stable trees (5.15.y and later, since v5.18 with Cc: stable #
  v5.15+).

**Step 6.2: Backport Complications**
- Record: Trivial clean apply expected — single-line addition to a table
  that exists in all active stable trees. Minor possibility of context
  fuzz if the table has slightly fewer entries in older branches (e.g.,
  pre-Wildcat Lake), but still trivial.

**Step 6.3: Related Fixes Already in Stable?**
- Record: Panther Lake and Wildcat Lake PCI ID additions already made it
  to autosel stable branches (per `git branch --contains`), confirming
  the stable trees routinely accept this class of single-line Intel UFS
  PCI ID enablement.

## Phase 7: Subsystem Context

**Step 7.1: Subsystem Criticality**
- Record: `drivers/ufs/host/` — device driver for UFS (Universal Flash
  Storage). Criticality: IMPORTANT — UFS is the primary storage on
  modern Intel mobile/client platforms, so without this ID the system's
  main storage doesn't work at all on Nova Lake.

**Step 7.2: Activity**
- Record: Actively maintained; multiple commits per release. Mature,
  stable interfaces.

## Phase 8: Impact and Risk Assessment

**Step 8.1: Affected Users**
- Record: Users of Intel Nova Lake systems running a stable kernel.
  Without this patch, the UFS controller simply won't bind → the system
  cannot use its UFS storage.

**Step 8.2: Trigger Conditions**
- Record: Universally triggered on Nova Lake hardware at boot/probe. No
  special conditions. For all other hardware the code is inert.

**Step 8.3: Failure Mode Severity**
- Record: Without the patch: UFS storage inoperative on Nova Lake. With
  the patch: storage works. Severity for affected platform: HIGH (no
  storage = unusable system); for all other systems: zero impact.

**Step 8.4: Benefit / Risk**
- Record: BENEFIT: High for target hardware users, zero-cost for others.
  RISK: Essentially zero — only a PCI ID entry with a pointer to an
  existing, heavily-tested vops struct already in stable. Ratio strongly
  favors backport.

## Phase 9: Final Synthesis

**Step 9.1: Evidence**
- FOR: One-line PCI ID addition (exception category #1 in stable rules);
  reuses existing in-tree and in-stable `ufs_intel_mtl_hba_vops`;
  reviewed by Bart Van Assche; applied by Martin K. Petersen; obvious
  correctness; zero regression risk for non-matching hardware; matches
  the pattern of prior backported Intel UFS PCI ID additions (Arrow
  Lake, Lunar Lake, Panther Lake, Wildcat Lake).
- AGAINST: None substantive. No explicit Cc: stable (but that's expected
  — would not be in review otherwise).

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? YES — reviewed and applied by the
   maintainer; trivial addition.
2. Fixes a real problem for users? YES — UFS storage non-functional on
   Nova Lake without it.
3. Important? YES — primary storage on target platform.
4. Small & contained? YES — 1 line.
5. No new features/APIs? Correct — no user-visible API or new behavior;
   enables existing code path for a new device.
6. Applies to stable? YES — clean apply expected.

**Step 9.3: Exception Category**
- Record: Falls squarely under Exception Category #1 "NEW DEVICE IDs" —
  adding a PCI ID to an existing driver where the driver and the reused
  vops are already in stable.

**Step 9.4: Decision**
- YES. This is a textbook hardware enablement PCI ID addition that meets
  the explicit stable rule exception.

---

## Verification

- [Phase 1] Parsed tags from commit message: Signed-off-by (Adrian
  Hunter, Martin K. Petersen), Reviewed-by (Bart Van Assche), Link to
  patch.msgid.link. No Fixes:, no Cc: stable, no Reported-by.
- [Phase 2] `git show 096cd6b7adf21` confirmed: 1 file, +1/-0 line,
  single new entry `{ PCI_VDEVICE(INTEL, 0xD335),
  (kernel_ulong_t)&ufs_intel_mtl_hba_vops }` in `ufshcd_pci_tbl[]`.
- [Phase 3] `git log -- drivers/ufs/host/ufshcd-pci.c` showed history of
  prior Intel PCI ID additions (MTL, ADL, ARL, LNL, PTL, WCL).
- [Phase 3] `git show 4049f7acef3eb` confirmed the MTL support
  (introducing `ufs_intel_mtl_hba_vops`) carried `Cc:
  stable@vger.kernel.org # v5.15+`, so the vops exist in every active
  stable tree.
- [Phase 3] `git branch --contains 823f95575d854` and `git branch
  --contains bdee2f1dcd84d` showed Wildcat Lake and Panther Lake PCI ID
  patches already in `for-greg/*-200` autosel branches — precedent for
  backporting this exact class of patch.
- [Phase 3] Read `drivers/ufs/host/ufshcd-pci.c` lines 510–719:
  confirmed `ufs_intel_mtl_hba_vops` is defined at line 525 and already
  used by multiple MTL-family device IDs.
- [Phase 4] `b4 dig -c 096cd6b7adf21`: matched by patch-id to https://lo
  re.kernel.org/all/20260309085815.55216-1-adrian.hunter@intel.com/.
- [Phase 4] `b4 dig -c 096cd6b7adf21 -a`: confirmed only v1, no
  subsequent revisions.
- [Phase 4] Mbox inspection: Martin K. Petersen applied ("Applied to
  7.1/scsi-queue"), Bart Van Assche provided Reviewed-by. No NAKs, no
  objections.
- [Phase 5] Inspection of `ufshcd_pci_tbl[]` surroundings: no functions
  modified, only table data; table is consumed by PCI core during driver
  binding.
- [Phase 6] Confirmed `ufs_intel_mtl_hba_vops` is present in stable
  trees via the v5.15+ stable tag on commit 4049f7acef3eb.
- [Phase 8] Failure mode analysis: without patch, Nova Lake UFS
  controller does not bind → no storage on that platform; with patch, it
  binds using the already-in-stable MTL vops. No risk to unrelated
  systems because the PCI core only dispatches to this driver on
  matching vendor:device.
- UNVERIFIED: Did not fetch the lore.kernel.org thread via WebFetch
  (Anubis challenge page returned); mitigated by reading the thread
  contents directly from the b4-saved mbox
  (`/tmp/nova_lake_thread.mbox`), which contains the maintainer apply
  message and Bart's Reviewed-by.

The commit is a minimal, low-risk, standards-compliant PCI device ID
addition that enables UFS storage on a new Intel platform and reuses
infrastructure already in all active stable trees. It fits the explicit
"Adding PCI/USB/ACPI IDs to existing drivers" exception listed in the
stable kernel rules, and matches the precedent of prior autosel-ed Intel
UFS PCI ID additions (Panther Lake, Wildcat Lake).

**YES**

 drivers/ufs/host/ufshcd-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 5f65dfad1a71a..63f6b36b912fc 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -695,6 +695,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x7747), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0xE447), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x4D47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0xD335), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ }	/* terminate list */
 };
 
-- 
2.53.0

