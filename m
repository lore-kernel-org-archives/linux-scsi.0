Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021137.outbound.protection.outlook.com [52.101.95.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCE75335AD;
	Thu, 10 Sep 2026 16:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.137
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058608; cv=fail; b=JdsgJl+FVT/H0B3jbe3xY9hxWwAWu1nwkdvmXv8HColmz9R5SUH+d7Awt/m1PibvJLBANEUYXd18xONvylDoDv8gyr6P5T/2X/kGWbyqg4O+g/f9MIL4NdiMUyFtyMfGguI1R9OpuYDRQ0MHU5POK1gDgzphgxXHJS2R5Xf81RQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058608; c=relaxed/simple;
	bh=FMhOXX9RCAx2euVlNyQuX/XWj/9ZFPcrFerfSMNSMPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AG6kgn90u5MzOwkxOhU2QKyROzMD5YuCP8cMMXywZm0+qBqINp1unJmBBBB97x2A5Hm0woKGezmppVyR48CZhQSiIpeRdhvZsAwKBGxQowS46GYvR4xrZ2D/jwmCDXO6WiKIsev1eSr9JlJUHSr3nbigiizFSeZAvrXKFHkVzls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pzCT20LeROVJ/e2XRj64OZy2dmUsG6c32nUCuYdx25KsOpqtxUXsKqAGAGudPmrCVevyJ+EYt3BzCpVh85uOQCQqtaVMtI5L/DLjxx/Dr0RqDH2iK700UIrf3dBdWbLQo9z5s2w0nvJB9+mwSnsmtyUWGVVszfAqTHLt64ilKuEFpeQywYwedzujdoNbhp9bgDDceYq1fAae1NbJjxKIEv4a83Wda9U1La6mH7QtkNj26yumgRSUFTOx+WO4lcdMwBbL+EziX1JyzG5volDTmNLHVfbuRrXVTcSeV2cn33F1UrCVuyMrCWRDaiLmJ7U1LJDioyY87g+jjz8xWe57ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=SEhff9/bgefTf7r9QeB1/zrS9TFkSU6ufea/Lj2wXy4=;
 b=s7RunhUHcghMLF8tM5bQDoEEeVaHDEcQHPentkc1R0wsdBmrQXEqxKLwl+1fz9u0tT9LiTKj5eRDD3Rc1F6WreOo3dCRS6c8XmsD+wAw+FRUyGB6i6vFWvhRWPrRINsXshrMrEXmyT7ObCD9I8B5U80uRgybIaHuwGBGKA3iCe71B8qEpcMZEonH1SpO+5gLS3ZtAuUVyYwWhZDlRUq2ajbg/EvgbqCLlS4P8hM7Kuxu3q2O2TRCc8MRfyq++VyXoKY89J61lEu3NTpfmlaFtzfOciVERIHmnARyMNH9PRJFp3VSY6QRKeoc7IB1bHh7hlYfHr0xsdIeVsQ4jUpdxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by CWLP123MB4179.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 16:43:20 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 16:43:19 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk,
	tglx@kernel.org,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	frederic@kernel.org,
	bigeasy@linutronix.de
Cc: atomlin@atomlin.com,
	ionut.nechita@windriver.com,
	corbet@lwn.net,
	vincent.guittot@linaro.org,
	mingo@redhat.com,
	peterz@infradead.org,
	radu@rendec.net,
	akpm@linux-foundation.org,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	nick.lange@gmail.com,
	marco.crivellari@suse.com,
	rishil1999@outlook.com,
	linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v16 8/9] genirq/affinity: Restrict managed IRQ affinity to housekeeping CPUs
Date: Thu, 10 Sep 2026 12:42:36 -0400
Message-ID: <20260910164237.500196-9-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910164237.500196-1-atomlin@atomlin.com>
References: <20260910164237.500196-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0746.namprd03.prod.outlook.com
 (2603:10b6:408:110::31) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|CWLP123MB4179:EE_
