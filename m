Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020076.outbound.protection.outlook.com [52.101.195.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65014371CFB;
	Wed,  1 Apr 2026 22:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082201; cv=fail; b=gv3Qvpp4VUw1YxfwwcjwKrcRjl/zvccO21QeUpiEvg0DAt3pyvJjxRyWpkv37k4y16oG2ajH4s2w7RMQ89dwflrYICO4OgWvqcUT8VqHGmYSWWUANmxdnQIz8GgLzNdumkZWWEUgZZEJ8z/jWYIgGq9xOXYwYlGW1Q7W24J1Aw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082201; c=relaxed/simple;
	bh=vDxYy67DytIbQl9Iw8/8l8Ll00G+vFKE5uRCGjlWFuI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PMHYXYMavdyUoJHDbQupobCG5anLbx9nrbWQFP0wthcjL9C/NNIbOr+ua7+HDeevMR1lipaWrZj+2KflQxPtVQ/w/Y4qUNPxFHd4xySamkWDO7dUj3/M93LdJ827IczUTSU+A8Dl0TljSH1V+88Hlg6p7RKbH3IvDNjQ9/keCSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jTcgil2pmdfkdqpYP8hcXp56Q7857PcDZfZt4j7jE+okoSp4RZMkt/yTPE5O7zxzbfjZ3JOmtbEfWrzSqk53VP6nEQvZmPVYucouUEmnCakn/VhuHtZMyeq/G/71ZJ4PAYDAIvC9EwCu9WPz7BKJwzyOfN+mWeCXPOOzfv5a/IqpKZd9HUf2BLSinF5kpfHMDNPuCY6CBHwMrx1/SbFQMfV+XxoncH3cjPxPGKnR7TBtV9Msa4B7j0qoPQ3ev0LNHGlf4lJJRzpbxqysp+NuRfJwvmsSoiaiyrmq7IYoXYj0yhOJhrHD0MtcDw4VIwsweg8VWCQ/MyeQNaERMMYAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FG/kX50CykTg1HxuSfJ70bPTgKYSAEmxY1bSA6FyI+c=;
 b=TjEjB+bCa6kZITBcvWMV3dqHGAV9098rDgaBpq5MMwHOkZL3gfr+5W6UeAj/0tR4kohOWCtE+6/Z6XMz85WGhtOy944/99pk+8296UGOZbWEf1NEdKZe3jw9Xpoxk8gXxRqmtkcEbmkQj1yT87lJVE1thiZQYynPf9vjTxt9uAGkg1PUIHwgVwDq+yzrz5ikFcze2mgMmkk+u0Lk6rqBRNzXn6spT0xbkLoUHwRiINPusO6Fn89wRazb1YjgPmsBjafrDvW1nE37wxbGq6tV0uM6bk2j7AWGzXeOtHv/MHDN4J3Fmgfkwkm5vL5A9WHwe7wrsSCe5smKKi5KtaoNNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CW1P123MB7844.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 22:23:15 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:23:15 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	mst@redhat.com
Cc: atomlin@atomlin.com,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	liyihang9@h-partners.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com,
	jinpu.wang@cloud.ionos.com,
	tglx@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	maz@kernel.org,
	ruanjinjie@huawei.com,
	bigeasy@linutronix.de,
	yphbchou0911@gmail.com,
	wagi@kernel.org,
	frederic@kernel.org,
	longman@redhat.com,
	chenridong@huawei.com,
	hare@suse.de,
	kch@nvidia.com,
	ming.lei@redhat.com,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v10 00/13] blk: honor isolcpus configuration
