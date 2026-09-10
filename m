Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020093.outbound.protection.outlook.com [52.101.196.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52623A4521;
	Thu, 10 Sep 2026 16:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058573; cv=fail; b=p8vpc3IOiElgEHNxmyu6x1BhstcuC9l6M7Qq74/EQjdFYeHh8+c7sX4NV9vd0509sQZUWHeevvbP1WE3b7TBvOdApU74yfq7HFpZpTNa54CsUo9ytwSiAD0zw83wKrmmXEfLUF4l6WjwVtNW7W9pKGNYiNBMcLJmefbDoZ+kyfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058573; c=relaxed/simple;
	bh=CQ2CMb0akS7g2+2p8yREFBHkGlmeE06G7BuiPQVOmO4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=E/8j+YnzmhhJj0/jMlQj456S/H9zspleOZtFY62kZBrxknrXvxC01twSsV/nS+ZYw14i+HTclGD6bXUsGo5yRYCVK9aBRQTb2EDGFXBjnoecmOK9hznKQGV4D2WhAFOEDlZ2DOeEmKPhP6kyBFsfAvsGKRmbXC2tA4ucAUaE6Is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N5rIaaZ49OCPkNn3WthZSl9lnGGxz4G5o0eiJ0urKTbK7x/rEOKy6FWnt0J+FvAeR5bjHJhQeVHxvnEeB9tpfD3kBR9sssM4GvtMfA/9N95fhkWPIJ6QpK0H1GuLfdMalHOuIRTww2ZQR0kkmR8vjQzIzSPaxHfWoccD2JNNTxs9LDuiNj1+RJAIWUZKF/lEHgbcRqCjxGo7OqOfcUAhPOyd5fY8xKuEBjEW4dDkQB0hsc7JcnHQ/GxBMYNXkIR7For+UKOXBUWgSCrFE3MfpL/HHRR+kRNT6xscPvNMCtc/vP0/Ruk4tSje+oe+7RieHkmcaNgqSSdEZCGgRalakg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=n2yrbeFqpEfoKy19WLPRlLIQpEKP/bFdvWrOF/g80kg=;
 b=bJEa/2WUoPRts7LP55B3Sz7Mnw0h+wXYnw+A7hgyrq2xiksJgeHAE7yTBTyN5PAtLEoeml+b2XTrPgOj/3yb7HNedsULzoavaJTCv/bXuZz7jbLhWsjHcKf9q/s2/sncpZuEUEk77SHaj2gsrsywgPDMbOUojF9wvPYwJT5d+bZlErnlj6M2PGtdqUV5R0ClYUxeSKb3ky3HEhRXWd84zNbpybBvmBxTaMd87p+fJPRE3Ad/yvsJ9AwwVxEtWmCH5Ds1likq2PkZiSzZQ9APsQFTB6LW3mq9UjGFrYMANpyb6knKtF9NKk1BVlJbJrUxvAU6k+lRqyrjcwErsGUrRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by CW1P123MB096022.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:2a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 16:42:44 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 16:42:44 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk,
	tglx@kernel.org,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	frederic@kernel.org,
	bigeasy@linutronix.de
Cc: atomlin@atomlin.com,
	ionut.nechita@windriver.com,
	corbet@lwn.net,
	vincent.guittot@linaro.org,
	mingo@redhat.com,
	peterz@infradead.org,
	radu@rendec.net,
	akpm@linux-foundation.org,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	nick.lange@gmail.com,
	marco.crivellari@suse.com,
	rishil1999@outlook.com,
	linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v16 0/9] blk: honor isolcpus configuration