X-MS-Office365-Filtering-Correlation-Id: 03d92886-fc9d-4831-bc7a-08df0f5a9ecb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|10067099003|56012099006|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UkGJYRBfC+v3mCkJiKlELO3MAJIcm/aF88t2mv/hiwUD9ePNMl2WugTrtq7as/E4lq1R1iusKUfu2z4kG5unWJDI7VmyadzO4Bskvpt3JO2cJSiPrBSe7aZUUJFiKuC+Asc0MdsQd47WRdQQCfGghepkTXzFbtSqZISpS2VL9aSftjmwA5N8RKUMUFkNfC9cSZq/Qv76qinoBxgoCB/E1T4SCrSgbFjGM9sZ96WUFu+cZrNXS7vGX1ySvfcW8cRuovRtkZK42yiOXraB0rjgOsIjFKWnbmiogMtaxDQm8bLERjpveuiuYM4hvgVOLbD9131i0MREa82JLF6r0Dp15z3m6YOuSaDR399trpmWQmZ1koHAkckxNhmP/F03atPySMrQ3qjRW4bZZ3qsu4Mn8ki7KEmdHmDkkmkN3cBroOAv2TMScYUODHQtBsRw04qOZVsyRwPGkzZhR3E7BhLlGeUKVZ40JDX1b8QNjzBNPVvXnDuRnnJjbd7dlHkW1+I0X+uR0PVeU0W/tQKctEBPEIRvCX4wD4cItxYs3Fpw6QkN71ho4GUHtLlvSubKu4MBL0l8djvUMpV0X0Os7bN5q/Evr2C9maFB4GxsrUjKC79G50urK2LkXVh1m3frjGQ16rYEz9ZR6OK6235ZorIuigDjh/A/FuNEjM5chMLAYmA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(10067099003)(56012099006)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZHPLJj87D7GaXFsS1HwJkCtUqZaOKYGGBCuj1xTnBsALj/ygdhFbKm042aWo?=
 =?us-ascii?Q?uOpwLM9ZFa7HCU+znnKTfsSqieKaH+aaCMjIGH3ySOOMADquj/NfQO5LYwHq?=
 =?us-ascii?Q?YIAhsiSM6SyNxGaLDrtV2oDzgCOEfjbuhKGvzx0Gnydn8L906X1PfLi3Xz7S?=
 =?us-ascii?Q?SIwwL8EeHg5uiXRroEKMshPpKdtdwiB+J2hnAD0phbRTJOly4Mcj+gzQZ3gi?=
 =?us-ascii?Q?j9wI6nEmDUUxUVL81DRwvaq52sVydvfpjNoMFyBIaLViZ8dybFPx1CWd7gD4?=
 =?us-ascii?Q?PKoeQR8v6nm73GpeLBnC9YN4EDMPjaicFHB3EuQnNXB4W8fsA8ia1qQ2DXt3?=
 =?us-ascii?Q?SLEg1vHL6XlBJPPv9/aS3L2imgsnyfZcN6k7DGuXyJG53/6bw4+hL+LWsvyT?=
 =?us-ascii?Q?6/0oLON10o6DMXw1DfdDRC7LiK5mpmTOlLp0aUyWArHeCEb8TgkAF76m7isp?=
 =?us-ascii?Q?LcF6l4iaQd1Ghnhs0GbANlS4D+HL8FT6l769A4avM3kM6faYWxqQlruSuc3X?=
 =?us-ascii?Q?OOBwyBJpzM8BPnOlcVF/h9UbFw/79/UUAOBdU6qdvhozbBT6NrY9Qe6mfJ0w?=
 =?us-ascii?Q?LEJmBD/CDWaHTiXQzkWiHt/W6PPFZZw6PVj5/Eo27urrR4qIrg9Nh5+tTLwM?=
 =?us-ascii?Q?cSI1BOF5DXxIJ4mdWyktAcn3DAuOoIX8mzg5orqEOUj7EjQ/LZWdiocvXDG2?=
 =?us-ascii?Q?/RGiseCMEApYYRCLecnZfYoYE9MWuG1C/sZTFQvxF64UTUsKgjecDwzq9Czx?=
 =?us-ascii?Q?BruU7u6WNyWg2Ls1RLErSDhhyQVPvPz1f9PM6h3hL2UjJDFDhiligWUPU7Zx?=
 =?us-ascii?Q?Y9WLREkqO83zd/CPZRhnhuudG8pw7gva4e07xt+xaABMxcPKusnZ9Phn+W6H?=
 =?us-ascii?Q?fOKkFIhXsxPWrzFq40bSY+kBDrwKTKIYdgZsapMUhpXgrt1Q60EguAiS4eh+?=
 =?us-ascii?Q?R+Q1Xax5bvuDFM97DjixMxXEAbVLxn7dCWc0Gta98L0SBD2M4NLZfzCjO5xf?=
 =?us-ascii?Q?3GJfYkM4Xg2FTDRDYi+F2WCEsfNgbcetbynKrBrnLEr0j7lWw29CAJ+puyr3?=
 =?us-ascii?Q?9xfycQiOsDS0IoFtAWr+k2hEry5sBrIoGkbuneFHMJBbdcBRQJzvIQflEDfZ?=
 =?us-ascii?Q?43g2qTfthBDWPy5Ex1XG2Ei3gC+JOrNfzLGAQse+Bj6mmRRhgW4bqholE4L6?=
 =?us-ascii?Q?HVEQ60uP0mJntPlnQsejCJDSeLn898MCcXrFCeV0w6s0hXqTVs4JMnbRH9ck?=
 =?us-ascii?Q?4bRfWe/RXBEMIwHpxBo7TPd13SaFrAtf6uXncEh/JWCPanYTPNNftBNNJUv3?=
 =?us-ascii?Q?0qI69TFZL6zNkhPpfslkFRqLyAgmOrHlKKeGnFtYAZPaUXXldiPRHYdUyRzU?=
 =?us-ascii?Q?0qB00xVOWVOyqhUD4xoivu5ODb7MjUsjVK7s4RJ4XJsMraMt76APG3uGFRhs?=
 =?us-ascii?Q?Es9Yt9tNQGub/tBWOp48Su4kn90oVQazflvYtU4k6DJpgnNUC43vAVay9aO9?=
 =?us-ascii?Q?9kC0cslec+cG47FLvDhnDa0hJ4579gsr8tKY9NYNaFB49kaPdGscWC6YRQnr?=
 =?us-ascii?Q?03HvUd1FFgdHVnAtWYd1kbttjvAc81RGGk9BjFocLhwWCcxAyXNxFY2rKBKk?=
 =?us-ascii?Q?xR5A89UIzRG2uM7uBfU2JKB03BJ+wfG96yDjDMWS9PutDnsC+M42yhfDxjjm?=
 =?us-ascii?Q?BTC4pkvWRc6FKdLHnI1GoQtl/2luUdf2MuMp6AcK1uEGD7bI1OvaqRzUj0oN?=
 =?us-ascii?Q?YkZYKcrkLw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d92886-fc9d-4831-bc7a-08df0f5a9ecb
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 16:43:19.7466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4S22QiO8HHPJ3huIj/AP74Ix0aEQc9Ce5Lwk/iDi7F/p+z7seoZFOtGv+1SDUput3yOLhQITgXPcGdtUcIkcfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB4179

