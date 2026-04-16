Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020117.outbound.protection.outlook.com [52.101.195.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A923E4C97;
	Thu, 16 Apr 2026 19:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367837; cv=fail; b=TcwW4BF23a1Q9E59HFbzrIhmEj88pSW0sgumiqRb3tmGc0dDIC2Zdvu8yi6MSf3YlopRG6lrh6G1Myd2cJR3znqVzaVeVR2cwktHeJSEkPlBDIMsPQQnOTun8Q35iIp329MJvpHVeqnp3oUAaQ9bLACdUssYvv+QHktUMPQEvnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367837; c=relaxed/simple;
	bh=bcUH3KnZ1DmH0ZWKH3HjO9G7CV1Jb/cmjlxZWzgQaWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dOrkeWPm0E1pQ3qzwnfGM+OWaq3ENoXNDD9ARnTlgFFhues4lOP5d8xSxLmIJNjVEQoSxvxJNfbRqqVjZkow3WH7D7xFL/VuKFwT7C8Q2uvwey/4wa+129FwUeWeOaDytuq40PQJEZcHud8bi65VHiyH5KjFE83zpmvD/VkQQNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JqBGDSSdSi8ZzSd/3f7OTd9ZCzOdO/gJd9qfWzJTFfXuRaeYVeazJHnmiZ2L16ERtrlejWznsdCxJ9Nbzbkp1XWiXuHLXsCb0Kdc9TjiLgTAVwOBLioefVFiVWcpPhoRUfiN1h4KY3Ji/hMr980B25hcXZfV3ocrKP5oH3hPkmGEYTikhekVcTZgaj0cK9ey6Hnq3NuxYmJPQLtAhmAb3EdBbZcXV7Ors87Jc4lUmVfW+d/d6nNYFPPtl9UVKAdEM5M4YXSBh+ocjz6mxAwDx5FgAa1UsPMb/Fuws6c9gMY/BmLilMdfiE5ObTHibAWIlcvfQrANNlOsOppkXeASyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3/rFEB6dAccZu2+1v4B3AdJ8UtYGZSvYj6yRg4EG7U=;
 b=Q9s3rzx4vGQDKccZrV8ex6OvGiL/ObXQ4jahopedSOngggaivT1rcCZZTKsrOn6T3ArIehdT87lITUoqhrOrtDzv3sFACc66MtM39x61S4btJHFvPKTnC7tOftkZ1YCqHdSC/UG5lLp7n0oYHajKZkaTOBcEh01XiCaez+5umXohDZl/wlm054Y2x7keu2sNWJl8ykdr7ocg4V8MWeFJZiMBXssV5HKUxOVTIup35SVgipvk8WeMtEXuJ5oWcP+P1zu2/EXqQA8r2tLiiCGRZ/3xEh7DSe5maVwak5Qlz5PwX2kiF7H5hAkUliwI4LvcH9yBHK5xQyD+2le8jJyXZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB4039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:30:29 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:30:29 +0000
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
	tom.leiming@gmail.com,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	nick.lange@gmail.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v11 11/13] blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