Date: Wed,  1 Apr 2026 18:22:59 -0400
Message-ID: <20260401222312.772334-1-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0127.namprd04.prod.outlook.com
 (2603:10b6:408:ed::12) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CW1P123MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: fec80d33-ad84-409b-6db9-08de903d44b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jxR9bhb6Lig4T+UKg6RZ0Rld6p5KVL44D/95YeO4F5Hfz4jqXI+7Lg7Np6+T9Did2qb8I0pXL8f1d7TH6W/85jFFHLIMDsbHhY6MCqd+7ooR7O4JLNWqdf1U6UtscdAN8PUz6kSkSEBaVLO/3D6vMwgNAtMKVN1FBXqa6n475X7tsf1Clayjwkqdf2rV5H9PtyaQ4Imy5Cfbgs4iJ0gfAiOFl+GP1HZi3UqPRXearH5m5qjsViO9BurOe5W3XNmaJqoKkb6CNFhXHrVtIFDYV9ixd44MVtEp8en3oSqn+QTqgYBQL1USiZFc97eaw8otOExMVkKILKOsSf9tHBi5yAzmAQEFSj+o4vPmGA4S7FWydmLDuyQnxq7im9Vbkjil0eZ3FtSErO8W+0csn0IzUnR8jTxjgJTMEle+b7FCqMnNLwvHQ8gpVEBMNZxg3fpM8MucwS1UTbM7FcGWCEdJM7W3pcAw0s7q14YerJL0jMYwshetISIqLJ13Yd3JMe5EMosU8U3mI7KJIt5dYhXXGfNW7+0D2uzsBMGBoS2mZPgsl+omK+R8lrqr3zrU88MHRcNMXVTfstgz0mms90YhZfa0pT+6dK4UfUnAAe2n5se7umMv1y4QVF6Ju2V3sp0WuWjeVyfb+U7r2NVTpBw0JDdMDlyNS/bDUpgeD4xwtEY1y5D1J4u3dD3Jn18tIpwi
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XcOBkgeV5jJVE+kiFajkv8H1pJnQ4jpWc/GOy+XoonNTUaJRkHQITl+T3mS5?=
 =?us-ascii?Q?8TEZtdR/x6/Vwlr3qjxEh58FKjLVWb0aIVZn37ismjW24aUJBq3Po5rqTZD3?=
 =?us-ascii?Q?Mjqix6W6/f/IP4UtDwaDOxMKzRr30ZlbQ07HMvEF4DtzBKU+LecF776sXKAD?=
 =?us-ascii?Q?b/xuP9id9fRh4aZ07HET3M8bayXACpTXRLHt2ah+f7lxu6tMYcXC4vmWRflT?=
 =?us-ascii?Q?MLRysPH3sK2R9fnrUhj9z9+Bcbd2Ye0Al0i/01bYdvj9XmwTd/lbR68FVunt?=
 =?us-ascii?Q?6Z3mschqsL+W3BYGZ2fddN0C6FTikYCJ6Ezi1TsVESS/FQHsGRGvcHJjXcyB?=
 =?us-ascii?Q?kFznvkHnp8nMc/RqJo7teIgW+Pjfs17ZC2bXkQAHLxrVtLsnt1vxzASRU0VT?=
 =?us-ascii?Q?3xBZ0hipr6f5bHu9IFeoSZkdA0qQW7u2D91r/64OTBz3geteC3cFkl4iaCqE?=
 =?us-ascii?Q?31L/Sm//CgqlmTFHmlhD8UgbhnWZvHKPplfbb/ePwtcrKXO2fxNusXdb9FaU?=
 =?us-ascii?Q?oYMqkP7qch22UoDnVpx2of4Hbht2T7kErHtffYTufBuAW9ZbWRuRd4oeZUa5?=
 =?us-ascii?Q?U4j1NfSympJUcpqu8OYpPMt0fEKrFlPFbDbQ5XUoI4ams+81lTO/QDWmbLeM?=
 =?us-ascii?Q?zjVRVSLBCtksKgjFnUEfFbG90JqNNPQlvh5WxasiC3VZkc8KcIOxX4xnf4Th?=
 =?us-ascii?Q?tx1zlJI9MN68F09MaSVi8JRe+7dh9lnJcOwjnEoNQ9VErZ7c+J/Pwj15etCD?=
 =?us-ascii?Q?ECxqZ6WY9Y3Ev+H4E+aciF5eeBPj3FWoLYaAwtkn+xoeB001WpBDw+ti6l9C?=
 =?us-ascii?Q?WRt9tPx1ItMjRN3djUooddZ+I8EYFcmjw0Duj4epUw+V0EpXlU/k2x/UlRmZ?=
 =?us-ascii?Q?U7bSOG2ozaO+FPwtDYruB7nzcOIrzlJ5D5yrTxZ0jwSkwGeBbkT8/sBGY7k5?=
 =?us-ascii?Q?quAuFjsg4bwCPkUfFBVRmyzqLF9SCZYCc2LxSDn51KUAzMJpxFKmjwBFUwu3?=
 =?us-ascii?Q?2dkS3vHPxDdcz5FXTBk6k3EFD0Hv6qhWxt6PNz8gtdlqYCmLGYzO6S9HYspn?=
 =?us-ascii?Q?r+ujqRysK6mKMjSrnh2D4rVHLFy80AWuywLFll9jXwxHGb8ghV3dfutyIFPq?=
 =?us-ascii?Q?2umXXNW3uUsqHvPj2WzTNB0frJfuXWTwvKyFndO9fRyBORHz832KzGgBfDvf?=
 =?us-ascii?Q?JqurWqmVwd3X6ag55VZ2gdFVgBkhW+6mNQpHkLkCaB51T8vcgqeMhKoHCtru?=
 =?us-ascii?Q?2QRGMx5QsMp/JTDbVFfYGufxjHNFc+eBB8WNOoSjPBvV1F1DLbkEPyPoLmaL?=
 =?us-ascii?Q?2t4MoXnNrMVy+MOM/eMvqp8q7qdowWlHNpCJ5uuoPAqJtNHLaCa0o7KNcmKY?=
 =?us-ascii?Q?0VONCGCGvBU13kBTRwJonESLVjP4DZZMLL98U5M1Td2kuECes/AocDGimqLa?=
 =?us-ascii?Q?hGkRskC3dVT2fkE9Jc5VYwUNDlKqPP4zeDWVek4EYCYJthGBg/GOO7a2AUrV?=
 =?us-ascii?Q?+b0FYbpVxFVejykNwfhuOFZJZGFOgGZV+cIQzVka6+Ja0UUTDf5pk3/EAo7g?=
 =?us-ascii?Q?UZlB7UOuAnYqu9bFXwVfMvvAJf1BZN2dGoFn2Bcdj7gfPLnV8i3W5LjKAdsi?=
 =?us-ascii?Q?NIREVpYuW+Lsz5+9sf534H4BOam4zuke6pIjCgXOIRyXnI1j0jlqnfFQwTRp?=
 =?us-ascii?Q?cJzvm0pBNlS/QEqSOI8Bo7m3R94UE0paf7+qqYSTxxEGb+nCkTL1ADOLDtpF?=
 =?us-ascii?Q?PzpMCGgHfg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec80d33-ad84-409b-6db9-08de903d44b7
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:23:15.5764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HOZ0wJQWCxYS0FSSvNphFMw0TDS/u3SgoHq1gXXE/Y/tROqgQgveVrj28pa1HwW7+msyLvn5RRf+lFoY8GfVxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB7844

