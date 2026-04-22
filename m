Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022132.outbound.protection.outlook.com [52.101.96.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AC82EF66B;
	Wed, 22 Apr 2026 18:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883956; cv=fail; b=uCUfSMmW4mOtjRMzK6HqXNRtL9+thSF3SAk8DxZ9xrVnV1j5Mo4A5OXlQoLgPSafa3ZwRojcrYWzhwZ0RLR8JVAXgcxdeOqHbWkjnn0neR1nMbMPtjp6ooSp3SIh4I1DaUR1k1RZ7Kb44uw8lX6kcMnCBXXDlSfH8E2GhaGb3AI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883956; c=relaxed/simple;
	bh=JNCDsLxV0E86ua2mZIR2KuU7dG0bby7UF9GEUB5MlRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GUo1Eqm6iZNEvw312q0Cyzll02FzbS4Mf9SW8Xei8nYuTnBGHESLpTrndWJA7lNuWdCmANAerZx+QI5n7Q0oW8rObYHDqeB5iV4KWcgH6gYodQE3AJwMYlGVn6F0aUU11bO52LeOh1m0Nj2eUPTHpUo1gI08twNA7eOh0+QUsOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ksF4VYbrIeCR+VK4t/UX1dE6sdKgedJ0geJxE8/tYV+vCy6aM37Ej/WiEutbpRAc0HL9+cEh5K1yVWlPxEwblD7DxulFkFX9wNNZw810K8x3Dbdn0JVw7yLbULZ2mY1miOkbZ+XVeOsoTFIE0Kmv/MTT0k4xQFDvGcIRQgQb3y9KcRXyfi3mJxy82sbhCE0SNPqcdPNGBqEqE7Ukrqg1rDavIKnV6GbvbCIOfK1nBYaHpsQ48xkxCyYGE0jh0+pGSQ2Ga/87jfOf4xmj24eLllqZjlO4wg1JO2R2sqZZgC8H3iUTSb8rkKoJIEVDyw+g2MOKegiWS51ZnXEMlYdL5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GIVmbBqCcsNkkK9tYkUbVqdhjnyM61lAyueBZ0VJ4Z8=;
 b=lK4jFySCJov1L9zcZ6ewpxSesaZP5gvgrYbCYq61tM8WDWbgxyf2blfJdLm8ciFXWmQVRSNs87Y9OxRygRz2bOUTPP7gAUPqEYpRgpj7UcYqFWbcOp8xP6UQr9S7ngfC3bfWX9lgxbklJ/x6Bi4SzNATHrAQ97pURo750jIPqCjRKFP/eJZ0R2tvB7RYVj6ucxVmiGTXEl/vVOP5+P6ttvrOrSmUKw88q2YATiNPxROn1+72CG6G44BL2z4jAn1Nso/MsySK3yGEmro1N7XB6Mfg8sUQjbpnpGx68MErOQBQHsn83JDyQb9yNaED+vXyeatlQJYdSG4iUk7IT1bCPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:52:33 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:52:32 +0000
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
	marco.crivellari@suse.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v12 03/13] lib/group_cpus: Add group_mask_cpus_evenly()
