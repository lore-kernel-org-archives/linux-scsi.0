Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022121.outbound.protection.outlook.com [52.101.96.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883653101D8;
	Thu, 16 Apr 2026 19:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776368295; cv=fail; b=u4HdW0/6j1THF8xq2rFtfLCueg3PQ/0e1IPEO8pqTmBuRo4KCL0rld9c8KRrbzRgSr4NsCAbstjNjnMRrDHmyPIQmGR+a3nN4of01rtOI7C6KTw3q/tn8YPdrp9xCDovY4avbgYOsxQXGI1Q+kHGA7tVRBUzrpqUJJYNcWABNAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776368295; c=relaxed/simple;
	bh=MVLXKhxUC+vkxHpEvcwWtKB/sDYvpYB5eN5bRYHNvbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ln6HikUehj9/qBY9htz/qt1Ix4FpUofCfwxPx/Ar47+322jVJFzonwC2reJ1rhMsLtgEl92pbG6XIIbDxctDew/QKZB3I4JpzNUr8nU2w1aCR2MK8FYlFpX7YTPmYI5+vStdkHduEb5+7036sUdWnA0ORF767MdXOLjNwBuO8dA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YRPYdDtBiie/TGuxl7mxZHH96wcE80FFEuz9x8Jzf8XTv4GC8TL3Hp/s8MCjx2S8q7pOBpP1+Andk7xnJq4KNZKKVrT7ETK5Hqaye4Ngpw0gPiJZvY0ZEsEYHzAFh4OxzRssq2q6COWgrupeZ8I6jRiFPkgO/KfzJL/wzNNWWYyUu5b6u4zh2HrxZTv8GJaOCrCQshXemjvmpM+lx6EtY6AXVs2XFLr5Ah10l+Ca36Ak7hexZofexdd0t3/KNkO/8uw+yNm1xd5s5PDGKPqUfBw3ONFMKbDoP0xYHSCUs7s6KX/ErtUUUwUnY5C0ifdan5H49rSHN0P2F37ENy82qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o/exWZvWADB22UDBgMAH8zKYzLyPy18ulYQKotwGNU0=;
 b=xnaAi+bnApsr729Eley9+jWYCvt9BijK2ERjj5Sb+Jf1lmtMQvqEiq7YoxKCRojuI7s1PmtrrYhxLQpk+lpKSvyRFsjA0ZRegiR8iQrTCW3p+zwCD2NET+87qkf83cIXtkFpc8t2x7d9ntP+0qO2aiPdjQwQjuulW5dD/mzwKVvBnxUY0ZKVHdyq/JLqBetwE26KxcpS6LPZPLVtUPT1YP8mwUQbsEZPeoSlEt/vJzYlNvtRfhzADHXmc5XL6CkrcnwT+6XFwfqE5xKP6Tjp/5lwJ3npUjUTn0A1sKJOgnVMdZ69F+GfTHqWSpl4AXDNyw26QItZ/Pmfnp7yuf9wpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB6494.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:188::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:38:09 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:38:09 +0000
Date: Thu, 16 Apr 2026 15:38:06 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, 
	mst@redhat.com
Cc: aacraid@microsemi.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, liyihang9@h-partners.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, 
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com, 
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com, 
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org, 
	longman@redhat.com, chenridong@huawei.com, hare@suse.de, kch@nvidia.com, 
	ming.lei@redhat.com, tom.leiming@gmail.com, steve@abita.co, sean@ashe.io, 
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com, nick.lange@gmail.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, 
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v11 00/13] blk: honor isolcpus configuration
Message-ID: <rfhc3k7olt3ehtlp7uanwxw25lf2i6u4xkreu4fugt2c5bbmqs@iaufp7biyw4c>
References: <20260416192942.1243421-1-atomlin@atomlin.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260416192942.1243421-1-atomlin@atomlin.com>
X-ClientProxiedBy: BL0PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:91::35) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: b74171c0-5445-4605-e811-08de9befb0b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	FUg1DIBL55NmLLOU6HftQJCkbX1TEn+bh2MBPGXTMf2nnEbdTLmfG4c9nalBltD/J8nnyFXLpGIYy3+jurU4lfis6Dx5ZbUUhh7JcsYR089nkJrLzuRVxtvcaLSEgxoeLiT79rXfuuSS6ZJk39Xm/PaajMk6aFT2REByHmVdFQodgiiq79nvPxn2Hz/4IetcdPEgSSO3+xg6i9unWOvXP7c6ETMOLzHo9VSATuPbyjQDMlq+LO7KlrkTX0yXEmhIijkhPAmXDU8EE7C/bbAavWXsOpxB5YRkeGSUujTSUDOT5SsvZjA1aVTSntL4pQdoT54AQ0Dmf+yG37a3hTUFM2hyKc4Q19OoOzsE2Ewqnd+nHGDLfazMJD9C7nfqUHU9VOr/QZXIf9BwT9/BJYYzW3+4KCJrp8cOqzNiuRF/rdlhr3rA7EakjA7trxlvOwz4DnGOdI+jCTMRqpZnihebfdiXxLCNYd0kbjKtXsevi0Y4cBlhL/bDxB1UWS6pvd3i0MviBvDq08kn3RW4or2BPIxywe1qWzMofUbHYbkmFp2USjd1NgKGkPvCvDsIE5MSHo+Zkka5+ihmaaXtH8GkGP4Wtj1UJDZqav1PozAzMg6lonFGRFc8z9sV9n9YB46Y5uU8HQvzuBM80BQLvizB5lMlF3iUXvy/rq844u7071r5NuWe1KVMr4G3tPzRoQXn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TE1FYUQ3bHJwTGtLU2s2aHBNT1FFdkY1Ni9KM3p2ZEtnUi9XWTV5MWVlM1kv?=
 =?utf-8?B?L2hjamdHc3Y1bDJrOEhqZDBPQlVrbG9iRmZuek9kQndyWDJweit6MFZvVTJH?=
 =?utf-8?B?SGRLUDYwSEhZYmw0VUtOWXpSK2FzVFVUV2V5S0paanFZM0c0Vk1QSXVMaE90?=
 =?utf-8?B?c0xCOTFjVjZqQjQ1eFBMYnBkUVFoMFB1Y3ptUGdvTEtGOGdQMVljSWhJbGxJ?=
 =?utf-8?B?OUpVdWlSUjRyV3o5UHlPNHd0YmtkL201ekJGcUJkOStwRkVGMTZkT1c4ZXB2?=
 =?utf-8?B?SFlnbFd2dW9mUmRmVStPRGFyM3c4V0Y5eXE4eE41THNNcE1Mb3VKeTJQMG8z?=
 =?utf-8?B?aVVCVmhYQy95V0xadlVwZmZDUFlEU2dWbmJ3TW9sUTBGdnFEd2F1dk5zbkt4?=
 =?utf-8?B?Z2FUVVNHa0ZWclJQTzNXbW5RWWNqK0I2WVZYT1RydzNmYVhTZytHQ1M3ZjJY?=
 =?utf-8?B?SzhCWDVKcmRXcm9Lb0g1TWtDYTdGUVA5Vy9ndElIdGZXUDVzWXI0Q2JscVVJ?=
 =?utf-8?B?cWEycDNkVzdtV0hiZjhvU1lhWTlldG1RUmM2L1ZJZ01xZDNVdVhUc2tuQk9z?=
 =?utf-8?B?Q3M1c1hVa0VXQVNvQXhVWUVxdlEyUUxIVTMzZ0pHT3dvOWwyUktwYWRhZENt?=
 =?utf-8?B?a2NkK2YzS3dBanpvQ1JlYVBVN2hobFp3NW9lbHZESnlDaWw0UW9kMUFuNmRo?=
 =?utf-8?B?ZWk3QWYveEM0OTk2eWpzbDRpRkxRNlBaQW14M2Jrei9uT1JQTlBFczhRYzZ4?=
 =?utf-8?B?elpCMUpWeEpxRVpFako0N3F3U2gzS1J3NXAxanpLdVZSMDFuUnNZTnVwdUhh?=
 =?utf-8?B?VTEvRVRJK1FpSC9LU1h2aTV6WldNYUZ5ckhIdkdZNXcrOVU2TWdaVVUzMUhP?=
 =?utf-8?B?WFREUENhYmNwZVMvVUVaQmZIdUFhWGliLzdXaXNjUFlVZmhrWnNXZnNaNzI0?=
 =?utf-8?B?eEEzTmdjSGpSekpvK3d6M2I1RG5nTlNsb2hiKzAzeGlSakJLbC9FMFpQN1RS?=
 =?utf-8?B?Q21PSjlpNEV1aUt3WmhqcU9lS2RWeE5KK0lqNUJtSi9KK3pVQWVqclpWSE9i?=
 =?utf-8?B?Y0JzejNFSmU0dGoyUkEwMUFkMUtJa01SK25NWS95QjF6SWppeTg3RXdPNGxE?=
 =?utf-8?B?SEhvMHUvYWJGck5sTWFQamYwYXR3SVJIZU1ZV3g0UVU3M0wyNjErS0JqTVFa?=
 =?utf-8?B?a2trVWVDdVpoZGg5bk1lOTQ4a1NGdUdNNGUwNGVUUUU2THpkQ3Jpem1HcTBM?=
 =?utf-8?B?RVVPZkFoVUZmSnNWeEhjTWJnWTU2dGlPam0xdFZwVEE4Uld5b254UytKUW5q?=
 =?utf-8?B?SWFzYzFLSVIza2ZLUkpMRm5yVGVtZm5nWmY3aFIrTkRuMmJPQWhRbVNrN1g4?=
 =?utf-8?B?d043c2t1WFpZY2VhcExPZnZZYkFwRk1WVUZ2bGlvT2tsRk1qL2lPZktCRFpG?=
 =?utf-8?B?Qm8rRjhpR0UwU1lnVHJiYkxwdU9FRWJHRk1rK1hiYmtDNnQxWjVFR2lRWnFr?=
 =?utf-8?B?akcwYUl3d0ZhYmsvR05kUktPdWZaOFJ0NWxVQnFLQnJYNVB2b3BGSTFydDEz?=
 =?utf-8?B?dXAxUlFSTE5yb0lpMU1ua3hZblFRd2xndzN4ZXlRRGtuTi9KYkNYdDcvRkZL?=
 =?utf-8?B?RU9lUXdaOFJTUlBNc0pPTFUvQzIzRmtMdUdWMjMzQTMwZG91R2xWWk9GWkdJ?=
 =?utf-8?B?Vi9nMStaTTZUclI0OGtTWUJsWmVCRE05YkVNbEVZNFdsZzgzOVhlTGVWOXJU?=
 =?utf-8?B?ZGVwSXFRTGsyMk1tWGtJalhNV1JwTDJ4TVR3dWR0SGUyaFEvSXlYcWdOSlor?=
 =?utf-8?B?WE1mNFMvRkZ6OE1LdFVxcE5SMXNkZm5rdjM3aWtyRjkzdHNqalJxb001RjV0?=
 =?utf-8?B?OXg3QTcwRHFKK1V6eEJmVyttOTQySjFaNUsvZFRCaitsRTBXdmI4RzRtRlFM?=
 =?utf-8?B?NzBjaDZXdGt5bDhmeFc2ZW82TDhEMS9OMi8vQmNETjNHM1RrR05HTFNwSHJG?=
 =?utf-8?B?Q1dFdUpKdGgrb285UWVoeHFOQWo1Qmp2VWxIZDNGV0RhQU1nVkp6aUVTT21N?=
 =?utf-8?B?YTNDNGlWQnBCa0k4a0kzVUNOd080cVBXTjliamtVQ3QvWUdRMlBHaDhUdmw4?=
 =?utf-8?B?cng0elQ0RlVlczdsUmZ4OVVURlJ1WjZlcnkvMExsMlZTb25jRzBqZm8rMlkz?=
 =?utf-8?B?Tzl5dStOcWNBeW9nQm9RNUp5RkFUM2YvblJsbSs1OE43YVdDR3RUL2tEdVJI?=
 =?utf-8?B?VzBMVkdUdGVHTm95VnR6dkJxanJXbW1ITUZBbEZ4eERRQ1NNT2p3cmRCS250?=
 =?utf-8?B?VllVbTRoMTJJQzV4dGR4MzFicjVYekpHTytOTndXVjdzSTJncEJMdz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74171c0-5445-4605-e811-08de9befb0b5
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:38:09.8705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zyZ0DEG/ifnkp4qz/+QX1evN6Wj751DzAGlNJpxyoWre4esKIZoBmrATRfM/mLf5lb3dONkBESgtgTZSVD54yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB6494