Hi Jens, Keith, Christoph, Sagi, Michael,

I have decided to drive this series forward on behalf of Daniel Wagner, the
original author. This iteration addresses the outstanding architectural and
concurrency concerns raised during the previous review cycle, and the series
has been rebased on v7.0-rc5-509-g545475aebc2a.

Building upon prior iterations, this series introduces critical
architectural refinements to the mapping and affinity spreading algorithms
to guarantee thread safety and resilience against concurrent CPU-hotplug
operations. Previously, the block layer relied on a shared global static
mask (i.e., blk_hk_online_mask), which proved vulnerable to race conditions
during rapid hotplug events. This vulnerability was recently highlighted by
the kernel test robot, which encountered a NULL pointer dereference during
rcutorture (cpuhotplug) stress testing due to concurrent mask modification.

To resolve this, the architecture has been fundamentally hardened. The
global static state has been eradicated. Instead, the IRQ affinity core now
employs a newly introduced irq_spread_hk_filter(), which safely intersects
the natively calculated affinity mask with the HK_TYPE_IO_QUEUE mask.
Crucially, this is achieved using a local, hotplug-safe snapshot via
data_race(cpu_online_mask). This approach circumvents the hotplug lock
deadlocks previously identified by Thomas Gleixner, whilst explicitly
avoiding CONFIG_CPUMASK_OFFSTACK stack bloat hazards on high-core-count
systems. A robust fallback mechanism guarantees that should an interrupt
vector be assigned exclusively to isolated cores, it is safely re-routed to
the system's online housekeeping CPUs.

Furthermore, following rigorous testing of multiple queue maps (such as
NVMe poll queues) alongside isolated CPUs, this tenth iteration resolves a
critical page fault regression. The multi-queue mapping logic has been
corrected to strictly maintain absolute hardware queue indices, ensuring
faultless queue initialization and preventing out-of-bounds memory access.

Please let me know your thoughts.


