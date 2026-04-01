Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020139.outbound.protection.outlook.com [52.101.196.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC0A3C1416;
	Wed,  1 Apr 2026 22:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082288; cv=fail; b=tsA6I3JDiJX7y2QCNZhapGw5P0aMdmb5kO+vKa02k6R8QSHQByV5evi0Ws5qFLWJio/CTCP9D12ljeD6K2aDITeQZH1dBFi04ImwucybhQRJP5iq+0dsQi0iiLCrewZ65nvCYhV/hJtGI0kD6l8jPffsPAOq/MomXvChR0TIo+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082288; c=relaxed/simple;
	bh=IiWRf7HtQAAvNS/dUpjl2l6bOb4FFpIkYYhc4+oXaDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L7DOpioFQdyTjvNqr4qxoqWMQZj2ZiH/V+AUcLw69JB1L7pHvo3+XztXV5z02SsOXpkvQEVh/0a4XvQWtX231PXfPv4vQuCz+Qk0AHva5y4r33R0GVALFjuqZFcRzBCuLgwnECB1jclcknmLKBmJv4LXx/pbjSsNVvAT1u+x8Pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PurdB8BwzLkANXijYUjnESD7gWjylOYv5Zk+5tt+ad0/TWdUhb+uFw1MzbcecZWj0CdNKs0tXvrynVAMFs6ig/v6rUWvTSYmSBgdRmC/2R2XmyIcnc4HOsmgMYjWsueI6EJOPK4rEI16ni538j5ump5NgfchnpdZimVntt5z8ZP9Y+oJ6o6pqgwI8vH6eHDGAInbFbGQ595iZtdGRPmfU0PXay8QEUSa2eHaj/Now/bptkRYgsriwryqnZ9PJM5x8pPeT2sfv8sl9oHv2iCDF6YPnRChB/HoaGR7wgXlZq6Rrf2YvHZIFXPtPgCzPPoymyeTv2ST/+GP7wev9VQmvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8cC7CSuSFRYsSBLvYD81Lw0y8pfATNHfQaKPkQXHns=;
 b=NJQCjx9/dXEe43ZrksFpjrWhmhiuFy8rSN3hwvQSLu2mHYWieiK9pvlvCR/LtCGKvso+8eLZiGvYb9HA5M5TDSMs7nxkw64Tr/OjjmJ31PIRdJy58Ok0eFT/EHoQ2CKQmy0wOW0L7zY5JDfyVMUFJ42IWhWXwvpktnj2aBP2G1KKEbMU8Vc3OUXYr3eQSkk33/u7MWKG0s8pqXzVjCS7g8yR7EC+z9/+kyG/45Rfy2Xg1aM5MddtCJ/aLEACn1F+hVJb5fC/TB14AnxBqmJsvgYXk6QVpU89gvcKk+XXA9YqjlDOuzmTIy7xWL0j1G5cVxwYTOUwBS0iwp6m/6lrdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB2964.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:58::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.24; Wed, 1 Apr
 2026 22:23:54 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:23:54 +0000
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
Subject: [PATCH v10 11/13] blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
Date: Wed,  1 Apr 2026 18:23:10 -0400
Message-ID: <20260401222312.772334-12-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260401222312.772334-1-atomlin@atomlin.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0066.namprd04.prod.outlook.com
 (2603:10b6:408:ea::11) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB2964:EE_
X-MS-Office365-Filtering-Correlation-Id: 056687ba-4676-4570-88a3-08de903d5c1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KjRGQpV7pkvgo9mfMXgj7P96vvG2AbbPJIiit47+vT3O8x8FtKxX0/rOWasyjdD+VAeNmXMAaGxtbHXIy/uVQOt1+D5kbplRlehN5y35Jpc5OshzwOicKi90KlS7P3Jbx5mxXJI4pRbIwULbikApCbNv6GDpAUMKSOCJmBQ9utIznCOHWPxLMwowHncNllR4uXvC0akxsWh8IgctYpYlhCw2kqskLjUOXB5TpTRxf2kdhUyfAGC/Rjq21uuHrc8GcN/XzN1/ESFA4tB8pQB64f7iyFGYNFFCKMdfnfGW8eyK2/hhRkNJdONQ2iAX7G8a6p6EirWtEZtfuCfSTHI+o690EFozliwG1FIIMjCbt8tACqeXVdsNCo2z0W23wATJ3PJjYTlkJolj59QWZUlZi5znMStykuAWg14OXJdPCDSuY2LQR7rTgwF4bVkUQSnrqg0bM6jDuMlpGjGTPAdzCXUcbn7V8XMicse9/OM3mtzQYf2oP8XNCcm8XI/Qd+MSAzAEx3gPbHEjV1KqGyNxQF2nzAiX3AYd2ZhrDRRWkt6qm1z2zq0/i+zxiSyXibuqd72ntSNQC35P+KQ9oD4cLa1WeeJMqOGgTosaG0ozB21xRQluPzMVptDbFnXWfeuKA7S11mMZ/JF/f11pG/u5JiRgruoG9hzrptfxm4zZ50MiTIv8lznczJB9TweJ2M9duciVh838cnkwtG6bODfefxkvw3PYHt6CnCMVnCQ5iZs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bB64DQ6bN1CEsaq9PHIJPeKnoatMmpH0PUpC+qtqVExc9trlh/QA2sNo4iQH?=
 =?us-ascii?Q?6jg5xEKQOcWr2jrW/HunD1Q7w3OipEC7vTfMe7io8TmMRucpwr3TW7RFQf6V?=
 =?us-ascii?Q?kicr9RG/CT9mxeirN1t68gFArESJqqvOPQBlMCzDMUv9MTCT4J/3JzdjB+38?=
 =?us-ascii?Q?Dwef9YgQwS6Yp8Nr9tMleYRfEFSrBPWIipX5DvtACCz380fJ/WG2h2Vi02J+?=
 =?us-ascii?Q?sZl7FyfYGfWnaGET/MXgQrC6v7cLiwcoIYpDW2dTpv1f2WuFJs0e+Q4Af8zR?=
 =?us-ascii?Q?bHWFd5kGMChyTUk+m9hxaHtpubW5lygMhxpcT0YMF1EhpkBpmSJkKt8yQ/2w?=
 =?us-ascii?Q?3q2wRU7Yw7tuCp/cOdUAnFibAj/CBHJHVYhKFnZrxcQdFf4KRCYypilTUsrE?=
 =?us-ascii?Q?iQjzlwGhgScMlOcy8cmza+K5gQrAEeit8lVlqDhTml+EomeZTU3rjBSsOcGs?=
 =?us-ascii?Q?g1RsIhE7pcDdu8V08Lpo1CMq/+fTQAkMX/x5c7raSwlO60Hce5vVJFo7FFBO?=
 =?us-ascii?Q?iH11o3eZxyN9CiQo4QThNQAgxWeukgNGytQ2sSnpGgtDcP79WBanF/liYAcN?=
 =?us-ascii?Q?E5lO1O4gxAjq3dcJFp4zfIbfcm57JqEvfKXNeBmKx/r3UU2JUc4S5YPA76Is?=
 =?us-ascii?Q?mixRQbT/QFOOkjJsifWHvY1GcF9ALdNpgGcxigyGIyDRa073W4YxgTxyJpqa?=
 =?us-ascii?Q?UZoi6a3OU85KFRfiW8lMXu4f6GH+c+8eyZA9FmyBBCyVODy2cI14jgRQyu0D?=
 =?us-ascii?Q?tslJfR6SWIZVr1RxH4PFh9Av20v3LUJwc+pgTzoCe7dgc6KbHYYH7tLN0Q/8?=
 =?us-ascii?Q?kfZO2IBIEIkEfOFGqgDPK2hPEpupoSOipngdbjGfRkmxluvJcDv7bDSJJlpd?=
 =?us-ascii?Q?JQI1Y5xceObb6RMovV3QvmQB7aNkIot9PVkdotFdG8jXgGwcSZyONBS2S6RR?=
 =?us-ascii?Q?jPjp3GtBekobtZD7egD0UsAc2m7j+PXkH1KEsY87a2moVoYkpMkw1Y4vHIQ6?=
 =?us-ascii?Q?6OdP8xF9JH4HL0ttN2X6yrW2ao+Y2F/wvfwrIX/21srMK1BcEizEmtp01DKo?=
 =?us-ascii?Q?1ocxJhvv2ZzTzH37oMbSqMJv/t+4i469eKkdte1J3GT7VIWLxESXjqjM1FMA?=
 =?us-ascii?Q?kyjzVk7O8urpoelH3sIjXBGLzvhPbh7AKgExQec1YOso3gB3HI7Pn4sFJzF3?=
 =?us-ascii?Q?rIVRXtUWXgq3Ezo093k4+ykcqEF+rNmdHK2kzzBpKJhgvs6K5gyGtCyw4zld?=
 =?us-ascii?Q?VasBhawnNu7j7d9L3hfbkY/DGU107BqEZNmnlQKwZSgVAJ9XtF09psBTLsVa?=
 =?us-ascii?Q?bDg5uWKL0WJoXpU8WQFyNeHZJ26eKqji88jpKRtZkI4vLwdFt0Zsbo3iRkJ4?=
 =?us-ascii?Q?3vUP2PveyqDgnDG9/Dv9ml6Jg4lP1qqwXYb5XZOdFFKPAUfwd564kftmEDD3?=
 =?us-ascii?Q?EqjuD041/oDXLeb1zm7iGiD44mXMGzfCBQi0w8l7yb8E9BPCvk20nMZwOnVU?=
 =?us-ascii?Q?EP9zvreMcwjWSueoaoypLN+R1iGVquW/EK14Wcwbjfi2Y8HKulrjs9R2YL5D?=
 =?us-ascii?Q?zOvsyFCRr3ykIiqGbqcgN4MLpIA8djpIhHdn0zv8JSklGbY0MTTP1tuO60Ns?=
 =?us-ascii?Q?7CdqHHtpZ+aDye3LNnKRwFEouH6UaPnpkvcV+NUK7XyiELMb2A37IUKRXAWO?=
 =?us-ascii?Q?94DHnlQuYrwciYip8wDJLxiceYiUgv639t3jmSmHYbibjZk3Ac62PF6f31kQ?=
 =?us-ascii?Q?HjIY8GfyTw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 056687ba-4676-4570-88a3-08de903d5c1c
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:23:54.7500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jq66XpymsvqrLOGddKGYW59owlSQ7M6dcfNTHQuIJhEKy2GatReqtBD3DWKTIcz/SrZoZB/ANJipbC50EoAa8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB2964

From: Daniel Wagner <wagi@kernel.org>

When isolcpus=io_queue is enabled, and the last housekeeping CPU for a
given hctx goes offline, there would be no CPU left to handle I/O. To
prevent I/O stalls, prevent offlining housekeeping CPUs that are still
serving isolated CPUs.

When isolcpus=io_queue is enabled and the last housekeeping CPU
for a given hctx goes offline, no CPU would be left to handle I/O.
To prevent I/O stalls, disallow offlining housekeeping CPUs that are
still serving isolated CPUs.

Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 block/blk-mq.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3da2215b2912..8671f2170880 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3699,6 +3699,43 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
 	return data.has_rq;
 }
 
