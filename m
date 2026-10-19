Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DFC63DB5C;
	Mon, 19 Oct 2026 14:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418770; cv=none; b=WPiss4Lk9LWVUjB9ZA5Zv9Mnh7+zn+qlF9lOoMgYor6TxWipyS8cO/woPSsC0F/RWW9J+jhL6fLxAVVP0C9W1N22P8uln7oBZDeThbeNdmoEPlp5N1+LMg+nsUjvSJ6AfI9an2t3pa5r/SVzYJ1RouUIW5sEWzkwOZl9Xlgg4mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418770; c=relaxed/simple;
	bh=Tve3eLng/1NxsN3ahkLKaF2/k4aK1FH/bs13xFaU6Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mILrszFp+C9d3QL4WqfxVmfBh+3cvcQTw99Mi4Y/PLD9erU+BDRF8juadFIZIQTkqhflZUvIGdMa7qGQ1R0wXfX0z8J6D9z2nuueLKdURl574FHcK6pn2Aw2AflOzaidxLdcX6oevYQw4d/rhJQokV9VX8eyRBWlcllaUJb3hTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O9l01LMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O9l01LMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9262D1F000C4;
	Mon, 19 Oct 2026 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418767;
	bh=WVdthEYcxHl8cn/x2J1zllQeLKilCWicvaEWOCuh3bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9l01LMgglyVVBNjC2RXALkDx47bTfJNZIV5aY2tYK6Ue/4M6UW6BMfS2sKc17NCI
	 +7DIYyLf/uDeauoe28t79DnqZITuiXIdK/IPj5MrgJTSKfU0kCou+Nf7c2LqMN0A9H
	 7RVCQlCeDQgF3/J2EIpqUPeTyCdd4YqmEWMC9l2y4SBBJbcZqSo+i19rs+zCjnEBw6
	 IbsgkEIsW236v6532ZXEmFyVJfgjgFpW6+7JLD1K5zIINhl+owrYI824+OJgYgKnpy
	 MjAA8ziJdJTkZk90DRUYfVjvxfHZjalw2gz/evXRvt1oiBrmsFIJhlQQ+ptcKZtpMy
	 Owo94nRnI6tRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Strahan <David.Strahan@microchip.com>,
	David Strahan <david.strahan@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] scsi: smartpqi: Add new PCI device-ids
Date: Mon, 19 Oct 2026 09:52:52 -0400
Message-ID: <20261019135441.1420968-481-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Strahan <David.Strahan@microchip.com>

[ Upstream commit 1a220e6e87a31c2572cd07ff47023e5cd92ac80f ]

All PCI ID entries in Hex.

Add PCI IDs for Hurray Data controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
                                            9005 / 028f / 207d / 4246
                                            9005 / 028f / 207d / 4256
                                            9005 / 028f / 207d / 4356
                                            9005 / 028f / 207d / 4940
                                            9005 / 028f / 207d / 4a46

Add PCI IDs for ZTE controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
                                            9005 / 028f / 1cf2 / 5451
                                            9005 / 028f / 1cf2 / 5452
                                            9005 / 028f / 1cf2 / 5453

Add PCI ID for Ramaxel controller:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
                                            9005 / 028f / 1f3f / 0670

Signed-off-by: David Strahan <david.strahan@microchip.com>
Reviewed-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/linux-scsi/20260722220401.6357-1-david.strahan@microchip.com/
Link: https://patch.msgid.link/20260722220401.6357-4-david.strahan@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[scsi: smartpqi] [Add] new PCI device-ids for Hurray Data,
  ZTE, and Ramaxel OEM boards`

**Step 1.2 — Tags**
- Record:
  - `Reviewed-by: Don Brace <don.brace@microchip.com>` (listed smartpqi
    maintainer in MAINTAINERS)
  - `Link: https://lore.kernel.org/linux-
    scsi/20260722220401.6357-1-david.strahan@microchip.com/` (cover
    letter)
  - `Link: https://patch.msgid.link/20260722220401.6357-4-
    david.strahan@microchip.com/` (this patch)
  - `Signed-off-by: David Strahan <david.strahan@microchip.com>`
  - `Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>`
    (SCSI maintainer)
  - No `Fixes:`, no `Reported-by:`, no `Cc: stable` (absence expected)
  - Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
    ...]` markers

