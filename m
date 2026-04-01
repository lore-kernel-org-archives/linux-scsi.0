Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020088.outbound.protection.outlook.com [52.101.196.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8473A0B13;
	Wed,  1 Apr 2026 22:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082207; cv=fail; b=WZETbm2siJxlEWuaeJBvaHL4IjCKALL4llfp7sdnlG96Ezlz+IblKK8l+v+811zid0In4qDH+qqpDGudTHH9jOIQzAhiSmPc5tcZnU7uchUFS59n+bdQ/nlIRpH25OF2ENpSdb/uECuerKwiuZW8otT1IsJIMq5HG/GJVQaRgUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082207; c=relaxed/simple;
	bh=DgAMgxqEN82xG917sYtZeD6HZ9X/QkNICfoFPg/LVRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YUUuf7lkp7lrqS1sDj9qfn6ZTMJ73jr6beC3WpwFMMa/kRLqnUNMXtbWDryzK/mn7v4Af+u3BlWTYYAqqdVGyfmlWg+6rOyJSCtzJ2syaqPeMB3+4RQouE/Fgob8Cbu8DS5eNiuZIoducblXbQrU0E8/nT5PNvOvvCGWI3aFcj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZPREC/Fyp8dwpf0W+w+NoAr+54CP8SxXP1SFJ3iV1C0I7G9QIPFd8hMxmt1zm7D/JHYDN1FSX9Q4p5t23xP6dSbGUUa1KcAaWik402sUINNzzpmmD+it5K6x5mEMS3gVXzv1abxomSD4qpxvGkw2izrj4DltK4DYji0Gq8bWtfBGjmUV5U8ju4ELyHKdRl+DkXoKT7DTCoRSzKBeX03WOgI+2hOel2aA8exQdHAHktQyxcwO5cEo0vuHmmK8HRTQUlwfC+SLAxrDxHza7g2UsO4H6aGLeXb2C2OT9/rv30SGw9aG2Hyr3FpLx7Mmr89nQ1oSr0FrvXFEooiG19uGOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlGlRDQoWoaBP38ufUIvZwp8c9yE938qEnUmEfpuQ/s=;
 b=TBwvnPQheTIetwGNP3LZUlr0cHVlL52HdNjXCU6RyKwCAanQLqwet4KJXHFyay9SpJBOUXkUaeutYk8WFBfyCkKwNPTg5lmSg7kdOS4ScoF87q5CVJxuxiKjQD7x3uMd22yW39VmiaRBC+z3zi2CICIyQFuirU/DuENColPCuJ9BNLBYkA7AEmZHvaP2U8I9sUJ0ytfG7rYYrWsTbKg8EtN0a9gn1hsRdUxkTbulDpCQK/q7HM1sutkraYG/JkMBwtUSXD2G2nSucGu6/f+dwYyGN/29mpey9o6eoHk16aw/ZuEXWFpeHQsTnk/VGj8UhrUN3u+POIN5nNQuTN3O+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CW1P123MB7844.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 22:23:22 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:23:22 +0000
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
Subject: [PATCH v10 02/13] lib/group_cpus: remove dead !SMP code
Date: Wed,  1 Apr 2026 18:23:01 -0400
Message-ID: <20260401222312.772334-3-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260401222312.772334-1-atomlin@atomlin.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN1PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:408:e2::13) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CW1P123MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: d0c514d3-fca0-4944-2693-08de903d4906
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	StqyJ3xOv1V3T+7CBnrIdVnlmKkuJ7xVa9nD+pKFYtIMxZXR7FgGeDZvcSCfYFDH6B49PBLhdsF0rYD3YW+OQxU0/Q0zgPuIRvE7eVq8OBT0J1jcWoutJ3NXgtbYyWQSt0lvcoAm2fcnyBFQcyTdsubJZ3BVPTuZmsbxdf42tFVMkRvJ+1JbLnh9RJI9e0cRTkef4CACyEUmzqwr6pWceWeehtfLvGZSxMm+8NqHhPNdrSZv3PUuWGdrS3qQApeMD3DsrcWOMW/WR99QMr0qOJhkqiwrZ+pxpZlBGf8xe+OsPonjd41LCKcMgDWVKRSJ1u5+Kgo3aetmiwER2WDxGeXcJ1Bbq0h7y1Ff+a36qe+9nKkQoMr/qvW+w2cH8wyhGlHa3UWz4fVlRErhWbD4555JXNs8Gbc4KZLMEu7Z/y3iL+CoWjIstZPjtvnZtBenP3xJIMR049IKnRbwHnGmKqygwZM6shB9y1HnceJxu6lVYhVGM/Oo+sjrBKw2/n47hru+ZX9s3BV3fdhuGcz6ljDGrRF9VKNhMrwdztgZKtv9mzW/Q6iSkwRhaqAiU0eYurS1ERxqb5oXDnwSvAPRNJQT1torGKQmRU060ceCHGWHJdcOt+MdddRw1SFXb+MZa1Md4HrUCFJbvOAhZ4fzE+UC82H1P64lGMW4MnbmY40WCKI0jEe7gZ0pHpmpN8E4361d2945vHEfUDayoGsAKNstAeFHAclcvG6TKuJ6sS4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XYV1pnDdPCj72Mjejwtikf6596tnNN5OmJVEeIKpi1ybtpg/YKfeIgwEdxRP?=
 =?us-ascii?Q?sKD2WwvcjnO2fT1cqpM2yC3cTXEUGgz7W8frrovSCtKc0tx4PdInknqqMm12?=
 =?us-ascii?Q?Ad8irSxeT3Du5wviQcDJubwqnjAyNpeN2o4/mOVhb9KeUQbFofojT3lx2VNf?=
 =?us-ascii?Q?VhYRj6lX3WyrQZ8g3kZJqAlBjb1HWxen0MVutwxEfekugXE6b/GuO8mnMSRS?=
 =?us-ascii?Q?abSJ9PM8rKjjEWFLR1Ym8Wm8pn+HVr6XCIOm2ZgDjeGQXtbOZV+BEIclEv8j?=
 =?us-ascii?Q?B+z5qcKIsAsNtW+7JlYqmFk39LqEgFtsMw0yZHu99aq/7Nke+m0vS0wkS58o?=
 =?us-ascii?Q?ARpOoFNvz/IJsBmT0jyS58jvS9QKFZbe9EZL61ay07+hQBGUoI3zL7AbYdBB?=
 =?us-ascii?Q?StnihRIw4ERieosqmghwTPug/5vfhPuTQ5oLi0Rl+qsfOTd03FCH3xxhapSs?=
 =?us-ascii?Q?cvIhHXB7OYENypgBC1C84hOL5GWPVu/8ueJm1PfR+MzRL++wgqaPbcpQdb+K?=
 =?us-ascii?Q?2dLOnsBitDt7vjQRrUj/ls3Vjn5XcYYGPOkUdKG8zp/9/kxEz+2q1yjazhwo?=
 =?us-ascii?Q?ZLGpwlp16b9TInpvaMYTz0t7OnF/d7CSQPOWuxOaI4rxERLlDUXFlczJQ+jx?=
 =?us-ascii?Q?YspFoCZar0+hEoTCmgIRedm2jsJ+mik6msUfZJ4Z28ZxDaXSbBSnn+emiqfP?=
 =?us-ascii?Q?8PrAkCKPvJMEFW9Jh7puU8FzW7C3KDiEm+1S+YWp66iQwPYBVCgXmLD6OH2r?=
 =?us-ascii?Q?8PThW4khjfySYc2pqIcXh9lrxlU83UpcxlGtOB/X6TL8FhZMpcPAX8lHf0G/?=
 =?us-ascii?Q?9Ps0DkKjnHscELJn22dqrUxllGmRNWkRkpzWDjF+q4Km84Cc52g28FfhFTop?=
 =?us-ascii?Q?l162W7wCmvX+sUB5RS6DGX0tOHLF7dgEmx6ULAKlpcXfI6eMs1IJjlcOb8PN?=
 =?us-ascii?Q?CV5Ixct5fZ3mNRlvSsGZ7n3Nk6HqsWvIe0355H+vvGhDf3OUHl3yqTP/p7iv?=
 =?us-ascii?Q?To9whtBaF34k2ReC0iUTM2f5GBztCE8SHLGtY9T06rPbzYuh9U6737teuBFc?=
 =?us-ascii?Q?REHdI/eGvZ4A0xyymio7+eesu2ujAerYSy5h80yTP2OCGxIs5qMGkOQKQh17?=
 =?us-ascii?Q?KdTpjvCyvcv7v2B0AXtruU+c/EueZb4KyptsRJFSviUrCjBNtqGM19soHJBQ?=
 =?us-ascii?Q?PaAMdEJpITC0b7Md91PxKqfUzglz00DStqbbHKNJrf87D8XNdbeXsuNmgLjv?=
 =?us-ascii?Q?A5P2ijbk7Uf5Na7UF/1wr3yZG3GmTJ0OM76uRCcfEQ6eAflLSdEay4KnvVA6?=
 =?us-ascii?Q?eQ7wupxQmrCnuoHDtI0JMj9YU4VQEcY60tb73ctQix77SYW2GQgx9nvKLImf?=
 =?us-ascii?Q?+FuoNPF/t8+lkmjJGMuhkBl+PfZJJeYggPN557b6H4kLwlaackotXD4wdBhw?=
 =?us-ascii?Q?xu2gXjJiRMhwoL02+YZXQ3dRc+SZhdI5KJDZSWZsQhv/BjdzvOEpDVUopFkx?=
 =?us-ascii?Q?BTvxd1yaeIgkJs8PcaoGruUjCWb6tAbaMrhMpM6QcQR+ozo0UX28V7CYfWpQ?=
 =?us-ascii?Q?0lAfv9uYb2yf+NOJ54Txo8Piy4l2k+AQrDApn7uGtFhd6iw/mx4pezVveXs3?=
 =?us-ascii?Q?hiqfwgPbcSbVVrnXleAgamfHYmO54KfT+aYlsGHsbgfxwcM0wVZxJ0ErufD7?=
 =?us-ascii?Q?oFZuU/KQz+k4LIYUl737QovlaqfONky7z2OFr3y6WJPIz9got2qFuu6zO8Nw?=
 =?us-ascii?Q?6F2d4hzZCA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c514d3-fca0-4944-2693-08de903d4906
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:23:22.6679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HIJc9GPwzL8fYrF6vIbyZYNxwtW98gE4vNDfuyKKU26a2J5aXEAnRaAllCGxtuZg4wl93bNiTs2acjFLrzNoeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB7844

