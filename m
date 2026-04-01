Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020139.outbound.protection.outlook.com [52.101.196.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA318386C27;
	Wed,  1 Apr 2026 22:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082268; cv=fail; b=b5aOD2DNma9R+mzq4nzYXiHmWcQn5iA8Namy5+zDuCgjpW4wd4ghFOt8DKmfQ74rUnd06F7KR5EdP/iOn0XpMMZITtF0rR1yaaL+C4xziLBuIBd5dDb1SqP2i/kgjRYIOrgFJU9tdu64MF7LUl+wQ6SxPWw8nVsHMqd9T7EfA2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082268; c=relaxed/simple;
	bh=gTbNx6/nKqiSAJhA5Fs7DTbUbsxwfEfT6wz/VxIovjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mYqQvqmhu5CrvRqBd421j9PHb55ioRfJN/903h0aoUzkYvEk+0hiPp8nuaKeShxyhgs3H1QMMAVmV03GxR/BNk069gJtoCrbjllM7ko7BfF/wOXTJIDSTcSUoXchC7yS5WbrXyTIIMHQmTO6enyGhVgn53JCcjNqySznnLzrDog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pY/B7gPx6WFgStw0rvD5xY44fFoY65xCqK4u9NOwHEgj3wuINLjryR2dG1wV55JVgl7Bapnnnk1ohp6lWWLXDdB6w3XtKGWZ+q5DW3a3XxU9KaivrbtdkwQGjFo0mMxVko7Qx+ORtUuKK96qRBZCSSCxnJdU1LkALb/Kwtfd6ELBhljfCH4UIBV4vH4wPoy7xTdhGvmerCRNJEJz5S9zISOEoUaB+Ls8IsXTpmxKxmGAhOP0j4vMcJl0kzzt2/Mon4KPAbjkp6ZOmY5O85JZkaUVyEiM5333p7liRSogzt4Yvw7xpjIIp4dST7ES1YSKdeIieS9G6lOl8whGz281fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZwpGHYTL8CuoviinY1Qr6yt8QNMpfqx362ii5+o5MI=;
 b=frR67NRixZsW7Jq81tsjD49gDYs8tNCofJSR/bati++v5ZGky3CgQ4/RV05r2jqPutUCUQdMKzpJVlVNYlCP0RoEs7q9Hg+F2jJH9dUzUaXkSmqGphYmm6zetXJLp6kEgIIhPOxsYJFXf4t0WR414yX5XAdORLBKWfmR10IWqIXPmZ402fO3+u9MKmePaFXrx0Cvspi6Rxk4tjihr0tH9Ckglpn7a2LjCF+tIxugcdJ+5zavE2NnicKBtrgucpERc2y4icetNlVnUW7zjq9X/nth3nno4LS1NGy1VNisLJYCgCtg9wDGBSBXFpZ4h1QHyf67W6MTm3RJYBhBntA14A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB2964.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:58::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.24; Wed, 1 Apr
 2026 22:23:51 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:23:51 +0000
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
Subject: [PATCH v10 10/13] blk-mq: use hk cpus only when isolcpus=io_queue is enabled
Date: Wed,  1 Apr 2026 18:23:09 -0400
Message-ID: <20260401222312.772334-11-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260401222312.772334-1-atomlin@atomlin.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:408:ee::23) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB2964:EE_
X-MS-Office365-Filtering-Correlation-Id: a359462e-041f-4458-0515-08de903d5a0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kTYcTP5aLvdAj2qkr8fmiKkoWgy+QA+tOHCZ6j52M4A9hUH/WXONQt8quw16RhNgpG5SyeOlNbCXa/8e2jElUY+xCcLO2XLjZ5ACJgxW5PHfv1rUpS1BPJilAl2xVniPu2L+poyEoFML8E71SCRI2ZIq6/q/GXJb19OvKsMPbRCJRHxeqVG9qDrSaOw+rzLmplMcdED1eKZg8Ck+M1cIU9afnHoFbUWJdA3lIaPAk/v8qdj0yr+JGbSFWoi6uw1QnbblO7B3T2UDuxfcxjVTQ7az9PXTgyqN8qqGJcPQ/0N4HTR+rAeKPr/D7ahmj89L3z8R6eG8dCqlRGupIoEMdy3/9qNombTKZHywI6OJWPxpbmSVWnXxd+p4ukkWEr6PvZrq4qGH6ZAEmACMv7QkTVNBAXQQQ6WNGb1Yd3YEzRX2ZxmC4XL56BMvpaRPbX7l4PeqEVJzZXhvf19Y7vnWQzkBXQpcZi4Y1Qu0TKLFZ58JvbLgEQDKKdT44Wbq774lYQ8MbG+MXWZDEO2MwGKgoxQlmE/PEYouFDiy8N0+DCRnfmSyP2RX3C15njIi1RI8fmha4X7ys3EBjG/lwfTLToKMmhfAgMau//m+A3BIXmtS0bcAjCyIgHV5U2he1x1ThmJebKn6l9AAgHyeeviTeDMGXqbYCJEjLzdQDUp96gMid8HYkRWhfaGxkhfh+VHZH8eleHz5Sp4TTytCVpzAqKeI3Dv7e3YKncaTz4yDPng=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DeLBn7K2PfobLXj/LULi9yR2nuh5Ig4xZN3P4Aex+1fYiU1aIZn0QaS5VsA8?=
 =?us-ascii?Q?x8CQDq7Wufo9Cc/7qYlhhF6ALqsYiR7kV1iZcXFCHUZZOyJ4FzGwJiQFTiiM?=
 =?us-ascii?Q?iAOICxgeJ7jqEAuoezfA4O62+QcW/MFTc0Iw9DuAG10P+s0xe5nc2LbjyW/g?=
 =?us-ascii?Q?9acyu0YAd6d0WXnaC0RR3buJn6Sy+sgbJ4oa5fC+UGiKdwejOaGU+XqZVKIt?=
 =?us-ascii?Q?F3l6MUDt/cGC+NZhM/IJ6dV69W/Lwp6MPOHjALTovY4C0NJF5RY+Z6Lm3ciS?=
 =?us-ascii?Q?she6s/mP1sS43lOekYmY4mKK5svqqKDsQ9zA9rb9z2P4fNWzJR5pf8oim6BX?=
 =?us-ascii?Q?yePQYj75d0gaEyT2+XyQo4zGb3KiSRABd829HaX/CfQDzVa0mqM43gIvUeFT?=
 =?us-ascii?Q?uObYzOija+aL2Mz+oKymdt6/clGQn7WiKVCy1Ddxl+7l9HRXRKoY+PBqOYZL?=
 =?us-ascii?Q?SfLGxwBl0NnRX7yieYczuDXhhg5JmIc5IEBHBouWXpX1lxB9nlH8Hw6QH/h7?=
 =?us-ascii?Q?1qNOp/Eygq+F83K63j3ZQUryas4r7OFeWDGEqHQlH8LUhTCFt/sa38+MD/V2?=
 =?us-ascii?Q?4QWbuiqoRS2voFKxbP31xPXD3jC8TxD+SsCexQBb9oj//elS+28gKUvSum4A?=
 =?us-ascii?Q?XMz3USszc2664QbkSbPY4oZaPAFyZ6dYSFWybY5qWZKkJ4Qlg6nMvPct3fS/?=
 =?us-ascii?Q?T9JacF/hKHi83D08ifkguQQBedYaYp9Sc0Y2GZJZ96RuJ4eBaJ+j/Il114wN?=
 =?us-ascii?Q?U5iiMFcxEyAUonkoo03PhdzOsEOa+Hs7IVkdVMmEOvxWs5csDNwR6izoXWQX?=
 =?us-ascii?Q?hlz1dwZz/XpIRDKHnOIMEfTNFn95khrOJVUWAcTS9LXybme36J7um+D8j0mY?=
 =?us-ascii?Q?Pt724kGUIqNSwujpPnKMDst0mJOEyqUKHL8m3z90oP9uSkFYes2l4S8d7Bt+?=
 =?us-ascii?Q?SDMnmX2lGLPg+XCIrdjvkuvH4Cr1BkhDQdKmJdaGEY3Lgea5LFqrRBzCk270?=
 =?us-ascii?Q?/ZbcrETnJX5fETajasznVPDVsfaMISISclrPTh0ZTUp40q7kIq4/tJ5RmtTL?=
 =?us-ascii?Q?P0P+/RgBlozYyp8LR4Mv6FcJNU+z49aUwqBF4euw4KHEQFzLnQousZFbmxrl?=
 =?us-ascii?Q?asgXm1id6eHe6xKGPZ6IKy6ELpu3ME64rctzqdprjn9UDJcQajSnGC6mzZae?=
 =?us-ascii?Q?YaEr2hy2ewLbfOsRvyryq4Aenq9tMOUljDD9M3FERj2OpiwtlscxTUiYez5X?=
 =?us-ascii?Q?4fjwwzetgqXCBm1kl/L3wVsfHoGdb25ei+Ybi/E6CCacPiS81PRiLtPIKwOd?=
 =?us-ascii?Q?cZhB0wPZi8gl7ZTbzcGzV2Yai+VByELXntrCXfDgLDwuiAkN0wkrMgZBDxQI?=
 =?us-ascii?Q?Q3Wa69wJEAhuQjwlcWCv0dj7EMbjgTJ4h2IbBFPCLo0awTEvjHbT1AZSrwfD?=
 =?us-ascii?Q?Kg2V8CVCcN2t7gIWfA8vUy7WxqRxdV2x+D/5riNr2AKnOzZbB3xM/IIvtwFO?=
 =?us-ascii?Q?0EP7Ga+hGF+XyGHUH+zH8Lq/0mD8H0hsY5u4evCtj9mUuyLoSA1o4REu/pHB?=
 =?us-ascii?Q?X5K+4OcMyqdqfyIGeU2Wy85IQebm6Q7vKkUDvQDR1GsW34WsdJB4IBRdNs/G?=
 =?us-ascii?Q?LsiFv8+5z1shBeYjVufLL7RJzDP2U/8Oh9JX9bMxV8nrFItFxb1v1TKuthCQ?=
 =?us-ascii?Q?OavJcKQhKyEzLiLTenZvPOP7TGx1s2Hbi6A+Ou7UR3UzRnG8NXs2oPha46tF?=
 =?us-ascii?Q?0PMCMZoZqg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a359462e-041f-4458-0515-08de903d5a0b
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:23:51.2856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DDy8xLdUTgsK7tNKFbTIhB11klXBvHwqshu8xBQ57ZTS+hercpEqSm+t9DBb0plznkfUbutjtJ7R11JqO4aSrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB2964

