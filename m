Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021116.outbound.protection.outlook.com [52.101.95.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB86037FF55;
	Mon, 30 Mar 2026 22:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908657; cv=fail; b=ejIBzZLu/nba9UqKPf2Uz4RYU+P22zfrQr7BzqhMieBskH1V96Y0Z2HbQnkUnEabmmNh0y0Y1f/lk8Y2t0dvVCmM5IyD6zxTtsM6zvUSaOCpVGozy0jF4wbrd6EfzCxKxLKeeFv91rpFvLd6zQJC+KV3pI6VtsXGso7gDRL3LnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908657; c=relaxed/simple;
	bh=DMJFiBTKtddWBlgaxaUsCu4b7LqkrVTrfb6QhIPXUgE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pZCcYts3jcaEPLdyQ2Oqp0qIGgnC+Mnz5fUOe1ii2KrfXVl/0b4zQ7HV7meeCrzpWOFfJEBCuShs0U5MUzUgsGfVQs5lxmguEY7Aq3gkN6rwr8jBKJPd/a75+3roTdOaN3FxahUcUAc9KKHxBq8m5H+I0s+nXnQe5CCOgTsYElI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qw1K5OrtND//2Pjssr28cmOrWAo9Nriv+W7ArCuGfchTzUi+7vG7hW8tPCzn1WCMsU3Wnff2jw7JkY4GB3tG89KRmOPyL4OfK1ff20rexU609VsBLwO4gLOMy6vXh27crDYMYQRxz+kR2yWacZI1Tx6pimlHqOtMeincteZA/hvmzxBF05oAQQMZ3Xm2iSVeQnJRgdn4TCTosmge8kRI3FY0q1GffRH/E/PZb4247y2NyniKYbFHkV+utQWK6EgIdpIcci80VDxpV/pQPUxNEXtoJwUZKJprU07e62TvHfsS4l3rIWPcZ/MVzSPbNo2096byojAL9zxlhb/DN1mkaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xJtbUfW2Fe0OQJhgqS4E/F7ql25rZ2tG3fGDEQHq4I=;
 b=gusAxLOY4dxKNZ9jVpoJv69yhSY+LYLY6I9Koagc9BgGw+Cpro+QJ9hqSh8SoEB8q9YKBMbco+0hRjp7YU++EQOZnBTBCleZZirxKFcAsfQDn32IXS6k3vKuQ3zGIHl/9RA9FkjGG/3gArbEAfEY8iXZoIH/+lBdSwdlVriYNXKkvNcBEsGu4uO+qSOV6WS9TyfGW6GIcvT6rCjvrOq3T5duRtY3Wa7y91DL/tIFrnBegM3pEQRNiKpg/XrlZ3L6hjR0jiqPNtho/gHUS541G6qt2eLWBhEYkAsEMjqViUfgxPATEh4U+OsllxDQ01yFeJjQ6ryeIb1NCLFoyT2QSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB6512.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:186::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 22:10:50 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Mon, 30 Mar 2026
 22:10:50 +0000
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
Subject: [PATCH v9 00/13] blk: honor isolcpus configuration
Date: Mon, 30 Mar 2026 18:10:34 -0400
Message-ID: <20260330221047.630206-1-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0049.namprd03.prod.outlook.com
 (2603:10b6:408:fb::24) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: 91e521d6-fee4-4f50-985a-08de8ea933d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xMt6uD6uTU+T+PGzOMSu8rSxpt4BdwGaQjJ4SxVe4TKdGLzxqb7gc4pvH903ozALFxf+zzO6rKRHnZb1gUoDGWNluQMXNhU43dHDXvL8VmDK86P2TbD992qBSB9DZ8fcUe1XEHAeWME6nI5iSdob8EC0TL0b99aVvBno9L4eeEbq0mg63ntSG4KFzd0TXE9/BJaFvF7hUY+W3UA3dQYjZAVIa3wpKe3m4Nd+kKLOik33MGmAEkplZOrAGJrt6gBfRnsNE//DLw9b+lFceyzrmr2fsG/hI6Uo7QWxk7fticYb2utWFrVvmm6Oo5i5bfaL6u8NXjesnPEHIh54Bmzf68/766ORkqTEQzFJFRQ/5HjC6WaO4GvhCLR8XWUKv0r1IMx5hUmseHpHf/nOloGnXD1kz2233rxzl/AQ1hooaWIzmOAPda2zwh6+ClRpQn59VoZB/28QBDpRA3y4O20k3WY+vRoxUwxATKtp82G8Bzcebi6Ctk1hwP15nCfhEkGNYHb5aaDywarsS/QS3Dt1u6JprwqIZ8hzUCTNCUASiP81kPaWUAPoOmQf/pE/Q1uO4K6/rcFQwS9ItHrs/aqniDTK3Rif3aQNs+ae6QDCSuSluWGILLRq/AAzLqtC24rtEcZYw1DFlJIIiJAAxzRFYyBSBtVg35iA4FnIDjHqngijzMMp2uP/L3r9vOZH7br/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E+DIgTesYfyv2wVDhT4cs8r7FJIPNvtIrz7WEYqutdYmr0ZJlZT14V2SkRdJ?=
 =?us-ascii?Q?b98TaP12A0s6JJ7ed+kbJaQW89hH3V0F8fuBljaiW48xf1c+60XgEUdraU4s?=
 =?us-ascii?Q?o/M+xHZFzIULlukXs36dDvNcF6XUhWoAm+PW48aZ6r25NXNbZ6FrtRrT6lGF?=
 =?us-ascii?Q?rB46n/fx6t35Q5VRuDqxnhXB6NJX+QEB/mDHIUpFNBjICAaWVEI2ZFlNo/fp?=
 =?us-ascii?Q?FI6zLUN8n7ZazUfLNTaAKAceWoEj7W1KXxPDOMrEEdi8YA3Ya99QRhIN47+t?=
 =?us-ascii?Q?gbJy/7dGi5tInerkVsnkdt6fMsAdpYaSWg08lglkmFK6G3ANdttzA2XkscU6?=
 =?us-ascii?Q?FjEiFGEZ/GXKYnPRDBwhX3pAXFvQvNsX+c6CaO855x708PaJh6oWyXl+xaJI?=
 =?us-ascii?Q?oJhjqZnjJzkceMcULfecbiSA14C99LxNGtZ7tGuv6erEWh84fJzN5CEZoqig?=
 =?us-ascii?Q?Fdt9vhfdlPUjOyFyW7Pgmjivu1aGp94IQ+9uso6Z4NQEi6hfl3AHfznGpRUJ?=
 =?us-ascii?Q?yZNsTalIzP8j5GIitzqCQMDGkZXoKUnhGdMl1c6GykNlUOD/WPUzkt5+onFs?=
 =?us-ascii?Q?5+Mv1MAQxb4BHJ7VAMD0rDX0mswOF0bJdtE6/IE9tC7CEbHrWqVU61eDgTvp?=
 =?us-ascii?Q?DmIDG/fr/ZkzxKAX42drXi4KHjHJ8snMOoX3rHCVN97kJXj5HQPAnaQzCYBQ?=
 =?us-ascii?Q?7YN6di/Gz1gopLNo8w3CXS+76qUqWauCJhUBgKxKKUnPL2Au0QpJsCPMa/XC?=
 =?us-ascii?Q?qEcukCb0Nrk7F8xBETVdaltgC7baZztQ6UzKsf02kKM1MJ+LieyLMOgAEjH5?=
 =?us-ascii?Q?BxHFpl73q+JLMcLxY/3QwCZ/tde/L3zZTcl8RuUsvLiX3FAHy+oy7tI+vNOu?=
 =?us-ascii?Q?hAWVJXFXJi3UraEVOh0NeBpjvjzN4wCNGgcTW0p0uoQL4PsdAQ7MTRZ9dUcZ?=
 =?us-ascii?Q?qvsngwdXy40chBU4uuuO0D4a6hDh9rr7gw8cRf55XDVirYzUEBwprI04GjLf?=
 =?us-ascii?Q?zQ8T8LPeAlpPLiC9CkqUFLnmqW48QT9uXJThtlB09WWZKaFXgO8sxcj3XdqL?=
 =?us-ascii?Q?0b6gwW0CDLo7GDyb3743gy4uRoKYBLZJXUz94eMiDMC7F3X7mCUjn/DrChDa?=
 =?us-ascii?Q?oO11FbC1ebn8zqzM7RFf6NuZHk4ZbAB1PPytfO1k3kR4SbUAwbhC7CdEHuyv?=
 =?us-ascii?Q?S8v0qOIiI7ZpNFcKANimGFLP+J1eZ4XWsqmpOM0BtU6+QZIlYda6KtO1l65R?=
 =?us-ascii?Q?3frYTvmQ06hTRsHTsP1PhEBmtteRgw0211A8lbUgBWpX9WIIRLRCfDOueds4?=
 =?us-ascii?Q?bYLGtfrG/rOPoWdN3kx9B7+QzgpMNR3E77GwtiLKV7Gx59os3tQdFfu6Lc8z?=
 =?us-ascii?Q?XwW4DW8ZG0kLCtARmot+6eES13lkg82etdIK6kssDHN4vEQfds9zFI5aH4ki?=
 =?us-ascii?Q?1OdNapEy6f7dDays9MdheSGyQRjuOcAoL1w4ISMd/ANXuv1QDBJuicHrlK06?=
 =?us-ascii?Q?hWwOBZVsBfbZd/YuF6jJyfak6q1JcwXEbrf5SmGu6LSL4nmXFyFANCpZTj2V?=
 =?us-ascii?Q?QXMmi/ubdg3WFyRrNmDcNlfD0LNPa2NfGLMxp+C4TIpMP1Hkg/WxE5GfesVA?=
 =?us-ascii?Q?XBj6H1PnQWBrWFOfZ7s89j9KJn/UBKMSNekj3ZM7UpiC+AqEDZ5m8kYQOXRO?=
 =?us-ascii?Q?HKxhaazXyPmvb66yS+7QOeOiKLsH512yu2FbcCeDJxsrTXBO9b5i0Rw70Ylx?=
 =?us-ascii?Q?1ocC2vWMew=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e521d6-fee4-4f50-985a-08de8ea933d6
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:10:50.5850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hEX5+no/N11wtDhCLdCgPVl/HqP8eT7qlZg96GYx4hF22cWd7SUvAXEDCnFKqyj45g/aVUFPX8wfMGNv+Lekg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB6512

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

Please let me know your thoughts.


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
 block/blk-mq-cpumap.c                         | 201 ++++++++++++++++--
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
 19 files changed, 379 insertions(+), 49 deletions(-)


base-commit: 545475aebc2a2e8df14fadc911a7a2d03ddd6a1f
-- 
2.51.0