Date: Wed, 22 Apr 2026 14:52:05 -0400
Message-ID: <20260422185215.100929-4-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0324.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::24) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 08139b00-45d1-4015-21e4-08dea0a04fd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	agvNpsueQA8jZ1uvEs6GnXKczHXYUhuU9wGhoNy8XE/M1qPItby48keFAanXy6TSpMVECKgMz1c8ZhtyDMiEHj+dzqI4hFU2jLeQd0kkdNnjkRb/vf3GuEvIzCSwVC5ZAUll5meHeFzHo71Wf+hvdLDWC8VEmoKN86vvVyPFPKrr1+TOYaQn9aLvuSxOd9ojf5SyND+mwMH1BPxLn7WVRJl5jxl0dhkB4DBgLIorxFjfqMexg8M+iIbKqTSWHSIwzhwykxVdpB1zRx+aldXaZpHWYoJ7D4yQJ6lpcfNM9SfJoPOYg0CEJN+grSvyWpTa7M91RM7IZPu20D8MXBAKgS1KzQd2CeLuKZMz1PSccVXwyq+7b4xRN0vfUyEqloe5cItLNBVLQwXaHNJUatlUzYa/FIfRUrEZK3zl1Z22vsb8aRsq+Q0JTmCAPJiuPxvI8reGpzNSgu1IIeBb+p1UXlOaPKF6ohA4MWZ7qs6mdEGA795zn4kcJK+j0IBZWsULA5Aw6YHBz0c+3EhbVm8J7x4dTehRmw8zlw57zj6XMjoEkZZSAgWxSPJmiUdVCq0z+89Wh90vAXIQCRPRIrBsTh2R0jKs/1BSM4ZXT28yFPfBqqqLC5EDeTrvbxTaWaUzVrlMLX6DDnLXbU/hT3iW0AdizyfzWQkU2lM46WrIzquWhOVEIXoszP03NMHs30M7p1j8CUi7MfbhZuoEaR/ndqi5B20G6juIAXhGq1alf9o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PN+T3Mdj5j2Eg+h6NPWyb+BLQasLSH6Pi5qtsZMinmLEj8Ma/dcvoEmNlkF0?=
 =?us-ascii?Q?Xlu2z2591n8bRhEjb5YyYTOaoX4oClcybT1nmzQ5w6MYS+njcfuSK/FdC4Fo?=
 =?us-ascii?Q?75beGDuviwfcrlQ/pSaCNjw0X4bkzGIFfjz9qWf5astlTaiFFry+tinLTMmu?=
 =?us-ascii?Q?8Vg3S4dejY5sJERtINVYAAqlWr8Ud5kxT8Bh4GqfI9VHtLn9jvyROwpptc95?=
 =?us-ascii?Q?jN2GGLqLcwQQh1d6+jyKKDU2pEUwMP8xYT1H4HsvKtXkiaAvBjdXTnYhQb8X?=
 =?us-ascii?Q?hlP/hHOoUFd7BTibsKg2gw0Fppncmgx/6biREI6phInoztj6p4BqMeZQCR/a?=
 =?us-ascii?Q?v9Er2uZff4ngw1lWu4ki9WQmnWuaklzRe26+hKzaXyPtA0yi5Yb3KTbgJTxT?=
 =?us-ascii?Q?gRtoKQgeyPwHsQ1fKRv/caDZSqHGg5M8gsfC8W7NthguZCU/CTd3BOKHZGwC?=
 =?us-ascii?Q?IQyPlmev6VIv4RC6jyvLmP3+jAI+iBxl7grMseoCh/hWTu6BlXrOVwRPe1tE?=
 =?us-ascii?Q?7RUXc5pkwYbEgowATaLrNH40zlZP9lpTyp1MOY0NKpjnzZHFlyGLUNOmVzJ0?=
 =?us-ascii?Q?oMwwq/rMEA7iANOhdCebFFHNgR1rVD2uNysXyrhhSyKvWC/tOs4bglEzJQ3g?=
 =?us-ascii?Q?X9ccreULPRDrTyKuKs5Ck+9ot1rYwb+ad3QC7LQEenROoJDm7SSyC6lzuH6X?=
 =?us-ascii?Q?+DdHG1Wz5SmI/YQEtdkmpWblzt8dfBx6PbxsfrSc51hepjdDUTQV3YqbHRBR?=
 =?us-ascii?Q?apAdLVfyQ0OyRQLx/twwS1Xxz3RZx/lCv+vxVzsj8Ko0q6JmOSX7StM9F6VA?=
 =?us-ascii?Q?qei5wMjMlwSzSjTvN/O6G8nT9qw/bgaHYe6z47NzpC+mLw5iv/4hQ3voWFof?=
 =?us-ascii?Q?n8l4QnhSHjKNNmNtl6xKRBIznx5yG9jjj2O1a0sS/4ODzmJePi+1JC629dYO?=
 =?us-ascii?Q?Im8qcgXjxHSACI/UXWhEMSfNPnYRY7JwrwPsSok9NCFQtSUTPtcDDJXlWKXj?=
 =?us-ascii?Q?LsrKOUXImMj7j7KfiR5ZKgKz3xUQYQ6BzUZVqNybuLSAorR5i7VwbUfB6bys?=
 =?us-ascii?Q?KkvZ/XLjeANES+MIPXxp0tkoLYhEY9s3t91l5jR9RuB2GWD9iMMjRr6B4AlF?=
 =?us-ascii?Q?A20jhUCFt58eREU72Na4KUEWyr76tKvr1+7Xc8YcFwMxJvkZUt2GJW5oWec8?=
 =?us-ascii?Q?OQgjQvBsLHJ82LkUMmWWjMUTS8xRm3gg9QCeI/iL5TQXal9BbllQ+llwVGGC?=
 =?us-ascii?Q?WuAaQ8GF+RYGYRSm9mTSaH46Ow/kS6hwrhLgUE75pSAmSDKNLsvCWEqUajX3?=
 =?us-ascii?Q?CO9dBPDRvgbnoaxRTMV1RbTaVZGQK524zN01J8veysq+n+YWWVfUwqgbw+GM?=
 =?us-ascii?Q?iDWteaSUH64P7hnV72JJ5UNfkft/x002upHghcwFbx3PW3s1FwqXYx0hsj2E?=
 =?us-ascii?Q?nQMvaJwpCbVSOsgeefglYM52tFAv5k9ndLPca/vRKbR5hQLmACgXuZB8uvEj?=
 =?us-ascii?Q?TKOotPFh1e7LX3/QXyOEgT8N6YA23AHTGwUovgajpsDWMSDyo+2YZVhzqv8A?=
 =?us-ascii?Q?TU9HX+lvLiLfv95rC3d6r/VUlbLaM25oJW5VLVfmr/Xlk+jEXiGl0pZp2BRU?=
 =?us-ascii?Q?XyYmhGo5Ccdge/Ohh298tucd4lkKUrLS1oMoZgy48oyb25IspLkuXxH0cXQ7?=
 =?us-ascii?Q?qgMFbeC/oZbTD8kLPgY/f9iTlIFK3Sv8pICffAjfZQY0v0FnQpi503ULoiji?=
 =?us-ascii?Q?9ipBUjGMPA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08139b00-45d1-4015-21e4-08dea0a04fd0
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:52:32.9178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T86uiALmd89p/BFK+5f+E6S4oRepO3jEuB6SfyBuh96Wmie8GOanja7iAPxXao4MpFeo4coxukVDuF9NgWbloQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

From: Daniel Wagner <wagi@kernel.org>

group_mask_cpu_evenly() allows the caller to pass in a CPU mask that
should be evenly distributed. This new function is a more generic
version of the existing group_cpus_evenly(), which always distributes
all present CPUs into groups.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
[atomlin: Test numgrps == 0 in group_mask_cpus_evenly()]
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 include/linux/group_cpus.h |  3 ++
 lib/group_cpus.c           | 62 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

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
index b8d54398f88a..c55a8970db2a 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -8,6 +8,7 @@
 #include <linux/cpu.h>
 #include <linux/sort.h>
 #include <linux/group_cpus.h>
+#include <linux/sched/isolation.h>
 
 static void grp_spread_init_one(struct cpumask *irqmsk, struct cpumask *nmsk,
 				unsigned int cpus_per_grp)
@@ -563,3 +564,64 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
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
+	if (numgrps == 0)
+		return NULL;
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