Changes in v10:

 - Fixed a page fault regression encountered when initialising secondary
   queue maps (e.g., NVMe poll queues). Restored the qmap->queue_offset to
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

 - Linked to v9: https://lore.kernel.org/lkml/20260330221047.630206-1-atomlin@atomlin.com/

Changes in v9:

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

 - Linked to v8: https://lore.kernel.org/lkml/20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org/

Changes in v8:

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
   PCI_IRQ_AFFINITY and do not utilize nvme-fabrics

 - Removed the __free cleanup attribute usage for cpumask_var_t allocations
   due to compatibility issues

 - Updated the documentation to explicitly highlight the limitations
   surrounding CPU offlining

 - Collected accumulated Reviewed-by and Acked-by tags

 - Linked to v7: https://patch.msgid.link/20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org

Changes in v7:

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

 - Linked to v6: https://patch.msgid.link/20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org

Changes in v6:

 - Reintroduced the io_queue type for the isolcpus kernel parameter

 - Prevented the offlining of a housekeeping CPU if an isolated CPU is
   still present, upgrading this behavior from a simple warning to a hard
   restriction

 - Linked to v5: https://lore.kernel.org/r/20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org

Changes in v5:

 - Rebased the series onto the latest for-6.14/block branch.

 - Updated the documentation regarding the managed_irq parameters

 - Reworded the commit message for "blk-mq: issue warning when offlining
   hctx with online isolcpus" for better clarity

 - Split the input and output parameters in the patch "lib/group_cpus: let
   group_cpu_evenly return number of groups"

 - Dropped the patch "sched/isolation: document HK_TYPE housekeeping
   option"

 - Linked to v4: https://lore.kernel.org/r/20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org

Changes in v4:

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

 - Linked to v3: https://lore.kernel.org/r/20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de

Changes in v3:

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

 - Linked to v2: https://lore.kernel.org/r/20240627-isolcpus-io-queues-v2-0-26a32e3c4f75@suse.de

Changes in v2:

 - Updated the feature documentation for clarity and completeness

 - Split the blk/nvme-pci patch into smaller, logical commits

 - Dropped the HK_TYPE_IO_QUEUE macro in favor of reusing
   HK_TYPE_MANAGED_IRQ

 - Linked to v1: https://lore.kernel.org/r/20240621-isolcpus-io-queues-v1-0-8b169bf41083@suse.de


Aaron Tomlin (1):
  genirq/affinity: Restrict managed IRQ affinity to housekeeping CPUs

Daniel Wagner (12):
  scsi: aacraid: use block layer helpers to calculate num of queues
  lib/group_cpus: remove dead !SMP code
  lib/group_cpus: Add group_mask_cpus_evenly()
  genirq/affinity: Add cpumask to struct irq_affinity
  blk-mq: add blk_mq_{online|possible}_queue_affinity
  nvme-pci: use block layer helpers to constrain queue affinity
  scsi: Use block layer helpers to constrain queue affinity
  virtio: blk/scsi: use block layer helpers to constrain queue affinity
  isolation: Introduce io_queue isolcpus type
  blk-mq: use hk cpus only when isolcpus=io_queue is enabled
  blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
  docs: add io_queue flag to isolcpus

 .../admin-guide/kernel-parameters.txt         |  22 +-
 block/blk-mq-cpumap.c                         | 199 ++++++++++++++++--
 block/blk-mq.c                                |  42 ++++
 drivers/block/virtio_blk.c                    |   4 +-
 drivers/nvme/host/pci.c                       |   1 +
 drivers/scsi/aacraid/comminit.c               |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c        |   1 +
 drivers/scsi/megaraid/megaraid_sas_base.c     |   5 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c               |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c           |   5 +-
 drivers/scsi/pm8001/pm8001_init.c             |   1 +
 drivers/scsi/virtio_scsi.c                    |   5 +-
 include/linux/blk-mq.h                        |   2 +
 include/linux/group_cpus.h                    |   3 +
 include/linux/interrupt.h                     |  16 +-
 include/linux/sched/isolation.h               |   1 +
 kernel/irq/affinity.c                         |  38 +++-
 kernel/sched/isolation.c                      |   7 +
 lib/group_cpus.c                              |  65 ++++--
 19 files changed, 378 insertions(+), 48 deletions(-)


base-commit: 545475aebc2a2e8df14fadc911a7a2d03ddd6a1f
-- 
2.51.0