+static bool blk_mq_hctx_can_offline_hk_cpu(struct blk_mq_hw_ctx *hctx,
+					   unsigned int this_cpu)
+{
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+
+	for (int i = 0; i < hctx->nr_ctx; i++) {
+		struct blk_mq_ctx *ctx = hctx->ctxs[i];
+
+		if (ctx->cpu == this_cpu)
+			continue;
+
+		/*
+		 * Check if this context has at least one online
+		 * housekeeping CPU; in this case the hardware context is
+		 * usable.
+		 */
+		if (cpumask_test_cpu(ctx->cpu, hk_mask) &&
+		    cpu_online(ctx->cpu))
+			break;
+
+		/*
+		 * The context doesn't have any online housekeeping CPUs,
+		 * but there might be an online isolated CPU mapped to
+		 * it.
+		 */
+		if (cpu_is_offline(ctx->cpu))
+			continue;
+
+		pr_warn("%s: trying to offline hctx%d but there is still an online isolcpu CPU %d mapped to it\n",
+			hctx->queue->disk->disk_name,
+			hctx->queue_num, ctx->cpu);
+		return false;
+	}
+
+	return true;
+}
+
 static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
 		unsigned int this_cpu)
 {
@@ -3731,6 +3768,11 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 			struct blk_mq_hw_ctx, cpuhp_online);
 	int ret = 0;
 
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
+		if (!blk_mq_hctx_can_offline_hk_cpu(hctx, cpu))
+			return -EINVAL;
+	}
+
 	if (!hctx->nr_ctx || blk_mq_hctx_has_online_cpu(hctx, cpu))
 		return 0;
 
-- 
2.51.0