From: Daniel Wagner <wagi@kernel.org>

Extend the capabilities of the generic CPU to hardware queue (hctx)
mapping code, so it maps houskeeping CPUs and isolated CPUs to the
hardware queues evenly.

A hctx is only operational when there is at least one online
housekeeping CPU assigned (aka active_hctx). Thus, check the final
mapping that there is no hctx which has only offline housekeeing CPU and
online isolated CPUs.

Example mapping result:

  16 online CPUs

  isolcpus=io_queue,2-3,6-7,12-13

Queue mapping:
        hctx0: default 0 2
        hctx1: default 1 3
        hctx2: default 4 6
        hctx3: default 5 7
        hctx4: default 8 12
        hctx5: default 9 13
        hctx6: default 10
        hctx7: default 11
        hctx8: default 14
        hctx9: default 15

IRQ mapping:
        irq 42 affinity 0 effective 0  nvme0q0
        irq 43 affinity 0 effective 0  nvme0q1
        irq 44 affinity 1 effective 1  nvme0q2
        irq 45 affinity 4 effective 4  nvme0q3
        irq 46 affinity 5 effective 5  nvme0q4
        irq 47 affinity 8 effective 8  nvme0q5
        irq 48 affinity 9 effective 9  nvme0q6
        irq 49 affinity 10 effective 10  nvme0q7
        irq 50 affinity 11 effective 11  nvme0q8
        irq 51 affinity 14 effective 14  nvme0q9
        irq 52 affinity 15 effective 15  nvme0q10