On Thu, Apr 16, 2026 at 03:29:29PM -0400, Aaron Tomlin wrote:
> Please let me know your thoughts.

My apologies, I neglected to include the changelog.

Changes in v11:

 - Completely rewrote the isolcpus=io_queue documentation in
   Documentation/admin-guide/kernel-parameters.txt to clarify its exclusive
   application to managed IRQs, queue allocation limits, vector exhaustion
   prevention, and hardware interrupt routing (Ming Lei)

 - Fixed a stack frame bloat issue by avoiding the on-stack declaration of
   struct cpumask (Waiman Long)

 - Linked to v10: https://lore.kernel.org/linux-nvme/20260401222312.772334-1-atomlin@atomlin.com/

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

> 
> Aaron Tomlin (1):
>   genirq/affinity: Restrict managed IRQ affinity to housekeeping CPUs
> 
> Daniel Wagner (12):
>   scsi: aacraid: use block layer helpers to calculate num of queues
>   lib/group_cpus: remove dead !SMP code
>   lib/group_cpus: Add group_mask_cpus_evenly()
>   genirq/affinity: Add cpumask to struct irq_affinity
>   blk-mq: add blk_mq_{online|possible}_queue_affinity
>   nvme-pci: use block layer helpers to constrain queue affinity
>   scsi: Use block layer helpers to constrain queue affinity
>   virtio: blk/scsi: use block layer helpers to constrain queue affinity
>   isolation: Introduce io_queue isolcpus type
>   blk-mq: use hk cpus only when isolcpus=io_queue is enabled
>   blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
>   docs: add io_queue flag to isolcpus
> 
>  .../admin-guide/kernel-parameters.txt         |  30 ++-
>  block/blk-mq-cpumap.c                         | 192 ++++++++++++++++--
>  block/blk-mq.c                                |  42 ++++
>  drivers/block/virtio_blk.c                    |   4 +-
>  drivers/nvme/host/pci.c                       |   1 +
>  drivers/scsi/aacraid/comminit.c               |   3 +-
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c        |   1 +
>  drivers/scsi/megaraid/megaraid_sas_base.c     |   5 +-
>  drivers/scsi/mpi3mr/mpi3mr_fw.c               |   6 +-
>  drivers/scsi/mpt3sas/mpt3sas_base.c           |   5 +-
>  drivers/scsi/pm8001/pm8001_init.c             |   1 +
>  drivers/scsi/virtio_scsi.c                    |   5 +-
>  include/linux/blk-mq.h                        |   2 +
>  include/linux/group_cpus.h                    |   3 +
>  include/linux/interrupt.h                     |  16 +-
>  include/linux/sched/isolation.h               |   1 +
>  kernel/irq/affinity.c                         |  38 +++-
>  kernel/sched/isolation.c                      |   7 +
>  lib/group_cpus.c                              |  65 ++++--
>  19 files changed, 379 insertions(+), 48 deletions(-)
> 
> 
> base-commit: 3cd8b194bf3428dfa53120fee47e827a7c495815
> -- 
> 2.51.0
> 

-- 
Aaron Tomlin
