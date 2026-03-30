Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022078.outbound.protection.outlook.com [52.101.96.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017D13AA19D;
	Mon, 30 Mar 2026 22:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908671; cv=fail; b=pu/MqjydlRQs1Ne4LBdjYnIpI8qBU8XmpIwt1itL4vyL0VBIi6bd4K4pml0R90nkPoBSqR+u1fiXkKxaWzSRR1wjSv8UUBdHEzyidoGvj2UY94YUzAlqZwbbv9S/VFjcl4OVghtDlSMOpQBYOgCRiglNLCAE+HFUX079ynV6mkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908671; c=relaxed/simple;
	bh=THpSiGAGqaVKK7VUGXeHeN/dZEVm5lV0Gb50xYFucew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=krg839TLz57bHxH3J8ya1Da6olLfRkbMwOdrsC8mHbSJMg74FYsLQ3WiIyUh4FrBmz2x6H/N/aqbT5nLULGGNv4G7a0GGRXZEA52JiLVQsd3W9RoT9sWgUfWjaQVQhgn7hYvGhtxk9WmusDSlJ7Xv//LOrlXBXHHhqV+oyUyllI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YnGIyaYofg7F066+WhU+MUK4dw0vxhFsLX/9gyN/SE42SeIQh/zS9iDTPLgxTV/JJ73hwMIDkaPr/jMmjJIZhuxhwBuE5eyWO+kfFkuT/eMHaCKXYJm8g4j0nkuSbbV9rxCLRBKz2myZZSXC1W4Dde8a0drpCtHoiYk7UbTWutQYySSBpDa81Dwxr1cJDab9rB6/q/DXbskWrYwcAafhvc5+lHSwG2AHm9Cnom+kVojBNUES9dV2wLNYENZKLMQsU0i3JCQG5QPXIFA/q1CwrO4c6CUdyAcn8BIGf9Nw+Al497pP3YcGK43o7kRftPK26dbyljeL+MaJcYANYzhIuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3fH192XZWmJdTfEcIr3Tf37LB1pME6rTt3OO7j//a8=;
 b=jjBho6wcYrxa7z5Kz25Wpmfi6sGTr7PhNoBfZHIZwS8S1MkdxiFeh+T71Z7Xru2LhTH8+qZigr+Ic2Xk03XV3Uo4nZd2yEW8SI+3t3okiXoq2CFq2XSLdHT6nzyU2D6aZEUx0KUaGCKj5VMPf41rbEQ45eoYOvbuxNTUUY6uIG3sAPve53OkDoq7Pd7pv1R1/cl3MAh4X0RtTK1v+B5BrEw1sKk+bPORHIuIwQv6qX0YOyhhBJbH4gD2zA+0RERhezd2qgSR65WIMpaY7m657AQTFC9NfpHVopNWERYV1OUnUbzcwFBnT5gPF21y7/aHEeHg3+yrHJ62esc4Lah20Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB6512.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:186::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 22:11:05 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Mon, 30 Mar 2026
 22:11:05 +0000
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
Subject: [PATCH v9 04/13] genirq/affinity: Add cpumask to struct irq_affinity
Date: Mon, 30 Mar 2026 18:10:38 -0400
Message-ID: <20260330221047.630206-5-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330221047.630206-1-atomlin@atomlin.com>
References: <20260330221047.630206-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0575.namprd03.prod.outlook.com
 (2603:10b6:408:10d::10) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: af3711a7-91b2-4a70-d12f-08de8ea93cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	MFviWz41+Qdsv7lFMC8UBlZoTU0pSQhwyJMzlFjHTfQuIwCxwFeQCTTXE0aeFAUGzwqsc3cWWJ9II92tVEd4jKb82KsLG8XNhGkE+p4lHNyATGjF7TIzMsEanDbey2PFfL4NPNzNM765NdTBfV1Dvcietddde+VY6vIgEiFzarTyaYPsfiDw29YGLEDO+NFdutYm2Ofvoil/jmuG6rUVp2ngqvRvJE1VtOknoFh6AQUdfBBCDjohtYyEl3ujJsFYK9UXgno8SnjutezX/ioKmRGJ/hTrdszfx6KwnKZMgFpBdiy544vwCSnhCsRXiHD1sKc3zF+uJ4bm60hWV5C+xeUabDwcM14RkoGfOpt7+JRcS5cjTgc9+PRYBceKY8p3q6WDVmdqeFVlBjC4xHYQXiZiqGY53gNEAvFr2fCGAPIcIdFc5atBTL0hxt85vXMg7wEgFbFlxh+5pqLYk7oSO2JZJkxuD+MzIajHL9OMmLyTxyDCq4yH7oFnbZcGMPMdwz+KmSzb1jIHx33OdsdiDfsOQtEsUndlVk8C31tHf1d+cxYytRPb8y+2AcDUB8Py/Hq4lM5SFAsCkYvP6KWnlSEYQoMnCc636366bHpWSjtve+UiQ/FI93vwxGWTArGndtDG9f5+Fc9pgeR4uAgRAlS6stcIH4zzwVSY17Z3ZWoeoF9Tjn1FpBkvvRccH/sDEJeK25oarlwhMUyPJx4gwMtOaX8KIDZfnuH16lbkQeM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2pfJfiQpo4OJoQos9FxB7ALA5Hk1CV/tfY03EsF0lKicN8yFJU+DTJtBLL0Q?=
 =?us-ascii?Q?LheoWZpu4QHg5RZ7YrZ8EzRu55hM/foPYUjgyT5dVJLcRX1bAGBipJA1Z3Q/?=
 =?us-ascii?Q?Mpb46emNvKpbzx1PeeH/UcDeqXFRc5RytX4lYaRcviwLd+jeO65+sJLylRbS?=
 =?us-ascii?Q?Z+W9MtzAVKHVoM5YWYdsik3lm4uvZfnphEPeaUXB8ilxGt/D8/gJKU0I6IvS?=
 =?us-ascii?Q?vmS5dUlhgqAKovToa4YkqaEK7B5qaNFjYZSaUlAytRU4a0S+qv5uleXt8D0m?=
 =?us-ascii?Q?O32bDgvTxEtC4GuJZyToIePN9Nm9km1KuK90v7goXbaQdBLnSlRn9NWI8b0E?=
 =?us-ascii?Q?mkrUk1IlWV9p1ggF6hr2uGxRNrH6vZv3YqrDOts0SNaNxTiiL9n3MMKjcG4a?=
 =?us-ascii?Q?6PCJsjp8QQe4KOYsTYVl0ExSRBf4WuZsuc4K1wxy1AoI0IrlBrOdCHqpHTBo?=
 =?us-ascii?Q?m503QbRi/OGrsZAUGyKH/QuCnkXweOAzddFR4eGKZ5w3uhm8IgpmP5xHXvNn?=
 =?us-ascii?Q?ZQ1BdTU35UuQqmd8D/0VsZl82p5AH3VO0H/7AHTe1XHsYv4T8ltdc/0XMJkZ?=
 =?us-ascii?Q?iZj8BWd2/T3wowVgfC7k9euYuoXGwdVYuE+BsBHRpeJKSquq9efn4VIMIHU4?=
 =?us-ascii?Q?Qcsw29PKxRwPCA/RwdgZHrvHcPAgvwC6hzl9tr75EcQ2SGddSblT7HRMeslE?=
 =?us-ascii?Q?iQxN26ZULBm98ojcYKi6zOLeR+P4/9McwTipVoQRV+JW6XIs4X796YvWQOoN?=
 =?us-ascii?Q?j+WJRXrl0rdBjju9VKZq4Vg/9oMs1d2yfREwu+O/08KHMWU+XcWOuP4l2jei?=
 =?us-ascii?Q?MvHjxkBEvBlOB19Mj6j7NGjDfLUsyxvOt7+t/jRXnjAeN2XNLwddEpvQmCbl?=
 =?us-ascii?Q?JArKQdcJvDusQaliIXXR3xKudv5sXxs6GAm0/YKlj0L7iTC0+g0tY80s7ziT?=
 =?us-ascii?Q?/RIAVFxrcDN5Wh3KTEwEPSiVs0ZvVKSfGihh32uDkarE/MZUG1O4TZuFklAo?=
 =?us-ascii?Q?axSVc7DHIQEQ6l77pKR5THtO3XGi4CobMGiHJNLqE3A9/V/40tPXi7P/pqXR?=
 =?us-ascii?Q?Gx2+jgCbDeAeMvP84Lvs0ZrMAELjkLQqp3sXeJJRNMEcHwD1q7qEQdyawDOw?=
 =?us-ascii?Q?J/fMZ+gZnugFWIplp3Ezp8t0FFAlxmhiEZm5/bf0U7jQUKF0wQQKZ1UODVUp?=
 =?us-ascii?Q?hQcDD/27RomskYaSWBlGEVbjovewXSfa/K2BroMB7xWdd7D3XMMEZnlEgreB?=
 =?us-ascii?Q?7VM+V32XO/LbrgKOi4a2aUHEFoCIxgofcjjlrTTglEjqglW6B5IfZMtSyJgM?=
 =?us-ascii?Q?enXTbsviJ0p7UJUCQoHgf38tOFn3z00fDGLr+FL0X6uiys2qYdIh4gp6uCYG?=
 =?us-ascii?Q?Or9m16kB+K4paWvwrC1JPYKaJi3q/x4YGjCV8/uLXJIAnxF6K33hhp/NQL40?=
 =?us-ascii?Q?UgFh1CwWTSR3/LyD/NSsq+oLhETnmBs9pKUH+d6kpar0Y0zqYMdu5GFrThlm?=
 =?us-ascii?Q?7fZ0vuzDvq81zALgaOTR5UTyMbixHgiHDvo5ZGA/aAHEcBDjYAbW7wo1sBS2?=
 =?us-ascii?Q?mr3shVN62uFpK22gBmIhXYcD4lDPdAKALiun3L/+jyCu3RY8m1gODFboXrBB?=
 =?us-ascii?Q?EP6pQNqIGrWsZNmgmnBj84QfywWiBGr64nC+OwOkqm/X/DYzvLEW9SIllDjU?=
 =?us-ascii?Q?nZbK8hNh412wlU/HSZfoMz5gRFTEuRTXRisfj2ZtkMjkdeiSeEVBVb3kUMHw?=
 =?us-ascii?Q?DxaOonBJEA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af3711a7-91b2-4a70-d12f-08de8ea93cf5
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:11:05.8304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2IJBF5IaRIOAmAh7iSla9CsL5j6ONS6QYo3HFaOJHrA0syDa37GhPkTM6+fsSUbHOzLlLeEhp/s1Ve0PjdGCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB6512

From: Daniel Wagner <wagi@kernel.org>

Pass a cpumask to irq_create_affinity_masks as an additional constraint
to consider when creating the affinity masks. This allows the caller to
exclude specific CPUs, e.g., isolated CPUs (see the 'isolcpus' kernel
command-line parameter).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 include/linux/interrupt.h | 16 ++++++++++------
 kernel/irq/affinity.c     | 12 ++++++++++--
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 6cd26ffb0505..afd5a2c75b43 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -287,18 +287,22 @@ struct irq_affinity_notify {
  * @nr_sets:		The number of interrupt sets for which affinity
  *			spreading is required
  * @set_size:		Array holding the size of each interrupt set
+ * @mask:		cpumask that constrains which CPUs to consider when
+ *			calculating the number and size of the interrupt sets
  * @calc_sets:		Callback for calculating the number and size
  *			of interrupt sets
  * @priv:		Private data for usage by @calc_sets, usually a
  *			pointer to driver/device specific data.
  */
 struct irq_affinity {
-	unsigned int	pre_vectors;
-	unsigned int	post_vectors;
-	unsigned int	nr_sets;
-	unsigned int	set_size[IRQ_AFFINITY_MAX_SETS];
-	void		(*calc_sets)(struct irq_affinity *, unsigned int nvecs);
-	void		*priv;
+	unsigned int		pre_vectors;
+	unsigned int		post_vectors;
+	unsigned int		nr_sets;
+	unsigned int		set_size[IRQ_AFFINITY_MAX_SETS];
+	const struct cpumask	*mask;
+	void			(*calc_sets)(struct irq_affinity *,
+					     unsigned int nvecs);
+	void			*priv;
 };
 
 /**
diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index 85c45cfe7223..076a5ef1e306 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -70,7 +70,13 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 	 */
 	for (i = 0, usedvecs = 0; i < affd->nr_sets; i++) {
 		unsigned int nr_masks, this_vecs = affd->set_size[i];
-		struct cpumask *result = group_cpus_evenly(this_vecs, &nr_masks);
+		struct cpumask *result;
+
+		if (affd->mask)
+			result = group_mask_cpus_evenly(this_vecs, affd->mask,
+							&nr_masks);
+		else
+			result = group_cpus_evenly(this_vecs, &nr_masks);
 
 		if (!result) {
 			kfree(masks);
@@ -115,7 +121,9 @@ unsigned int irq_calc_affinity_vectors(unsigned int minvec, unsigned int maxvec,
 	if (resv > minvec)
 		return 0;
 
-	if (affd->calc_sets) {
+	if (affd->mask) {
+		set_vecs = cpumask_weight(affd->mask);
+	} else if (affd->calc_sets) {
 		set_vecs = maxvec - resv;
 	} else {
 		cpus_read_lock();
-- 
2.51.0