**Step 1.3 — Body**
- Record: Adds nine `PCI_DEVICE_SUB` entries (VID `9005` / DID `028f`)
  for:
  - Hurray Data SVID `207d`: SDIDs `4246`, `4256`, `4356`, `4940`,
    `4a46`
  - ZTE SVID `1cf2`: SDIDs `5451`, `5452`, `5453`
  - Ramaxel SVID `1f3f`: SDID `0670`
- Symptom/failure mode: those OEM SKUs are not in the explicit ID table,
  so they only bind via the `PCI_ANY_ID` wildcard. With
  `disable_device_id_wildcards=1`, probe returns `-ENODEV`.
- Version info: submitted against Martin Petersen’s `7.2/scsi-queue`;
  applied to `7.3/scsi-staging` / `7.3/scsi-queue`.
- Root cause: missing OEM subsystem IDs, not a logic bug.

**Step 1.4 — Hidden bug fix?**
- Record: Not a disguised crash/UAF fix. Cover letter says “No
  functional changes.” It is still a hardware-enablement ID table
  update, which is an explicit stable exception.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record: `drivers/scsi/smartpqi/smartpqi_init.c` only; `+36 / -0`.
  Function/object: `pqi_pci_id_table[]`. Surgical, single-file.

**Step 2.2 — Flow change**
- Record: Before: those nine subsystem IDs were absent; match fell
  through to the table’s `PCI_ANY_ID` catch-all. After: they match
  specific `PCI_DEVICE_SUB` rows first. No probe/remove/ioctl logic
  changes.

**Step 2.3 — Bug mechanism**
- Record: Category **hardware workaround / device ID addition**. Not
  UAF, leak, race, etc.

**Step 2.4 — Fix quality**
- Record: Obviously correct copies of adjacent `PCI_DEVICE_SUB` rows. No
  `driver_data`. No API or locking change. Regression risk is negligible
  (table grows; PCI match still first-match). Duplicate IDs were grepped
  and are not present.

## Phase 3: Git history

**Step 3.1 — Blame / introduction**
- Record: Driver added in `6c223761eb548` (2016-08-12), `smartpqi:
  initial commit of Microsemi smartpqi driver`. Catch-all
  `PCI_DEVICE_SUB(..., PCI_ANY_ID, PCI_ANY_ID)` is from that same
  commit. Vendor blocks already exist: Hurray `0x207d` (e.g.
  `48e6b7e708029`, `01b8bdddcfab0`), ZTE `0x1cf2` (since
  `09d9968a8eff8`, 2021), Ramaxel `0x1f3f` (`01b8bdddcfab0` /
  `dab5378485f60`).

**Step 3.2 — Fixes: tag**
- Record: None. Not applicable.

**Step 3.3 — File history**
- Record: Recent same-file work is a 4-patch series:
  1. `225548863f0a2` AIO retry marker
  2. `c64b2ab2ff516` `CCISS_BIG_PASSTHRU` ioctl
  3. `1a220e6e87a31` this ID patch
  4. `913337c48e6aa` version string
- This patch only inserts ID rows; it does not use the ioctl or AIO
  changes. Standalone.

**Step 3.4 — Author**
- Record: David Strahan is a regular Microchip smartpqi contributor
  (many prior PCI ID commits). Reviewed by Don Brace, the listed
  maintainer.

**Step 3.5 — Prerequisites**
- Record: Needs existing `pqi_pci_id_table` and neighboring `0x207d` /
  `0x1cf2` / `0x1f3f` rows for a clean apply. Those exist in this
  checkout. No new helpers or structs.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
- Record: `b4 dig -c 1a220e6e87a31` → https://patch.msgid.link/202607222
  20401.6357-4-david.strahan@microchip.com
- Cover: `[PATCH v1 0/4] smartpqi: fixes and updates for 2.1.42-011`
- This patch is `[PATCH v1 3/4] smartpqi: add new pci device-ids`
- `b4 dig -a` shows one v1 of this ID patch (other “v2/v3/v4” labels are
  sibling patches in the same send, not later ID-table revisions).
  Applied version is that v1.
- Martin K. Petersen: “Applied to 7.3/scsi-staging, thanks!” then
  “Applied to 7.3/scsi-queue” listing `[3/4] ... 1a220e6e87a3`. No NAKs,
  no stable nomination, no risk comments on the ID patch. Thread replies
  were about patches 1/4 and 2/4, not IDs.

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: David Strahan, `linux-scsi@vger.kernel.org`, Don Brace.
  Correct list and maintainer.