A corner case is when the number of online CPUs and present CPUs
differ and the driver asks for less queues than online CPUs, e.g.

  8 online CPUs, 16 possible CPUs

  isolcpus=io_queue,2-3,6-7,12-13
  virtio_blk.num_request_queues=2

Queue mapping:
        hctx0: default 0 1 2 3 4 5 6 7 8 12 13
        hctx1: default 9 10 11 14 15

IRQ mapping
        irq 27 affinity 0 effective 0 virtio0-config
        irq 28 affinity 0-1,4-5,8 effective 5 virtio0-req.0
        irq 29 affinity 9-11,14-15 effective 0 virtio0-req.1

Noteworthy is that for the normal/default configuration (!isoclpus) the
mapping will change for systems which have non hyperthreading CPUs. The
main assignment loop will completely rely that group_mask_cpus_evenly to
do the right thing. The old code would distribute the CPUs linearly over
the hardware context:

queue mapping for /dev/nvme0n1
        hctx0: default 0 8
        hctx1: default 1 9
        hctx2: default 2 10
        hctx3: default 3 11
        hctx4: default 4 12
        hctx5: default 5 13
        hctx6: default 6 14
        hctx7: default 7 15

The assign each hardware context the map generated by the
group_mask_cpus_evenly function:

queue mapping for /dev/nvme0n1
        hctx0: default 0 1
        hctx1: default 2 3
        hctx2: default 4 5
        hctx3: default 6 7
        hctx4: default 8 9
        hctx5: default 10 11
        hctx6: default 12 13
        hctx7: default 14 15