Date: Thu, 10 Sep 2026 12:42:28 -0400
Message-ID: <20260910164237.500196-1-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:a03:332::10) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|CW1P123MB096022:EE_
X-MS-Office365-Filtering-Correlation-Id: 61014fb7-1979-4b6f-d577-08df0f5a8965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|6133799003|18002099003|3023799007|56012099006|10067099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	a0kh867bTqTtdtTaHN+a/KZ+uC+oGJfnXtz8x3i9srSYzWYYnbXQQMoyJ4BHiKsG72O8qwJJUTEvsTsoVbcOZCf2EgIwlHeAOmZ/jXMZ+HBxm/j9NycH5YcCYQUQB/kV241MOyVCt1iU1mXy6bjxT0M7HIP7zIs7NrJWjwn9G8fyTAEiHMUtFG+ruUthwDMRAx+A1kf4HdKJ6ebAr70tLq0V0QAy3KIWS4XcRYuHj8ue/aH4JYYb0trj2v5dSI6QV8yUuOKBLjbRVKTCawec7/Gw0B+76RYcdlBHFeFTJDQqvmPt9iZ8oXmvhT5OsTXoVT32ZdkNVROvX6KbXRDhYbwpDqwrKpPhumHfsiK7++3Z+wjwjhrPWb9t7XQ/NoK5gMpati+B2C8hEuGqCWUcNs67+umIoh9fVJ6qP329eNNxCBblAlMHCSVmeEC3gK6ug0iEpuathYsLN92WMFK36jr+EpQbmNUNrMnKTTHOGKgnzo9bv0CZoaDpFPGXlylrJmy4avV38CA1KdQEuAQBRVm3KsLcAi8GlOmTMT/F+YJ4Ya68vP91yw2jo9J0MxTne2XwPNEQVwxTmNWSj9G+ozTpid01epcQY9H3Zm2xls8T5Hi3ZKe1onBpz4ZCAq+k
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(6133799003)(18002099003)(3023799007)(56012099006)(10067099003)(5023799004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GGb3/bC0Uud6/j+fc5Z0H0Qa4/ap3IWtmE3UBkeCXktv7Ug3U6X65giFjx10?=
 =?us-ascii?Q?3CVqgVmUZqh+1pNIBY0QijDwR5fqSnStMkV0y8hcBJg9Pu+iUuTQTZHF/AGu?=
 =?us-ascii?Q?OFNhppEZ6Gn/ki23HWRsH+qcAbkrndHux62p7FTO4aiF6Ir2xthP47dyqdOx?=
 =?us-ascii?Q?LdSejhd4PtY6H7DGGSCR6mNpEwQEGEL1YlXtoSzY7QlkhlTCpVEfMxjiqWgy?=
 =?us-ascii?Q?mso7lFMH7dqAS+eL18fKVoehehIDu/3fqYC6GLUo2WF879NKTn/SmgvntV66?=
 =?us-ascii?Q?ZJ1sTw/ohRvH1d2Q1RNy0aLbWhCbnEzmGljXBh7y5rViSJNdfL3hS78ILlaI?=
 =?us-ascii?Q?7s1kXZvp9wAzvbImyMNRFuNUZunwhhfIj+tz5BtYouPKMNfWzZm44cQ/6plx?=
 =?us-ascii?Q?RXPiEKmBARGa6Ei5FGMMipLZNhEvYo+DW4HVbU9QYVAhtEv/ayXzvhmxINUz?=
 =?us-ascii?Q?/aNFXg/LDiK0yJMy/bJuxB9PkllNfjxcgfNNgx+jnMnFDQdeKZiKbEeYMwS/?=
 =?us-ascii?Q?sdsHYf/ZeP6CY24vyiILRKeGX2hZENOwLS4MSnt6MR9XoMknTQqNSmM+0WiX?=
 =?us-ascii?Q?yOVwKT26Q7ggquzj8auFcmdgiNDEoXSe208yE0gyPy/tCKOQIxog77zHkvdv?=
 =?us-ascii?Q?G/620LPqFUpEGlifbQFnUfbpoQtPxJYq0oWCVtcAv4tfZEZJn9IoE1hreUdK?=
 =?us-ascii?Q?ZQs4EaWGomJj2id0imJu0w8ALTWBegFgB107ANFI/FO1lUphha+x9lB6xcrp?=
 =?us-ascii?Q?fBY6q0si9fZ7Xg6V/V6//pZ18gXfxWpydNUC5C4gTqcHJwMcvACf2mjv+/ll?=
 =?us-ascii?Q?tIUaMoRKvgnvCwYK74EfWceeAuHB+vgRGuXPVK1wjnW/WUKsts/rwXb19Wlo?=
 =?us-ascii?Q?oxRJn6sA1QXGSJY2Nfy18oCXhdzgrVkUXQkxpE3LQtNErLWqbYWadACHtz1m?=
 =?us-ascii?Q?mHRTxC/+8AqmHvh6TCoH45bTIIL+crb57o4hVa71anKJ+q9BfQDora96a9UT?=
 =?us-ascii?Q?BjT+W/axRsYdpp5RKtpoEOv2OLsC6f11UTGGel95YUSYEUTlqVIpjQP+U30n?=
 =?us-ascii?Q?tnkQQNw6m9Rrk1L8fUgrVFCFjWrfID+nlEmYjER4GsLbh9NTMIkgygbCPuus?=
 =?us-ascii?Q?z98eVC3nQjFsIFMi+Y/YzR+lHM3PuxWI8B8NgZFWYaOj+AqqhDxTbpkl38eh?=
 =?us-ascii?Q?sE/y1cky5ooIfQIs33W0ZhnvM7O0SPwJKjapiT9SxG4WAsnVCBVHC7ymNvpq?=
 =?us-ascii?Q?qPIuokc60Gs5kQCW3GPJlTTwkwE2iLgDHh4B7W/htFpElFrfny1qwQh0lBDp?=
 =?us-ascii?Q?EEZJm6QkMEq+MqNmFPl73bv1dC/VxABbDRZoD70BPpO+2w8pjsvRRhxq5vcW?=
 =?us-ascii?Q?MnSGUdiSg82YwOTrd6Xva8smJi5j92ahaIcxqWHdnWRNfSKcVxHKgoeM36iB?=
 =?us-ascii?Q?HjXjImxVW/pqbbgr9E06CdrIg4J3neuPIvnwrBiYCmyMPEep6tzQdnFz76lT?=
 =?us-ascii?Q?gOSYviTK46M/Op938VuH4HGYCoJImCJXcaqCq0Rsq9leKUpIwD5lhp3Xf3TY?=
 =?us-ascii?Q?AKsrcGBr2qiXiuWuoeTa7vDZ4vNc6lFH+xmOc9Sk4fkCRKBZ/IcWAQTpgp3E?=
 =?us-ascii?Q?3BbVt12Ov0O8FmewvI0TJC0G5UgXIBH+UPLYXL4Z/YODXUBDYUxo9/GTVaGF?=
 =?us-ascii?Q?bQdFyYeIcTKU6fHw8GqkBSMTPHs5p0IeGhvL6AdKoROZL14oZiKU6BEaUIkE?=
 =?us-ascii?Q?Hpaem7/PIg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61014fb7-1979-4b6f-d577-08df0f5a8965
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 16:42:43.9172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rgMkjOhnmUo7tW837E4kDU+3sBK/5tT9A6usgCNOI1YptrmMViS33rN1283NeZEYPHiw3q0/K0xgbkCe3p7ITw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB096022

Hi Thomas, Jens, Sebastian, Frederic,

This is version 16 of the series enabling multiqueue devices and managed
interrupts to adhere to CPU isolation constraints. The series has been
rebased on v7.3-rc1-708-g893e11787f78.

Background and Problem
======================

Modern multiqueue storage controllers (e.g. NVMe devices) typically
allocate as many hardware queues and interrupt vectors as there are CPUs in
the system. When CPU isolation is requested via isolcpus, the kernel's
current mechanism "isolcpus=managed_irq" relies on post-allocation affinity
steering inside kernel/irq/manage.c. However, because drivers allocate
queues and vectors before affinity steering takes place, the number of
vectors frequently matches or exceeds the total CPU count. In such
scenarios, the post-allocation steering logic cannot avoid assigning
managed interrupts to isolated CPUs, effectively defeating CPU isolation
for real-time and latency-critical workloads.

Proposed solution and architecture
==================================

This series introduces a new CPU isolation feature,
"isolcpus=managed_irq_strict", designed to protect isolated cores from the
disruptive hardware interrupts generated by high-performance multiqueue
devices.

To prevent I/O stalls, the block layer is additionally hardened to reject
hotplug requests that attempt to offline a housekeeping CPU if it is the
last remaining CPU actively serving an online isolated core.

The complex "top-down" mask plumbing introduced in earlier revisions
(version 12), which modified struct irq_affinity and expanded block layer
APIs, has been abandoned. It is replaced by a centralised approach: direct
isolation querying via housekeeping_cpumask(HK_TYPE_MANAGED_IRQ_STRICT)
within the genirq/affinity subsystem. This architectural simplification
successfully decouples core changes from driver-specific implementations.


In version 15, this was addressed under the previously named
"isolcpus=io_queue". During subsequent review, Sebastian Andrzej Siewior
pointed out that the existing "isolcpus=managed_irq" implementation is
fundamentally broken on modern multiqueue hardware, and raised the question
of whether we should introduce another flag at all, or instead fix
"managed_irq" directly in place. As Sebastian observed, if
backward-compatibility concerns prevent modifying the legacy behaviour, a
"managed_irq_strict" designation represents the logical counterpart.

To make progress while keeping backwards compatibility completely safe,
this iteration adopts option 2: we drop the "io_queue" naming in favour of
"isolcpus=managed_irq_strict". It acts as the strict, pre-allocation
counterpart to "managed_irq", constraining both block layer queue mappings
and generic interrupt affinity masks exclusively to housekeeping CPUs.
Furthermore, if both options are supplied, "managed_irq_strict" takes
precedence.

Maintainer guidance requested
=============================

We would appreciate guidance from Frederic Weisbecker regarding preference
on this front:
        1.  Do you prefer keeping "managed_irq_strict" as an explicit
            opt-in (as implemented in this series) to preserve historical
            behaviour for existing users of "managed_irq"?

        2.  Or would you prefer upgrading the semantics of "managed_irq"
            directly in place without introducing a new parameter, on the
            grounds that the legacy post-allocation behaviour is already
            broken for modern multiqueue hardware?


Please let me know your thoughts.

Changes since v15:

 - Migrated feature naming from "isolcpus=io_queue" (HK_TYPE_IO_QUEUE) to
   "isolcpus=managed_irq_strict" (HK_TYPE_MANAGED_IRQ_STRICT), establishing
   it as the strict, pre-allocation counterpart to "managed_irq"

 - Specifying "managed_irq_strict" automatically enables
   HK_FLAG_MANAGED_IRQ so that dependent subsystems continue to function

 - Cleaned up commit bodies across the series, stripping informal
   scratchpads and adding Co-developed-by attribution where appropriate

 - Added new patch 4/9 ("sched/isolation: Prevent out-of-bounds read in
   isolcpus= boot parameter parser"). Incorporated prerequisite bugfix
   resolving an out-of-bounds read in housekeeping_isolcpus_setup() when
   sub-parameters lack trailing commas

 - Defined HK_TYPE_MANAGED_IRQ_STRICT and HK_FLAG_MANAGED_IRQ_STRICT.
   Ensured HK_FLAG_MANAGED_IRQ is set when managed_irq_strict is enabled

 - Decoupled queue mapping from dynamic cpu_online_mask; eliminated the
   blk_mq_validate() check and online cpumask snapshotting to avoid TOCTOU
   races during concurrent CPU hotplug events

 - Added cpuhp_tasks_frozen check to ensure suspend, hibernation, and
   resume transitions are not aborted

 - Added blk_mq_map_queue_type() check so CPU offline validation only
   evaluates hardware contexts actively mapped to the CPU being offlined

 - Enhanced warning message to report the offending CPU ID and queue
   number

 - Prioritised affd->calc_sets in irq_calc_affinity_vectors() so multi-set
   drivers scale vector allocations with requested set sizes to prevent
   cross-queue contention, while vector spreading remains strictly
   constrained to housekeeping cores

 - Documented "managed_irq_strict" in kernel-parameters.txt, detailing its
   role in blk-mq queue distribution and genirq affinity masking, as well
   as its superset relationship with legacy "managed_irq"

 - Link to v15: https://lore.kernel.org/lkml/20260521232956.553287-1-atomlin@atomlin.com/

Changes since v14:

 - Fixed a division-by-zero by ensuring group_mask_cpus_evenly() safely
   frees its allocations and returns NULL instead of an empty array if the
   provided mask yields zero groups.

 - Fixed a device probe -ENOSPC regression in blk_mq_num_queues(). If the
   housekeeping mask intersection evaluated to 0 (e.g., against a localised
   NUMA node), min_not_zero() would erroneously return the absolute maximum
   hardware queues. The result is now safely clamped to a minimum of 1.

 - Added a mapping verification check to prevent unrelated housekeeping
   CPUs from aborting the global hotplug offline sequence.

 - Aligned the pr_warn format specifier with the unsigned int declaration
   of hctx->queue_num in blk_mq_hctx_can_offline_hk_cpu().

 - Link to v14: https://lore.kernel.org/lkml/20260520215030.496803-1-atomlin@atomlin.com/

Changes since v13:

 - Removed ineffective data_race() annotations around mask and
   cpu_present_mask pointers. Wrapping the pointers failed to suppress
   KCSAN warnings for the underlying inline bitmap memory accesses.

 - Fixed a silent validation bypass in blk_mq_map_hw_queues() caused by
   overlapping IRQ affinity masks by removing the short-circuiting
   optimisation and evaluating the active_hctx bitmap in a secondary pass.

 - Restored topology-aware multi-queue fallback by correctly routing
   missing IRQ affinity masks to the map_software path instead of the naive
   map-all fallback.

 - Dropped hctx->queue->disk->disk_name from warning to avoid a UAF.

 - Fixed an isolation leak where excess allocated hardware queues were
   improperly padded with irq_default_affinity. Because these queues are
   marked as managed, they bypassed user-space IRQ balancing; they are now
   safely padded with the housekeeping mask.

 - Enforced the housekeeping vector cap prior to evaluating driver-provided
   calc_sets() callbacks, preventing modern multi-queue drivers from
   bypassing the cap and wasting memory on dead queues.

 - Introduced a safety net to the vector calculation to prevent fatal
   -ENOSPC device probe aborts on heavily isolated systems where the
   housekeeping CPU count is lower than the device's structural minimum.

 - Removed an inaccurate claim stating that the io_queue isolation flag
   takes precedence over managed_irq. Both flags are parsed, evaluated, and
   enforced entirely independently by their respective subsystems.

 - Link to v13: https://lore.kernel.org/lkml/20260513005509.135966-1-atomlin@atomlin.com/

Changes since v12:

 - Resolved TOCTOU race conditions against CPU hotplug events in
   blk_mq_map_queues() and group_mask_cpus_evenly() by taking lockless
   snapshots of the online CPU mask prior to algorithmic evaluation.

 - Migrated the active_hctx tracking to a dynamically sized bitmap
   (bitmap_zalloc), resolving a critical out-of-bounds memory write that
   occurred when hardware queues exceeded the system CPU count.

 - Wrapped the disk pointer fetch in blk_mq_hctx_can_offline_hk_cpu() with
   READ_ONCE() to prevent a TOCTOU NULL pointer dereference against
   concurrent device teardowns.

 - Introduced bitmap_empty() checks to prevent the mapping logic from
   routing unassigned CPUs into unallocated memory when all mapped CPUs are
   offline, safely forcing a fallback mapping instead.

 - Implemented a native two-stage distribution logic in
   group_mask_cpus_evenly() that first prioritises physically present CPUs
   to prevent I/O starvation before distributing remaining vectors to
   non-present CPUs for hotplug safety.

 - Restricted the maximum number of allocated vectors in
   irq_calc_affinity_vectors() to the weight of the housekeeping mask,
   preventing drivers from wasting memory on dead hardware queues that
   physically cannot be routed.

 - Added padding logic using irq_default_affinity for sets where isolation
   constraints yield fewer masks than requested vectors, preserving the 1:1
   hardware queue mapping sequence for subsequent sets.

 - Fixed a logic flaw that prematurely rejected valid offline requests by
   manually iterating over cpu_online_mask and reverse-mapping to
   accurately detect isolated CPUs, properly permitting the offlining of
   non-housekeeping CPUs.

 - Corrected an absolute versus relative queue index calculation bug in
   blk_mq_map_queues() that was overwriting loop iterations, by iterating
   directly over the generated masks.

 - Replaced scoped __free cleanups with traditional goto unwinding in the
   block layer to align with subsystem styling guidelines.

 - Refined the io_queue kernel command-line parameter documentation for
   better clarity and precision.

 - Link to v12: https://lore.kernel.org/lkml/20260422185215.100929-1-atomlin@atomlin.com/

Changes since v11:

 - Removed duplicate paragraph from the commit message in patch 11
   (Marco Crivellari)

 - Ensure ZERO_SIZE_PTR is not returned by group_mask_cpus_evenly()
   (Marco Crivellari)

 - Link to v11: https://lore.kernel.org/lkml/20260416192942.1243421-1-atomlin@atomlin.com/

Changes since v10:

 - Completely rewrote the isolcpus=io_queue documentation in
   Documentation/admin-guide/kernel-parameters.txt to clarify its exclusive
   application to managed IRQs, queue allocation limits, vector exhaustion
   prevention, and hardware interrupt routing (Ming Lei)

 - Fixed a stack frame bloat issue by avoiding the on-stack declaration of
   struct cpumask (Waiman Long)

 - Link to v10: https://lore.kernel.org/linux-nvme/20260401222312.772334-1-atomlin@atomlin.com/

Changes since v9:

 - Fixed a page fault regression encountered when initialising secondary
   queue maps (e.g. NVMe poll queues). Restored the qmap->queue_offset to
   the mq_map assignment to ensure CPUs are strictly mapped to absolute
   hardware indices (Keith Busch)

 - Corrected the active_hctx tracker to utilise relative queue indices,
   preventing out-of-bounds mask assignments

 - Fixed the blk_mq_validate() sanity check to properly evaluate absolute
   queue indices against the offset-adjusted loop index

 - Corrected typographical errors within block/blk-mq-cpumap.c
   (Keith Busch)

 - Clarified the commit message regarding the removal of the !SMP fallback
   code, explicitly noting that the core scheduler now mandates SMP
   unconditionally (Sebastian Andrzej Siewior)

 - Added missing "Signed-off-by:" tags to properly record the patch series
   chain of custody

 - Link to v9: https://lore.kernel.org/lkml/20260330221047.630206-1-atomlin@atomlin.com/

Changes since v8:

 - Added "Reviewed-by:" tags

 - Introduced irq_spread_hk_filter() to safely restrict managed IRQ
   affinity to housekeeping CPUs (Thomas Gleixner)

 - Removed the unsafe global static variable blk_hk_online_mask from
   blk-mq-cpumap.c and blk-mq.c. blk_mq_online_queue_affinity() now returns
   a stable pointer, delegating safe intersection to the callers to prevent
   concurrent modification races (Thomas Gleixner, Hannes Reinecke)

 - Resolved BUG: kernel NULL pointer dereference in __blk_mq_all_tag_iter
   reported by the kernel test robot during cpuhotplug rcutorture stress
   testing

 - Link to v8: https://lore.kernel.org/lkml/20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org/

Changes since v7:

 - Added commit 524f5eea4bbe ("lib/group_cpus: remove !SMP code")

 - Merged the new mapping logic directly into the existing function to
   avoid special casing

 - Refined the group_mask_cpus_evenly() implementation with the following
   updates:

   - Corrected the function name typo (changed group_masks_cpus_evenly to
     group_mask_cpus_evenly)

   - Updated the documentation comment to accurately reflect the function's
     behavior

   - Renamed the cpu_mask argument to mask for consistency

 - Added a new patch for aacraid to include the missing number of queues
   calculation

 - Restricted updates to only affect SCSI drivers that support
   PCI_IRQ_AFFINITY and do not utilise nvme-fabrics

 - Removed the __free cleanup attribute usage for cpumask_var_t allocations
   due to compatibility issues

 - Updated the documentation to explicitly highlight the limitations
   surrounding CPU offlining

 - Collected accumulated Reviewed-by and Acked-by tags

 - Link to v7: https://patch.msgid.link/20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org

Changes since v6:

 - Sent out the first part of the series independently:
   https://lore.kernel.org/all/20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org/

 - Added comprehensive kernel command-line documentation

 - Added validation logic to ensure the resulting CPU-to-queue mapping is
   fully operational

 - Rewrote the isolcpus mapping code to properly account for active
   hardware contexts (hctx)

 - Introduced blk_mq_map_hk_irq_queues, which utilizes the mask retrieved
   from irq_get_affinity()

 - Refactored blk_mq_map_hk_queues to require the caller to explicitly test
   for HK_TYPE_MANAGED_IRQ

 - Link to v6: https://patch.msgid.link/20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org

Changes since v5:

 - Reintroduced the io_queue type for the isolcpus kernel parameter

 - Prevented the offlining of a housekeeping CPU if an isolated CPU is
   still present, upgrading this behavior from a simple warning to a hard
   restriction

 - Link to v5: https://lore.kernel.org/r/20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org

Changes since v4:

 - Rebased the series onto the latest for-6.14/block branch.

 - Updated the documentation regarding the managed_irq parameters

 - Reworded the commit message for "blk-mq: issue warning when offlining
   hctx with online isolcpus" for better clarity

 - Split the input and output parameters in the patch "lib/group_cpus: let
   group_cpu_evenly return number of groups"

 - Dropped the patch "sched/isolation: document HK_TYPE housekeeping
   option"

 - Link to v4: https://lore.kernel.org/r/20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org

Changes since v3:

 - Added the patch "blk-mq: issue warning when offlining hctx with online
   isolcpus"

 - Fixed the check in group_cpus_evenly(); the condition now properly uses
   housekeeping_enabled() instead of cpumask_weight(), as the latter always
   returns a valid mask

 - Dropped the Fixes: tag from "lib/group_cpus.c: honor housekeeping config
   when grouping CPUs"

 - Fixed an overlong line warning in the patch "scsi: use block layer
   helpers to calculate num of queues"

 - Dropped the patch "sched/isolation: Add io_queue housekeeping option" in
   favor of simply documenting the housekeeping hk_type enum

 - Added the patch "lib/group_cpus: let group_cpu_evenly return number of
   groups"

 - Collected accumulated Reviewed-by and Acked-by tags

 - Split the patchset by moving foundational changes into a separate
   preparation series:
   https://lore.kernel.org/linux-nvme/20241202-refactor-blk-affinity-helpers-v6-0-27211e9c2cd5@kernel.org/

 - Link to v3: https://lore.kernel.org/r/20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de

Changes since v2:

 - Integrated patches from Ming Lei
   (https://lore.kernel.org/all/20210709081005.421340-1-ming.lei@redhat.com/):
   "virtio: add APIs for retrieving vq affinity" and "blk-mq: introduce
   blk_mq_dev_map_queues"

 - Replaced all instances of blk_mq_pci_map_queues and
   blk_mq_virtio_map_queues with the new unified blk_mq_dev_map_queues

 - Updated and expanded the helper functions used for calculating the
   number of queues

 - Added the CPU-to-hctx mapping function specifically to support the
   isolcpus=io_queue parameter

 - Documented the hk_type enum and the newly introduced isolcpus=io_queue
   parameter

 - Added the patch "scsi: pm8001: do not overwrite PCI queue mapping"

 - Link to v2: https://lore.kernel.org/r/20240627-isolcpus-io-queues-v2-0-26a32e3c4f75@suse.de

Changes since v1:

 - Updated the feature documentation for clarity and completeness

 - Split the blk/nvme-pci patch into smaller, logical commits

 - Dropped the HK_TYPE_IO_QUEUE macro in favor of reusing
   HK_TYPE_MANAGED_IRQ

 - Link to v1: https://lore.kernel.org/r/20240621-isolcpus-io-queues-v1-0-8b169bf41083@suse.de

Aaron Tomlin (2):
  sched/isolation: Prevent out-of-bounds read in isolcpus= boot
    parameter parser
  genirq/affinity: Restrict managed IRQ affinity to housekeeping CPUs

Daniel Wagner (7):
  scsi: aacraid: use block layer helpers to calculate num of queues
  lib/group_cpus: remove dead !SMP code
  lib/group_cpus: Add group_mask_cpus_evenly()
  isolation: Introduce managed_irq_strict isolcpus type
  blk-mq: use hk cpus only when isolcpus=managed_irq_strict is enabled
  blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
  docs: add managed_irq_strict flag to isolcpus

 .../admin-guide/kernel-parameters.txt         |  37 +++-
 Documentation/core-api/housekeeping.rst       |   6 +-
 block/blk-mq-cpumap.c                         | 163 ++++++++++++++++--
 block/blk-mq.c                                |  63 +++++++
 drivers/scsi/aacraid/comminit.c               |   3 +-
 include/linux/group_cpus.h                    |   3 +
 include/linux/sched/isolation.h               |   1 +
 kernel/irq/affinity.c                         |  29 +++-
 kernel/sched/isolation.c                      |  18 ++
 lib/group_cpus.c                              | 112 ++++++++++--
 10 files changed, 395 insertions(+), 40 deletions(-)

-- 
2.55.0