At present, the managed interrupt spreading algorithm distributes vectors
across all available CPUs within a given node or system. On systems
employing CPU isolation (e.g. "isolcpus=managed_irq_strict"), this
behaviour defeats the primary purpose of isolation by routing hardware
interrupts (such as NVMe completion queues) directly to isolated cores.

Update irq_create_affinity_masks() to respect the housekeeping CPU mask.
By passing the HK_TYPE_MANAGED_IRQ_STRICT mask directly to the
topological distribution function (group_mask_cpus_evenly()), we ensure
that managed interrupts are kept strictly off isolated CPUs.

This patch additionally addresses the architectural constraints of
restricted vector distribution:

    1.  Vector limits and multi-set scaling

        Updated irq_calc_affinity_vectors() to bound the maximum number
        of allocated vectors to the weight of the housekeeping mask for
        single-set drivers. For drivers providing a calc_sets()
        callback, vector calculations continue to scale with the
        driver's requested set sizes (maxvec - resv), preventing
        unnecessary queue contention across distinct functional sets
        while irq_create_affinity_masks() guarantees that all allocated
        vectors remain strictly restricted to housekeeping CPUs.

    2.  Multi-set alignment and leak prevention

        When isolation constraints result in fewer available masks than
        requested vectors for a given set, the remaining vector slots
        are padded with the housekeeping mask. This replaces the
        historical irq_default_affinity padding, ensuring excess managed
        queues do not leak interrupts onto isolated CPUs.

    3.  Minimum vector safety net

        To prevent fatal -ENOSPC device probe aborts on heavily isolated
        systems (where the housekeeping CPU count might be lower than a
        device's structural minimum), the final vector calculation is
        safeguarded to never drop below minvec. Queues will safely share
        the available housekeeping CPUs instead of failing the probe.

    4.  Zero overhead

        The housekeeping mask is conditionally assigned via a direct
        pointer, completely avoiding temporary mask allocations (e.g.
        alloc_cpumask_var) and bitwise operations when CPU isolation is
        disabled. This guarantees zero performance or memory overhead
        for standard configurations.

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 kernel/irq/affinity.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index 78f2418a8925..7796882a567a 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/group_cpus.h>
+#include <linux/sched/isolation.h>
 
 static void default_calc_sets(struct irq_affinity *affd, unsigned int affvecs)
 {
@@ -25,8 +26,10 @@ static void default_calc_sets(struct irq_affinity *affd, unsigned int affvecs)
 struct irq_affinity_desc *
 irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 {
-	unsigned int affvecs, curvec, usedvecs, i;
+	unsigned int affvecs, curvec, usedvecs, i, j;
 	struct irq_affinity_desc *masks = NULL;
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ_STRICT);
+	bool hk_enabled = housekeeping_enabled(HK_TYPE_MANAGED_IRQ_STRICT);
 
 	/*
 	 * Determine the number of vectors which need interrupt affinities
@@ -70,19 +73,29 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 	 */
 	for (i = 0, usedvecs = 0; i < affd->nr_sets; i++) {
 		unsigned int nr_masks, this_vecs = affd->set_size[i];
-		struct cpumask *result = group_cpus_evenly(this_vecs, &nr_masks);
+		struct cpumask *result;
+		const struct cpumask *mask;
 
+		if (hk_enabled)
+			mask = hk_mask;
+		else
+			mask = cpu_possible_mask;
+
+		result = group_mask_cpus_evenly(this_vecs, mask,
+						&nr_masks);
 		if (!result) {
 			kfree(masks);
 			return NULL;
 		}
-
-		for (int j = 0; j < nr_masks; j++)
+		for (j = 0; j < nr_masks; j++)
 			cpumask_copy(&masks[curvec + j].mask, &result[j]);
+		for (j = nr_masks; j < this_vecs; j++)
+			cpumask_copy(&masks[curvec + j].mask, mask);
+
 		kfree(result);
 
-		curvec += nr_masks;
-		usedvecs += nr_masks;
+		curvec += this_vecs;
+		usedvecs += this_vecs;
 	}
 
 	/* Fill out vectors at the end that don't need affinity */
@@ -117,8 +130,10 @@ unsigned int irq_calc_affinity_vectors(unsigned int minvec, unsigned int maxvec,
 
 	if (affd->calc_sets)
 		set_vecs = maxvec - resv;
+	else if (housekeeping_enabled(HK_TYPE_MANAGED_IRQ_STRICT))
+		set_vecs = cpumask_weight(housekeeping_cpumask(HK_TYPE_MANAGED_IRQ_STRICT));
 	else
 		set_vecs = cpumask_weight(cpu_possible_mask);
 
-	return resv + min(set_vecs, maxvec - resv);
+	return max(minvec, resv + min(set_vecs, maxvec - resv));
 }
-- 
2.55.0