Date: Thu, 16 Apr 2026 15:29:40 -0400
Message-ID: <20260416192942.1243421-12-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260416192942.1243421-1-atomlin@atomlin.com>
References: <20260416192942.1243421-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:52f::13) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b6cbac8-3e99-4850-2b71-08de9bee9e4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2XJRgWiiUNl5mTEn577swcPtNHh46gzG647OeTkL7qtUYQmRTA6BGLClncSRSFMkgBkPX+0Kvjsin6DnsKOWxa458lFEJgw5zjS7Fn00w5vB2J0OaKLdrekyIHSaMSPFECKF+a/iE6Nm46wWSnVGfq09GSvVOTJWrwsQN5i6QPzyMDZmACggKtOwx8eY6UuCbjfOB2R5i3g5ZqoFwPpy3i/tn/1d7ku1ziP0Tx9q5rs+nxxPIZqE/LgUjccscGWrDgXLN3djP8w9HNTnpDAkt5506KBJYyzjVM7aWbeCfQTaPud9I/SOakTggiLf6QDIQP5qqZumHN7iV1kRhCfyx0BFB9W9ZoVtrYFx8WXrXiwfC7T4Fi6mP8r2zN6S/DLtJClKK3Gn30koN8u3rsMEWZodJl+b9EtfPl7xoNImsBfBqAVO6B798QhwuxRCIYTZozIhzl3SLkLZnC42lr8cl4iRbulr/J8d8VbaKGsXVAtng8mD5BylFdisjL6pT0V5B0s6TyvSBcxDqRACaNWgM01aWAYo8FFtE8wyWk4QZexKqs9KQTKT3OgRpKcEI4So7Yd6IocLlgx0bsL4O2EAGtlKIp78NJC+vbrKmord63dNEzWAmRvFrJ4mA/74LIQHOHBrwmSn/Rk4C62M8OqEFq4+ugbdgdD2zEzKB85h2vH46w78s0/8LVubzwWtUK4qAFYjSsda9uDNph2sxV4/KxFbjWWdjqhVxA7hrS3j7pA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+vYYZ8x6XR4w8TXcyISFG5cfQ6Apmf/K2P8yJrH9Ob41lmLS7LBIJdKtbKha?=
 =?us-ascii?Q?ZtVANuOOm2qmZgWVlQYJq/d/Pa/NCCXiaY+ybO6kQ3DPc9bo5lqow7wLncpN?=
 =?us-ascii?Q?WrJ1U9uyqQ/4zp65jT9D6dAH9FC0AnM0jJhVBDdpc42dOtQ2qplxUvfgCNGI?=
 =?us-ascii?Q?6A5J4wLYK0yKQpfBJF0fL5SA4iT8IfDN9LCmmy7vggKCdQaiEyOok6bPKCJG?=
 =?us-ascii?Q?FHo5T9zpi9Lz4KJGIXDOR3sMMgRe1XPm1K3KzGTTFm0O1M3Dt0HrGxceOLhK?=
 =?us-ascii?Q?3IRyzukL2wvy+XR5sYJFwzJlYksG5yu6LIn+cLaCiWq3fAZKTo1dUEHK0zQU?=
 =?us-ascii?Q?OtZ9qs+mJHH0DT4XpjTkYWD1wp7i8ePe5LcaUWviF/B1IBtMUo6QtCadK0BA?=
 =?us-ascii?Q?+nAlxtJIukZZgtclr5q0mBB/5FVuB1g4+OPdxGgJSt0i1yaVSL940gGenDZX?=
 =?us-ascii?Q?258T03n0K6WfptQx1ljwORuIbNBCQhGJN3tBJtUAxKfrh7YNbpJOJym43cWR?=
 =?us-ascii?Q?aRSDci10hN4MdcM4yEGDQch+yUUp5FOzyd0yFSoHcJbAdfqGT/9PbK8goPIz?=
 =?us-ascii?Q?Tn/gZ6p/bbkOmHQHN0JQZGDQN2w+u38VVGlrIMfv9jT9rEyq39E1/1/R82Jt?=
 =?us-ascii?Q?Mh1yiO3jc1qC0WY6O/xSoGVV7NVXlfjRkcE7h4KcYq2wHofd4OZKDVOXhErI?=
 =?us-ascii?Q?rkxslrzGcqCUTKBJbFLv3Nmn4Y8fZKjyeyjBRxdp8O9Da87Lnhtq1no2u4jq?=
 =?us-ascii?Q?sRdPKk31zDt0C+WLWPdG+JA722F9F+KWno5iO5sPU7bE7bj+NISsMCsxYxY6?=
 =?us-ascii?Q?nf3ome2jD90sD8+5XtbyQRcFVwXPfd78xuoOzCSX1BmxA0SuL8cpBbOehox+?=
 =?us-ascii?Q?BDyX1YLK45EKrqzIV//QZrvCmu6DUAOgQL/8fPvF8KfyGp52e6xqDOepw1b2?=
 =?us-ascii?Q?4z1ARLSgBdXzfAk++9Mqv3S72GwT3Ypl7cHqRaNAtsy27JK+lVlfqMVahS1w?=
 =?us-ascii?Q?UiXTWPtDyUQxiEtPgSlIDkGZ8iY7JBEt9o8r81GDbdEL1mG/YNt6P76uNufz?=
 =?us-ascii?Q?CowZSjROvPrCZ1OqdeQIPKrjkfGFM7HgNkFIIEUNHb2tnOh5yy/y8ih+y3+v?=
 =?us-ascii?Q?4u3kmmLVC41SK7ylJWtGuC3QZHFqEMAMHpHOwE3gHmHDKCsIUCITTWG3CMEB?=
 =?us-ascii?Q?F2p3VM5EX0X3NPOWbMAXewN28emM62g0zHolxthhD+DoG9HSgZiYHAGKS9sX?=
 =?us-ascii?Q?DnJYH/DTsbIVB1TKeZSEqQzTbN6p5oLy9epAygssY5VeLjjvEQ6FW0HgIDL1?=
 =?us-ascii?Q?YKiQ5lsPMQ2PnxpQ35jcsL/yuXLIG74eP5gPqJ4u58FDrRiAiDrv99cKOU7E?=
 =?us-ascii?Q?uWZ1SmJ+JuZqiWQlqW13gdR5iSSK+mWMolN+/KVEPB42dPR1jqf3UepLjNg/?=
 =?us-ascii?Q?8O+VMLx4y/W9zXe7k/eJK9qsf+VYZUswRgdL+TPUsiJiiLeao4v7O477ipPD?=
 =?us-ascii?Q?XcNoVxq8LqvgY0THzhJIUNCKbaVFC+CTLQKyE9UhZ1U/jN6CxPTjv8VtZRdh?=
 =?us-ascii?Q?YOwfk51v/Lp50HpB0AAjmHoyorbXcaNLM+vr5b7KX3njosVHilnPMOCTN4Yy?=
 =?us-ascii?Q?PbMPJUGUZMai7qDtU94Ud+r3VOobu+4VrqS/fcx3w4zenlT4eNO1F6Arhjf+?=
 =?us-ascii?Q?94xhU9fEmRDPPyEAhRT+NO5t2M1K4l9JSSsth+P6IENSuCtZ090N6fje97lD?=
 =?us-ascii?Q?/U7ruKX3Pw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b6cbac8-3e99-4850-2b71-08de9bee9e4d
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:30:29.5602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKHUPdRdCdX5iafjjKCcUnoG/TNS8wDIbgcxQEabYu1YlihptIFOYnmCSMvuAayn1sU7yZIU51gvA4Ov/3ISbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB4039

From: Daniel Wagner <wagi@kernel.org>

When isolcpus=io_queue is enabled, and the last housekeeping CPU for a
given hctx goes offline, there would be no CPU left to handle I/O. To
prevent I/O stalls, prevent offlining housekeeping CPUs that are still
serving isolated CPUs.

When isolcpus=io_queue is enabled and the last housekeeping CPU
for a given hctx goes offline, no CPU would be left to handle I/O.
To prevent I/O stalls, disallow offlining housekeeping CPUs that are
still serving isolated CPUs.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 block/blk-mq.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4c5c16cce4f8..4257d5b26641 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3720,6 +3720,43 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
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
@@ -3752,6 +3789,11 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
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