**Step 4.3 — Bug report**
- Record: No `Reported-by` / bugzilla / syzbot. Hardware enablement from
  the vendor.

**Step 4.4 — Series**
- Record: Patches 1–2 are independent (retry-marker callback; new
  ioctl). Patch 4 is a version string. This ID commit does not depend on
  them.

**Step 4.5 — Stable list**
- Record: lore.kernel.org/stable fetch returned HTTP 403. mbox has no
  “stable” / “NAK” hits. UNVERIFIED: whether anyone already asked
  stable@ about this hash.

## Phase 5: Code semantics

**Step 5.1 — Functions**
- Record: `pqi_pci_id_table` only (not a function). Consumed by
  `MODULE_DEVICE_TABLE(pci, pqi_pci_id_table)` and
  `pqi_pci_driver.id_table`.

**Step 5.2 — Callers**
- Record: `pci_register_driver(&pqi_pci_driver)` from `pqi_init()`.
  Probe is `pqi_pci_probe()`. Path is PCI enumeration / module autoload,
  not a syscall hot path.

**Step 5.3 — Callees**
- Record: Probe uses the matched `pci_device_id`. Relevant logic:

```9468:9478:drivers/scsi/smartpqi/smartpqi_init.c
        if (pqi_disable_device_id_wildcards &&
                id->subvendor == PCI_ANY_ID &&
                id->subdevice == PCI_ANY_ID) {
                dev_warn(&pci_dev->dev,
                        "controller not probed because device ID
wildcards are disabled\n");
                return -ENODEV;
        }

        if (id->subvendor == PCI_ANY_ID || id->subdevice == PCI_ANY_ID)
                dev_warn(&pci_dev->dev,
                        "controller device ID matched using
wildcards\n");
```

**Step 5.4 — Reachability**
- Record: Yes. Plug-in / boot with `CONFIG_SCSI_SMARTPQI`. Default:
  catch-all already binds `9005:028f`. With
  `disable_device_id_wildcards=1`, only explicit rows bind — these nine
  SKUs need the new entries.

**Step 5.5 — Similar patterns**
- Record: Same file has a long history of OEM ID additions (`Add new PCI
  IDs`, Hurray/ZTE/Ramaxel). This matches that pattern.

## Phase 6: Local tree

**Step 6.1 — Does the target code exist here?**
- Record: Local tree is **v7.3-rc4** (`7.3.0-rc4`).
  `drivers/scsi/smartpqi/` exists (`CONFIG_SCSI_SMARTPQI`). Neighboring
  Hurray/ZTE/Ramaxel rows exist. The nine IDs are already in the table
  because `1a220e6e87a31` is an ancestor of HEAD. The code this commit
  touches is present.

**Step 6.2 — Backport difficulty**
- Record: In this tree: already applied / would apply cleanly. Older
  stables may need context tweak if some neighboring IDs are missing;
  still a mechanical table insert.

**Step 6.3 — Related fixes already here?**
- Record: Earlier Hurray/ZTE/Ramaxel IDs are here; these nine SDIDs were
  new in this commit. No alternate fix.

## Phase 7: Subsystem context

**Step 7.1**
- Record: SCSI hardware driver `drivers/scsi/smartpqi/`. Criticality
  **IMPORTANT** (storage RAID/HBA on servers; not core mm/VFS). Not
  staging.

**Step 7.2**
- Record: Actively maintained by Microchip; frequent ID and bugfix
  updates. Driver itself is mature (2016).

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
- Record: Driver-specific: Hurray Data, ZTE, and Ramaxel boards using
  Adaptec2/Microchip `9005:028f`.

**Step 8.2 — Trigger**
- Record: Device present at enumeration. Common for those machines.
  Unprivileged users do not trigger it; missing IDs mean the RAID
  controller never binds (especially with wildcards disabled).

**Step 8.3 — Failure mode**
- Record: Controller not claimed (or only via wildcard, which some
  deployments disable). Severity **MEDIUM** as a “bug,” **HIGH** as
  hardware enablement for those boxes (boot disks can sit unused). Not a
  panic/UAF.

**Step 8.4 — Risk vs benefit**
- Record: Benefit: OEM HBAs work / are explicitly supported, including
  `disable_device_id_wildcards=1`. Risk: very low (36-line ID table
  only). Ratio strongly favors backport.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For:
- Explicit stable exception: PCI IDs on an existing driver
- Nine OEM SKUs; same VID/DID as the rest of the table
- `disable_device_id_wildcards` makes explicit IDs actually required
- 36 lines, one file, no logic/API change
- Reviewed by Don Brace; applied by Martin K. Petersen
- Standalone vs the rest of the 4-patch series
- Driver and vendor blocks exist in this tree

Against:
- Cover letter: “No functional changes”
- Catch-all already matches `9005:028f` when wildcards stay enabled
- Not a crash/security/corruption fix
- No `Cc: stable` (not a negative per the review rules)

Unresolved:
- Stable@ search 403; no independent confirmation of a prior stable
  request

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** (mechanical ID rows;
   maintainer Reviewed-by)
2. Real user-facing issue? **PASS** (hardware bind / explicit support)
3. Important? **PASS** under the PCI-ID exception (storage HBA
   enablement)
4. Small and contained? **PASS** (+36, one table)
5. No new features/APIs? **PASS** (IDs only; ioctl/version patches are
   separate)
6. Can apply to this tree? **PASS** (driver + table present; insertion
   points exist)

**Step 9.3 — Exception**
- Record: **NEW DEVICE IDs** to an existing driver.

**Step 9.4 — Decision**
This is the standard PCI ID stable case. It should be backported to this
tree: the smartpqi driver and ID table are here, the change is self-
contained, and it enables known OEM controllers (including when wildcard
matching is disabled).

### What it solves for stable users
Without these rows, Hurray/ZTE/Ramaxel `9005:028f` boards only match the
wildcard. Default kernels still probe them; kernels using
`disable_device_id_wildcards` refuse them. Listing the IDs is how this
driver declares supported SKUs and how those machines get a bound HBA.

### Risk vs benefit
Benefit is hardware enablement; risk is essentially nil. No dependency
on the AIO or `CCISS_BIG_PASSTHRU` patches.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Don Brace; Links to cover
  `...6357-1` and patch `...6357-4`; SOBs Strahan and Martin Petersen;
  no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +36 in `pqi_pci_id_table` only; nine `PCI_DEVICE_SUB`
  entries; grep showed no duplicate SDIDs
- [Phase 3] `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` → `7.3.0-rc4`
- [Phase 3] Commit SHA `1a220e6e87a31`; `git merge-base --is-ancestor
  1a220e6e87a31 HEAD` succeeded
- [Phase 3] Driver intro `6c223761eb548` (2016); catch-all from that
  commit; prior Hurray `48e6b7e708029` / `01b8bdddcfab0`; ZTE
  `09d9968a8eff8`; Ramaxel `dab5378485f60`
- [Phase 3] Parent of ID commit still has neighbors `0x4240`, `0x4840`,
  `0x544f`, `0x54da`, `0x0610`
- [Phase 4] `b4 dig -c 1a220e6e87a31` → msgid `20260722220401.6357-4`;
  `-w` CC linux-scsi + Don Brace; `-a` single v1 of this ID patch; `-m`
  saved `/tmp/smartpqi-ids.mbox`
- [Phase 4] Cover letter: “Adds PCI IDs … No functional changes.”
  Martin: applied 1/4–4/4 to 7.3/scsi-queue. No NAK on IDs
- [Phase 4] lore.kernel.org WebFetch 403; stable@ discussion UNVERIFIED
- [Phase 5] `pqi_pci_probe` wildcard-disable path verified at lines
  9468–9478; `module_param_named(disable_device_id_wildcards, ...)`
- [Phase 6] Grep of current `smartpqi_init.c` found all nine new IDs;
  `CONFIG_SCSI_SMARTPQI` in `drivers/scsi/smartpqi/Kconfig`
- [Phase 7] MAINTAINERS: Don Brace, Supported
- [Phase 8] Failure: `-ENODEV` when wildcards disabled; otherwise
  wildcard match + warning
- UNVERIFIED: whether older stable branches need context adjustment
  around missing neighboring IDs (not this checkout)

**YES**

 drivers/scsi/smartpqi/smartpqi_init.c | 36 +++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 88cffb1fb59ce..3f5fabf723c3e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -10152,10 +10152,30 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x207d, 0x4240)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4246)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4256)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4356)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x207d, 0x4840)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4940)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4a46)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADVANTECH, 0x8312)
@@ -10340,6 +10360,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x544f)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5451)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5452)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5453)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x54da)
@@ -10380,6 +10412,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1f3f, 0x0610)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f3f, 0x0670)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0220)
-- 
2.53.0