From: Daniel Wagner <wagi@kernel.org>

The support for the !SMP configuration has been removed from the core by
commit cac5cefbade9 ("sched/smp: Make SMP unconditional").

While one can technically still compile a uniprocessor kernel, the core
scheduler now mandates SMP unconditionally, rendering this particular
!SMP fallback handling redundant. Therefore, remove the #ifdef CONFIG_SMP
guards and the fallback logic.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
[atomlin: Updated commit message to clarify !SMP removal context]
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 lib/group_cpus.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index e6e18d7a49bb..b8d54398f88a 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -9,8 +9,6 @@
 #include <linux/sort.h>
 #include <linux/group_cpus.h>
 
-#ifdef CONFIG_SMP
-
 static void grp_spread_init_one(struct cpumask *irqmsk, struct cpumask *nmsk,
 				unsigned int cpus_per_grp)
 {
@@ -564,22 +562,4 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
 	*nummasks = min(nr_present + nr_others, numgrps);
 	return masks;
 }
-#else /* CONFIG_SMP */
-struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
-{
-	struct cpumask *masks;
-
-	if (numgrps == 0)
-		return NULL;
-
-	masks = kzalloc_objs(*masks, numgrps);
-	if (!masks)
-		return NULL;
-
-	/* assign all CPUs(cpu 0) to the 1st group only */
-	cpumask_copy(&masks[0], cpu_possible_mask);
-	*nummasks = 1;
-	return masks;
-}
-#endif /* CONFIG_SMP */
 EXPORT_SYMBOL_GPL(group_cpus_evenly);
-- 
2.51.0

