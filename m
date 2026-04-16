Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020117.outbound.protection.outlook.com [52.101.195.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2200A3E4C88;
	Thu, 16 Apr 2026 19:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367841; cv=fail; b=RZ4BFgmRrgHTP8WiAZ1zUxpkPEBC9B/mNiJp91P/Zm3UD9cB8+B4ww9aYVZU7EOkZX0mYnb2/mAVjEhfCxh6gNL90HAdaBoJz0+SqdD9oitSR9qe0BTkv+iLhKQox5/DCUIbffgJCBkETGJdKSX2wkOPCnCYnwwqxjytcFl0TUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367841; c=relaxed/simple;
	bh=w7ejSIrAujAicIyGs/TvT6jahUowQAw5SRWPIFuS2fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wkf+T/WFgNb7yqmA8LAJAQxXLrRm6Y9+6K7gWz2tW8wHbRk/FWgKfTZrHTkynPdO+NGQ4UxfUnUnA+4GEETowx78z5J3M9i8CSTXzIC9cxhrFnH6YDLbq9fO1lv8SWDoiLJka2cYQSV8tLtYjc3NXcvUMtfkBxoiJzj6NxroVRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lnMwoRGlP0H3TEtfOO6EQ/CmLnugd9Z54+w+SyFedoW5GKT8qIHacDvqPXqAAP/Wm+KiZg62PQUU7q4vrDlKuebl9oOEmOg9rLaEHDxpHGVtaQKtigoApmiYcoUtkLA5y+mZ7wzpsQw7AWinsI+Vu9MwCrbBr50kjEiXsjbz+n31D7DOF+nEh919doosvZcxOkzIlwIOcK/Wrjct/z6tcz4dk9tD6VkAfiprPmm7/cpBkiFRoi0Zdljylpd5Fn9BReh0ISbKmnR+i6dj6WuSJQ7IC3J/ij/f0Smc28izJXoPLfiIv3fJOtcxQH70vZLzrxuQu57xL2fkzlss6lAkdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xmv01v5xOkdmCwMWvnEyBsgYEHh1/yym+aD21ZGgYAk=;
 b=nHcFEr7szXR7tWn5v7nV+jken5ABei7/U/v6NfDwg/vUKdQcpmRD7RzPNzS9USrf8r5o+VQG61bi4ok+fK6VBwNHRurnj2mVZCsqOmNE1zS/9ei6+CCxpkQQTbU4cPSaQeF3LXtmrLvYpau77pmJud9/3qyKfG9Ou9taqXR/gjxSzNb4ASaeCoSjkmS/4U67PgzEofguLwI7D8c2+LRnWJ2Yelr0ifX2guO3EaJVYr2R7Zla8Mspm35Vwv2/LrW0KYb/WHOIED7vePx2uICh+c80S7Erfe9KYrScKgpD8jpWeMz1vln7m5Dm3nDODoh51ohbR01cyoS74UXP6/YQww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB4039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:30:33 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:30:33 +0000
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
Subject: [PATCH v11 12/13] genirq/affinity: Restrict managed IRQ affinity to housekeeping CPUs
Date: Thu, 16 Apr 2026 15:29:41 -0400
Message-ID: <20260416192942.1243421-13-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260416192942.1243421-1-atomlin@atomlin.com>
References: <20260416192942.1243421-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0208.namprd13.prod.outlook.com
 (2603:10b6:208:2be::33) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 310509c7-fe94-41e3-1e9b-08de9beea05d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003|20046099003;
X-Microsoft-Antispam-Message-Info:
	TRaoLDjhPIXnMnDq/ITlETk7c79sYL+VOEqtLfEZ1pGrSqMNtg1+UkZETunVCoT1mx0BMwPXmTx3nwQoParcEOYQuy/X0itxj9qlP2odZjqB/fawtReyyYtlTJzxevGKvRSCa85U09ZAtDvvqocXr9ul4ed+asTQ4BeKXoPolo9Gwpf2CtPoK7I2bVq3gD3SnYO9jNJxlhIZSUl3ELnEivzqPaUd/zaljRXxHETDNYVtqATU65UogZvmPVKXYIyqItShKVO//Ca9xIzVGS7gBXM9juW51CYJ6AZ+fnPRTQMyYeSCZNE+UYLDsiCZZonWt1p4yt5xGDes8YRzUr07vH8dS2C3uo8QZG9FkQMsd7TT2L1JzuVsneInBGorMkgCccR3rJSqtgziXPExZxuSZhoXD36HYpYlb5s7D2nvgbL2P6bgwjbzSaPeLitWEde8ZWoM5xmtd5guOaEAwzoxDuJmaknvNHyLuhL28+JRN+ffkj/Bqfqytwm/wHlAK9t+XHbRRlTmC6dBnHYR7uWVGP5EjXFBnGBCl90+4MGAO11r224T0qGYrpSgL7AelCjJztLt1ssMenHXZTfTbZOc9O6sEEkBgNloyfhaiNKipLNB1veChWc0/G5ml8viCsBcVnOG4yJH2LJROdy86N4sf/7P/gfJWzlc2Livu5UKQKYFGKxake80on4+AauQjGSntWnOHYc7Mpde+4Gt3TB21dUYBPQtbfAxcOGaWobm6gE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003)(20046099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bpZAZ52J7ovXfSOCR7z6V9Se5kx1I653sNUYp/qWk9ZKpxZAZIE5xkQ8mdvh?=
 =?us-ascii?Q?rmMsI4rJhnXHyuXh4yYFs0RifGIyADf8xYLYoA4WtlzJXOI/0oSxXdKXRu4H?=
 =?us-ascii?Q?gvSz21UYDcSBQXUl60vNrtHTNRBIvq1P/jGgPQ2ovr8IAL8IuzJvm59n50R8?=
 =?us-ascii?Q?dz58byknD40F4mmvskmXrGu6mBmIz4//CrW4JzbW1/c8BUuQBZ4Lol5fnfLN?=
 =?us-ascii?Q?d6tuT/X9I6Ue/V71Y/qRpOmU/TEVNwc6AlHEN9KsUFtSQ2wyyDFqERqDyRV1?=
 =?us-ascii?Q?RvC93Or5LEbg/ZscxM1yEpuBWy37eWELGnrNXKziJIKwVzP/RdrgwyRe9Tav?=
 =?us-ascii?Q?PoJYJ6N6RzpsTcPlPT5lWJ4sk2ucTC7LaM7KtqBhB8bW7Qq3JAXKh4GoOrl9?=
 =?us-ascii?Q?cpFgHYWSiH/LxW/4TgAliPmtYKeG4J8FYZpV1V4Jj4HK2qqO9/noX+LX+mug?=
 =?us-ascii?Q?hHqu2x+kC2W1mx9glmIc+31UIX5PVR0OOjo6gtuX56PmA9BmMjjLgSe8HfYb?=
 =?us-ascii?Q?cVWLHflX0kzIa9C8s3TWrJQTu6/7jr8sZxrqRv0zObdzQf+drPd2PL4WKE41?=
 =?us-ascii?Q?9984LSC3Qscka2OLfLF+yYI0guAytTBsK1qpByn82n4fsUCYkT9zFWUttg0W?=
 =?us-ascii?Q?qZhYNvlPCwaoqNtTE/hqWL5yCLoLUsjoAknukZYnXM5pR8iB3iAZiBKTh7Fi?=
 =?us-ascii?Q?wCM5XBhV1M9iIGTkcMwQVUdbv3OIqbOZzuWZ58DCoOhEN5thJqkmslHeF3Fu?=
 =?us-ascii?Q?2+w7yx4uMUv1ELyD3XGaQFWiFFrIyGim7ccfWIPxo/SrpTmRibG0F3GsOpRp?=
 =?us-ascii?Q?v/n5e52XU0vwEmepLRgOpolk8svzN6I2morLl31PkUKj2vX0+Fck7Ra83Aj7?=
 =?us-ascii?Q?lPE1A3MnOqOpxHlroe94XNljWR+85xoWOmE2Zpypk35ZF0aS77RKbLp5fOVZ?=
 =?us-ascii?Q?A8Ip5c6KSC4cck4es7KqR01eI648oC3Y0UcXd6TVGOEc0ETvxLM4Cu1lYaPS?=
 =?us-ascii?Q?43JlA/hWSD4jbnfjMBZwCDaS9dIgxVLL09cJlLJZsCFLsKSN5TKdixW4SyvW?=
 =?us-ascii?Q?OUOov0PMgD3caYGEF1fzGcvqg8SGwSRiT67Njmzbxtn4va7169jt9AKHjd3N?=
 =?us-ascii?Q?5zAAQZb40Q6dpAh2vZCM5TnnOz4IBP/OlOrQAdCHLrLLTWN8xRvDaU441YBW?=
 =?us-ascii?Q?+tOPAQU3YsMZwNe+QGEtmpcv9uwC+1dncSnqhRs8dJj/3CeNUfJn0lu4ay6o?=
 =?us-ascii?Q?VLF831QXFouOMuIF4JwvzdG7Z8In/2yxyS7YB+jjAtQxjLOtRTODITGQqWkh?=
 =?us-ascii?Q?E0MuxfWodJpNqpwFuBvSrOxEnMAICW5u0zkyuukL+sxX4k9BTAdv2mWX37NV?=
 =?us-ascii?Q?EbvS2a7CEhsPbq0QxVtTcUfXM57UQhO9jijCpB6SyubgVf8GLOpYixlbGNf7?=
 =?us-ascii?Q?ymYHEx+3CqUAYWt9KSbrAMSiZuKhf23nFKnT5weDn7LTSgHAfXtjkIjD1tjh?=
 =?us-ascii?Q?OVjJxTeyXP6LQ2KQSiYTgPwMRaU0wdop83wLFveYTkmejQjFyRinvEdLRxIl?=
 =?us-ascii?Q?obWl1HEMf9BHRp1XIwi7RBDO7dilLVVY1N4mAhqu5bBPvjwDV++tu56QBQUJ?=
 =?us-ascii?Q?8SSm51qQ6DqMTKDZKENdtVgRZxoeJFLJtrZK30oUOnm4/fxVUeS9MXmrn+Y2?=
 =?us-ascii?Q?1YhbZo10Ri6n78cVqY4YhzLTOUpDw1NxzY+9RfbvrEGgPfGcj9BfCMAhAGTE?=
 =?us-ascii?Q?XFvChzqNLQ=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 310509c7-fe94-41e3-1e9b-08de9beea05d
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:30:32.9801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: evUBrmKtKqVoRPdYKDIc60CKLxxlwJ9nrEJ24gZsiAZ4KxfQyEtV/4+iavz6C/MTbiEVxS/IyEtENbdtxITM4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB4039

At present, the managed interrupt spreading algorithm distributes vectors
across all available CPUs within a given node or system. On systems
employing CPU isolation (e.g., "isolcpus=io_queue"), this behaviour
defeats the primary purpose of isolation by routing hardware interrupts
(such as NVMe completion queues) directly to isolated cores.

Update irq_create_affinity_masks() to respect the housekeeping CPU mask.
Introduce irq_spread_hk_filter() to intersect the natively calculated
affinity mask with the HK_TYPE_IO_QUEUE mask, thereby keeping managed
interrupts off isolated CPUs.

To ensure strict isolation whilst guaranteeing a valid routing destination:

    1.  Fallback mechanism: Should the initial spreading logic assign a
        vector exclusively to isolated CPUs (resulting in an empty
        intersection), the filter safely falls back to the system's
        online housekeeping CPUs.

    2.  Hotplug safety: The fallback utilises data_race(cpu_online_mask)
        instead of allocating a local cpumask snapshot. This circumvents
        CONFIG_CPUMASK_OFFSTACK stack bloat hazards on high-core-count
        systems. Furthermore, it prevents deadlocks with concurrent CPU
        hotplug operations (e.g., during storage driver error recovery)
        by eliminating the need to hold the CPU hotplug read lock.

    3.  Fast-path optimisation: The filtering logic is conditionally
        executed only if housekeeping is enabled, thereby ensuring zero
        overhead for standard configurations.

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 kernel/irq/affinity.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index e0cf70a99339..03e914ffd720 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -8,6 +8,24 @@
 #include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/group_cpus.h>
+#include <linux/sched/isolation.h>
+
+/**
+ * irq_spread_hk_filter - Restrict an interrupt affinity mask to housekeeping CPUs
+ * @mask:            The interrupt affinity mask to filter (in/out)
+ * @hk_mask:         The system's housekeeping CPU mask
+ *
+ * Intersects @mask with @hk_mask to keep interrupts off isolated CPUs.
+ * If this intersection is empty (meaning all targeted CPUs were isolated),
+ * it falls back to the online housekeeping CPUs to guarantee a valid
+ * routing destination.
+ */
+static void irq_spread_hk_filter(struct cpumask *mask,
+				 const struct cpumask *hk_mask)
+{
+	if (!cpumask_and(mask, mask, hk_mask))
+		cpumask_and(mask, hk_mask, data_race(cpu_online_mask));
+}
 
 static void default_calc_sets(struct irq_affinity *affd, unsigned int affvecs)
 {
@@ -27,6 +45,8 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 {
 	unsigned int affvecs, curvec, usedvecs, i;
 	struct irq_affinity_desc *masks = NULL;
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+	bool hk_enabled = housekeeping_enabled(HK_TYPE_IO_QUEUE);
 
 	/*
 	 * Determine the number of vectors which need interrupt affinities
@@ -83,8 +103,12 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 			return NULL;
 		}
 
-		for (int j = 0; j < nr_masks; j++)
+		for (int j = 0; j < nr_masks; j++) {
 			cpumask_copy(&masks[curvec + j].mask, &result[j]);
+			if (hk_enabled)
+				irq_spread_hk_filter(&masks[curvec + j].mask,
+						     hk_mask);
+		}
 		kfree(result);
 
 		curvec += nr_masks;
-- 
2.51.0