In case of hyperthreading CPUs, the resulting map stays the same.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
[atomlin: Fixed absolute vs. relative hardware queue index mix-up in
 blk_mq_map_queues and validation checks; fixed typographical errors.]
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 block/blk-mq-cpumap.c | 175 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 157 insertions(+), 18 deletions(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 8244ecf87835..8d09af49a142 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -22,7 +22,18 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
 {
 	unsigned int num;
 
-	num = cpumask_weight(mask);
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
+		const struct cpumask *hk_mask;
+		struct cpumask avail_mask;
+
+		hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+		cpumask_and(&avail_mask, mask, hk_mask);
+
+		num = cpumask_weight(&avail_mask);
+	} else {
+		num = cpumask_weight(mask);
+	}
+
 	return min_not_zero(num, max_queues);
 }
 
@@ -31,9 +42,13 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
  *
  * Returns an affinity mask that represents the queue-to-CPU mapping
  * requested by the block layer based on possible CPUs.
+ * This helper takes isolcpus settings into account.
  */
 const struct cpumask *blk_mq_possible_queue_affinity(void)
 {
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		return housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+
 	return cpu_possible_mask;
 }
 EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
@@ -46,6 +61,14 @@ EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
  */
 const struct cpumask *blk_mq_online_queue_affinity(void)
 {
+	/*
+	 * Return the stable housekeeping mask if enabled. Callers (e.g.,
+	 * the IRQ affinity core) are responsible for safely intersecting
+	 * this with a local snapshot of the online mask.
+	 */
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		return housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+
 	return cpu_online_mask;
 }
 EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
@@ -57,7 +80,8 @@ EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
  *		ignored.
  *
  * Calculates the number of queues to be used for a multiqueue
