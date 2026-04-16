Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022129.outbound.protection.outlook.com [52.101.101.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F73C3B0AC3;
	Thu, 16 Apr 2026 19:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367804; cv=fail; b=t/OkaL0PDHRxdjNX6ZHykzS2tgNBoqzAqxunVlHXV3uhgyX6FE1XZluK656SyWTsJtn9OOYfhh6kAPdrYaNQwolqPOq0iwlmKgSBL+3pGkGoQvBJZd4Op+NBgSvGP9vYoY2VXWKTUNPywGECfhfkkDp6Rb9sVtzp5yakdsh7gVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367804; c=relaxed/simple;
	bh=NzV9rhVK6HW/HF1Pr9zPtwRxoPP9THF759OwR5ItOrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B+gRn9fxYYLxKQaqwJp+v6kMy8NZC/4EUElvS/9xKglX8WfUZspS1v9GNIITyPUEMLBe5KUxkTcfAnU7+vwYWIskWA7kLtCrzVBChDTk/iUs8VXhOfkE9tGe0w9iCupeh3IT2Dn/znDaVMv3eI0noNitnv323ccv01ud8nz2R5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CDjO9rdQix4THXlxCjg2TEjzxwKJs2Cv0q2Zyl+cRwvHVsM/ve5jVnWVbEApidNqmiqz5D4g9210S6oAgCaajdL2nkebZvRVYrjPQ4ns2F2CqapaBxG6l58VPSkYmcJXP7ioSyUB9Sx2f7RIEwvfTb8dJb4diLLx2U7wS6M28YAb01Beidxue0VBF1d7kiUVLCk8znr+RS2fQp/shG74K1Jyuc7pgmJzhLD537If1pvM+RVZ4xX1OZHYnSl9D7stsL1CVtXKDDO1QGg4gFtf1qXXhgdJrNFOdo+3S/n5tMHbIXrirLL+cVsaB7WOE43hIfIhGwkTmzEEYSGkUG4BFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NO3v3D1AxpD6ih2jhYY2j3Q0W/mEowCN/W9TufsAPfE=;
 b=G5h7ygYTI2xmWn4pd0q2/MqdBcknEnX47rOVhVC/7KlRM1oDpIASUdyXUiGQrtJd4euIsprB+oWYhQDDxSgUx1c/4nazVMtHKZwNCyhyIjErOBZLqb3ry0UxBvhDX0FU9vqZIIKxqG4bwgto7bcW+IGC7FRk4eIgktlJdbOk0+80bUBf3JVJNC3kKHcBk7WaRNTy0Udz+hv46J19bcJNG2Kyy3s9XsWQYkyhBBU3bCWv4c02Wi1gKplgmZESiu18ylTHEL0O3OYkHn4b4CDxiL3xpVU9oZt53V2vbq4yYSKUbIGhKcPwvYuS290XA6Oad/acIzjSkstsXUD7a3jUqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB4039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:29:59 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:29:59 +0000
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
Subject: [PATCH v11 03/13] lib/group_cpus: Add group_mask_cpus_evenly()
Date: Thu, 16 Apr 2026 15:29:32 -0400
Message-ID: <20260416192942.1243421-4-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260416192942.1243421-1-atomlin@atomlin.com>
References: <20260416192942.1243421-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0094.namprd03.prod.outlook.com
 (2603:10b6:208:32a::9) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: c25a194f-ac11-411f-f1aa-08de9bee8c3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EQHdKGWqxCDav27hjkleO+BihgV9oj4paWuVC8bPBDViFEhUPfe/ltsjjvwBwkKWCms05ATBqFW7cQ/tpMhb9mRYsMjGJB3udTCCL5tr3Aiew+n//avPvEKq0dqG2IQ2BXxpvCYzB2Q1qS5RS6C08jWLbwbuerbj6H+oNNXyo4Efp0Xp11TScIeZSJ5MWHhgIe5+cUs+PG+fUAG9TL65d/q7FjpJRcGKJ4OJfitWHdwBD7RKiNfNPE10ts4d0Gb1N5iGxyUJITbNTxkXRgQjW3TmzzgAuqJD7gGkQaAzHOvRSXZcrj07/OOnv3GQWowXTxrrF6ci85GYdDt4lhh6DSt+SBAeygfjT/L1pYlvAwEY8FABVuvHqJG3n+n2U9saH4mjHL97kLKT1HLRUZat37Hep1byBQCmYTn5xxdu7v7YvGIysHxbU3sYXCgHHK6ofaIKzihz66bqkgQXHXUrpVxSTp5nB0feH7WhPNUyOmkeD/IjGMnQOmk44irpiCEEOTM+9QWvHjSuci0wxG/xTW0yLlRg/HbcTRrpn2Nsiyt8IQ7qaDpCVwYg9Xl0sc4uD7+uF11/KuAMbnPgzBqtxbI7KcVgEV4bN/edJ9GdKn2W75j9Rg9PMEKE/ExZs5xsGQuWWxN+D1LaNr8k9ZfuQ66I+xq5LbUPZqMipU5z84/SIS4HjmJHobF34Pvqey0dGflA1GDOmrL+Kkm16MNX9uv4V/E+0F3uifA61byk5HE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aPqGBVRnol/k+qIaYWOA0UU4qG+hTKWPiCjjjgf+4Z5c99d5LosB2fR0RkGk?=
 =?us-ascii?Q?1FCfBzDt1/ylYfEJgzUJNnBomzg82zLzSQiIobniKSAx9z/hVUGX++0aVNdG?=
 =?us-ascii?Q?8ia8i7qwXcfT0jG/ysEa2o8zGU4nrP+z2Ge4ggWUxDf942M/KrGho4IT47dN?=
 =?us-ascii?Q?XlnBm1/1Jk2RZU0HBWiWvx+vlderyKPTgHPHwYFMKx51WClwJbfDsoth98fK?=
 =?us-ascii?Q?qzNJFNdNvQoszywSbtO3Jxffc8Da+DbWRvK54+1Rxrob4kmyKinCOZZlWxUy?=
 =?us-ascii?Q?3K1ucxDt3ybl9aLgHBMWe/K1sOe8ByQ5W+pc90rCoOhztouUpel81hhnFkdK?=
 =?us-ascii?Q?5uLsSEV5OnssFtmpR99bq460hvTpt8VsPfVWGF1+mSZYXh83WxEfnUv5gWYf?=
 =?us-ascii?Q?9zwg5U7eifQF9XJDpDBXoL0e79Kfbad64OHn39cKTeNZ8NxKY5FKg7RfoRf0?=
 =?us-ascii?Q?vMn4Y+qsP68MGtpiEnrM8AzKSUhsPZv58n4Kq3kcKEqc+xAdSLIz//ROG0wd?=
 =?us-ascii?Q?mNzwtLok0ehLlnWHNCjDMCjT5quws5RTjCO8nkKNmVaWzo+vNzEaWEVUxsBj?=
 =?us-ascii?Q?QOTphXymygf2GtqhVaHxxH0uZqhZ71xJNwll39SLNQgDWUq4QYMztvcYr8Ez?=
 =?us-ascii?Q?/Q98u2iCpIIfyL2WFhIbpBMvCXyCFnnU/uD3WOYAqRfavCgQGjNZ+YJz4mKi?=
 =?us-ascii?Q?f3i5+0Dayuk7AKd5UBB7twICqwpXJp45kiAozmGMAujVsQmMwO7RtSSzyZJ3?=
 =?us-ascii?Q?/PLDQ7NhGST/5tW5o3r/dPbNqu3YcBHAWLWvXI8ryQA+8J6wGp2aLkPkSdYf?=
 =?us-ascii?Q?XbGUECeIxT8G24sHR1A0idhK2tzEFnWeEnEXdRJncgZnL4gmNpGo8WSLV1nv?=
 =?us-ascii?Q?h5eMrm7h9OACEki7uvbRhunNlHAkBX34Jv+l5IhZ9sdWfj6Vgnd/heGejE51?=
 =?us-ascii?Q?/UyIl8hC8iDAfzklJK9HROJxXQhdHLKOt3BJ9rFWF3zWBkbWJSigm2ZexUXJ?=
 =?us-ascii?Q?BUZ6pP0yEF3SA0XC+GmcLbc9yuOUy2PTp3X/FpBCkHTHndihXrKwPdhaZq31?=
 =?us-ascii?Q?LwrAQP8owo7ZEuLvO6NrOZU558bCb39mfLrXbUZQPayElo3xdwmAvRIOPv0t?=
 =?us-ascii?Q?UfUiVhaytzLnQQZpQwXLS+D+1L+79VsuI1qxiiLZ/Uw8B5I+LMIEroCegDqq?=
 =?us-ascii?Q?XkTJKWLxzYTl02hOhe9pg+NS3OIKw8BCwj5sMI26rOT/g6uAWlS+wMJJcZK9?=
 =?us-ascii?Q?SVpmGfIy3U3hMwuuNnDInQ8aO2Tpzioi72XuNl8D2aDf9UAIrpvSLqN81Itu?=
 =?us-ascii?Q?NjL4IHghS1YS0pvnALypgi1K7WHCwZtN9alVdWoCIdaT4HpE1HgDFABeF1Cd?=
 =?us-ascii?Q?dmMV5i5UWkeNQjaQCM/5WUgQkZrlRnFcY+SFvC4Si1RCuU/Br49bqHEte9MJ?=
 =?us-ascii?Q?QStmS8Bx6j8OsdNYw7xigcPTh1UZFlKVb52ZIrD0cwyITMnGFY75t1VUn2/z?=
 =?us-ascii?Q?aozdWKnikbJMWQkopOmMZqurDfa3Ram4hqJpZwWQ3iV8JTebJaV0mlRyXDSj?=
 =?us-ascii?Q?fdXV7gURmH+moDkDiZ+k0G1HRYd+mWWy8cR00r7ntII0D7k/2n2IECAOE759?=
 =?us-ascii?Q?p+HKJKcWEuS5iYo6EeO+bEw63mWTm0GVX1BlZfspCvVvKZkeBbsoWRi5awlg?=
 =?us-ascii?Q?KC7Mz8SKm0DKCRYEP65wNkMIP3J1XuuqMcEkO036mfgUAEP/1fmXFIctPi7a?=
 =?us-ascii?Q?aYHKz/PLjg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c25a194f-ac11-411f-f1aa-08de9bee8c3b
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:29:59.2097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J9pJbP0i7lC3aLW7wAQpBmeNu7gzRZ7cT1/KY473H/Go0M/V3Chj0yYVezHOfSBIPFmgJHwawua5A9eja1FwhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB4039

From: Daniel Wagner <wagi@kernel.org>

group_mask_cpu_evenly() allows the caller to pass in a CPU mask that
should be evenly distributed. This new function is a more generic
version of the existing group_cpus_evenly(), which always distributes
all present CPUs into groups.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 include/linux/group_cpus.h |  3 ++
 lib/group_cpus.c           | 59 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/include/linux/group_cpus.h b/include/linux/group_cpus.h
index 9d4e5ab6c314..defab4123a82 100644
--- a/include/linux/group_cpus.h
+++ b/include/linux/group_cpus.h
@@ -10,5 +10,8 @@
 #include <linux/cpu.h>
 
 struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks);
+struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
+				       const struct cpumask *mask,
+				       unsigned int *nummasks);
 
 #endif
diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index b8d54398f88a..d3e9a20250ff 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -8,6 +8,7 @@
 #include <linux/cpu.h>
 #include <linux/sort.h>
 #include <linux/group_cpus.h>
+#include <linux/sched/isolation.h>
 
 static void grp_spread_init_one(struct cpumask *irqmsk, struct cpumask *nmsk,
 				unsigned int cpus_per_grp)
@@ -563,3 +564,61 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
 	return masks;
 }
 EXPORT_SYMBOL_GPL(group_cpus_evenly);
+
+/**
+ * group_mask_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
+ * @numgrps: number of cpumasks to create
+ * @mask: CPUs to consider for the grouping
+ * @nummasks: number of initialized cpusmasks
+ *
+ * Return: cpumask array if successful, NULL otherwise. Only the CPUs
+ * marked in the mask will be considered for the grouping. And each
+ * element includes CPUs assigned to this group. nummasks contains the
+ * number of initialized masks which can be less than numgrps. cpu_mask
+ *
+ * Try to put close CPUs from viewpoint of CPU and NUMA locality into
+ * same group, and run two-stage grouping:
+ *	1) allocate present CPUs on these groups evenly first
+ *	2) allocate other possible CPUs on these groups evenly
+ *
+ * We guarantee in the resulted grouping that all CPUs are covered, and
+ * no same CPU is assigned to multiple groups
+ */
+struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
+				       const struct cpumask *mask,
+				       unsigned int *nummasks)
+{
+	cpumask_var_t *node_to_cpumask;
+	cpumask_var_t nmsk;
+	int ret = -ENOMEM;
+	struct cpumask *masks = NULL;
+
+	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
+		return NULL;
+
+	node_to_cpumask = alloc_node_to_cpumask();
+	if (!node_to_cpumask)
+		goto fail_nmsk;
+
+	masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
+	if (!masks)
+		goto fail_node_to_cpumask;
+
+	build_node_to_cpumask(node_to_cpumask);
+
+	ret = __group_cpus_evenly(0, numgrps, node_to_cpumask, mask, nmsk,
+				  masks);
+
+fail_node_to_cpumask:
+	free_node_to_cpumask(node_to_cpumask);
+
+fail_nmsk:
+	free_cpumask_var(nmsk);
+	if (ret < 0) {
+		kfree(masks);
+		return NULL;
+	}
+	*nummasks = ret;
+	return masks;
+}
+EXPORT_SYMBOL_GPL(group_mask_cpus_evenly);
-- 
2.51.0