- * device based on the number of possible CPUs.
+ * device based on the number of possible CPUs. This helper
+ * takes isolcpus settings into account.
  */
 unsigned int blk_mq_num_possible_queues(unsigned int max_queues)
 {
@@ -72,7 +96,8 @@ EXPORT_SYMBOL_GPL(blk_mq_num_possible_queues);
  *		ignored.
  *
  * Calculates the number of queues to be used for a multiqueue
- * device based on the number of online CPUs.
+ * device based on the number of online CPUs. This helper
+ * takes isolcpus settings into account.
  */
 unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 {
@@ -80,23 +105,104 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 }
 EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
 
+static bool blk_mq_validate(struct blk_mq_queue_map *qmap,
+			    const struct cpumask *active_hctx)
+{
+	/*
+	 * Verify if the mapping is usable when housekeeping
+	 * configuration is enabled
+	 */
+
+	for (int queue = 0; queue < qmap->nr_queues; queue++) {
+		int cpu;
+
+		if (cpumask_test_cpu(queue, active_hctx)) {
+			/*
+			 * This hctx has at least one online CPU thus it
+			 * is able to serve any assigned isolated CPU.
+			 */
+			continue;
+		}
+
+		/*
+		 * There is no housekeeping online CPU for this hctx, all
+		 * good as long as all non-housekeeping CPUs are also
+		 * offline.
+		 */
+		for_each_online_cpu(cpu) {
+			if (qmap->mq_map[cpu] != qmap->queue_offset + queue)
+				continue;
+
+			pr_warn("Unable to create a usable CPU-to-queue mapping with the given constraints\n");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static void blk_mq_map_fallback(struct blk_mq_queue_map *qmap)
+{
+	unsigned int cpu;
+
+	/*
+	 * Map all CPUs to the first hctx to ensure at least one online
+	 * CPU is serving it.
+	 */
+	for_each_possible_cpu(cpu)
+		qmap->mq_map[cpu] = 0;
+}
+
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
 {
-	const struct cpumask *masks;
+	struct cpumask *masks __free(kfree) = NULL;
+	const struct cpumask *constraint;
 	unsigned int queue, cpu, nr_masks;
+	cpumask_var_t active_hctx;
 
-	masks = group_cpus_evenly(qmap->nr_queues, &nr_masks);
-	if (!masks) {
-		for_each_possible_cpu(cpu)
-			qmap->mq_map[cpu] = qmap->queue_offset;
-		return;
-	}
+	if (!zalloc_cpumask_var(&active_hctx, GFP_KERNEL))
+		goto fallback;
+
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		constraint = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+	else
+		constraint = cpu_possible_mask;
+
+	/* Map CPUs to the hardware contexts (hctx) */
+	masks = group_mask_cpus_evenly(qmap->nr_queues, constraint, &nr_masks);
+	if (!masks)
+		goto free_fallback;
 
 	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		for_each_cpu(cpu, &masks[queue % nr_masks])
+		unsigned int idx = (qmap->queue_offset + queue) % nr_masks;
+
+		for_each_cpu(cpu, &masks[idx]) {
 			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+
+			if (cpu_online(cpu))
+				cpumask_set_cpu(queue, active_hctx);
+		}
+	}
+
+	/* Map any unassigned CPU evenly to the hardware contexts (hctx) */
+	queue = cpumask_first(active_hctx);
+	for_each_cpu_andnot(cpu, cpu_possible_mask, constraint) {
+		qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		queue = cpumask_next_wrap(queue, active_hctx);
 	}
-	kfree(masks);
+
+	if (!blk_mq_validate(qmap, active_hctx))
+		goto free_fallback;
+
+	free_cpumask_var(active_hctx);
+
+	return;
+
+free_fallback:
+	free_cpumask_var(active_hctx);
+
+fallback:
+	blk_mq_map_fallback(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_map_queues);
 
@@ -133,24 +239,57 @@ void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
 			  struct device *dev, unsigned int offset)
 
 {
-	const struct cpumask *mask;
+	cpumask_var_t active_hctx, mask;
 	unsigned int queue, cpu;
 
 	if (!dev->bus->irq_get_affinity)
 		goto fallback;
 
+	if (!zalloc_cpumask_var(&active_hctx, GFP_KERNEL))
+		goto fallback;
+
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
+		free_cpumask_var(active_hctx);
+		goto fallback;
+	}
+
+	/* Map CPUs to the hardware contexts (hctx) */
 	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		mask = dev->bus->irq_get_affinity(dev, queue + offset);
-		if (!mask)
-			goto fallback;
+		const struct cpumask *affinity_mask;
+
+		affinity_mask = dev->bus->irq_get_affinity(dev, offset + queue);
+		if (!affinity_mask)
+			goto free_fallback;
 
-		for_each_cpu(cpu, mask)
+		for_each_cpu(cpu, affinity_mask) {
 			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+
+			cpumask_set_cpu(cpu, mask);
+			if (cpu_online(cpu))
+				cpumask_set_cpu(queue, active_hctx);
+		}
 	}
 
+	/* Map any unassigned CPU evenly to the hardware contexts (hctx) */
+	queue = cpumask_first(active_hctx);
+	for_each_cpu_andnot(cpu, cpu_possible_mask, mask) {
+		qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		queue = cpumask_next_wrap(queue, active_hctx);
+	}
+
+	if (!blk_mq_validate(qmap, active_hctx))
+		goto free_fallback;
+
+	free_cpumask_var(active_hctx);
+	free_cpumask_var(mask);
+
 	return;
 
+free_fallback:
+	free_cpumask_var(active_hctx);
+	free_cpumask_var(mask);
+
 fallback:
-	blk_mq_map_queues(qmap);
+	blk_mq_map_fallback(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_map_hw_queues);
-- 
2.51.0

