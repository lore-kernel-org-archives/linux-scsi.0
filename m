Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020138.outbound.protection.outlook.com [52.101.196.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98322EF66B;
	Wed, 22 Apr 2026 18:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883961; cv=fail; b=fJAxgNA/um2RoyG85R2ap46EsykMstXBUZCBf8IOv7XqyHIcMb9hqi1dZo9qBCOh8pTc2PYrNqw2GGfWXKfzLxqMNekW3RD6LnnJGgeXlJZJ/erH0esHTrPjqnV6ZSaphjqnSeaxIkt8Kwyu4gI2I+qxdIBEuDA3RvUVY2HcEFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883961; c=relaxed/simple;
	bh=FaZekD3C42+yjEy9awRzIqilowN5iYKqm/tpc4ZgqNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iSmP555M99MrH8ofEodIb7XAoHaKEIiEBQInlJmWIBb5zYOpyyB7RxK2CEvE3HHTWaCPIqSZ0gwyeFjVIaQFopN7LTus39wFm3+MbYOX9j74YJMW5lhFPSWRtXJiK7UrAoM2RdQMLUjy6gxvD92y8NveZvuttmCUdlaK9oZDORo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=edakbzLjxQ7LknOPX/C2SbGx9FovG7B5rSm3ruY98hKuRoUiusBqcfcdbrLdFfIMddvrPuF+veWyMB1m6mQs1ihdebQU1SiSJmqWVeIRcRJOXGMmvkevzWX4a3lDZHpVfpvZFGKGcHBBBq6jsJKV3bRs873pDKoCdB3J0JG56dbfvo/3seq1limDQMhfUX1YuVwa+xwc6dnzeVmJlnEVKIpo/v4vqMt6AMhKL950J9OqCgijC9LbwBsxG2i4WRqt7hGxfqFacYCYNKdDAo+vxIgNjUoRqTDpIVrXXYn1XSxZNeUWdMpr3ja+O6WXrdd+mOmJCIyZp26QqQ/GWTb6LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73cHbAAS0vyELOw8jPY45qQRpZ5n5iGfFMs0OdWQTJE=;
 b=NNbIsSRopzpAcoaVT5l2CyruaxCDTTa3gu2tgC3bs7cP1QiL5kRkK+VeDTSFdzgQNamiE953qwpSOInf0JVAyGQu/K+WqKJN+FtapemO7rxk0wPjHeODtMPPQdOn+kJ2DGw8bboHWcK0q/0XYuNvt+Ezn/28mEy9AZRi00M+TtTGb11L5rfjIrmkP1ndCKFViNEdWg8nyzbPtxMVVT0EAMoVFBuTRQuEJ8k1W+kC3sgeKr3rLtvj32TMM6phz4cotXX1blmQUO/1YRG/fhyIfZeUq7EBe/CL0Z4D3EjxMghWTrE93rl7Q1I2AwRhlEHiT5WHFeHsK0DKqBBFvbWlyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:52:37 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:52:37 +0000
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
Subject: [PATCH v12 04/13] genirq/affinity: Add cpumask to struct irq_affinity
Date: Wed, 22 Apr 2026 14:52:06 -0400
Message-ID: <20260422185215.100929-5-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0321.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::20) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 30a24b9c-fe67-4cac-c4c3-08dea0a0527f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ocvhPBAl1/ZE3xG1LXAKNuFPbvrU8r8W0cpiRyd7cc+OLndfAkdEXWH9pWfk1LqXpnSL0QKqw/Sc8SwaDNSR4nO8Y/4x32LneMQ5q8ZQR9G5zRCRxf7voBknpBHSgpmOL6XmzUErMLAZSxgsg2ovb68efWaEL2eqtrkzZGZ123DkrIIfDXm86+ddMirNzpGacHmcJVikSZhu5HjGVane3red+mU68v2RtTxrdkZ/0n6edClSvq4fbASfZ406mjrIMVBwwZHKQ8g8RHfr/3hKPom/L10cjBd5u6Jpq5M0PSM3AM87IK8CPg+OBY9YWCJXdWR8IkChSL60CkEDAnU4MBuMtZ0DdjaZ+h94ZHic6MF+R6y3VbH4qd9cqB0lmTZ0wn64MHO5KNN/0Bho0zKRXqCH8Cl4EdAigip57IG2eT7Ne86vb+7Nr/CTHNh5naQcHK05lt/KqCaKm/wy2wGUdWZmDM0i8xMej7/s5bYhu9lXT9l0PY2BUjolqa8Gd/PjYItQumSaDO4BhdbMdP+77TOdKlbvI/8hHpAHi89iixDjYNptIMoacgrogLztQ5qXGuEyhR75lyl3Ppl295HnpocnWpgDTqv90dmjz9KbYpg19bUtSrMKU6AT/Gly2puotckFiJ998dH298w8TJYNzTFXTvZgv8C6yNlEZzTdsd18RAFlcTUxD7gsZOzKYFm6Wn/1PZB/Da0B9HtLslrT5xgDacz7gh4iLBvq1CE4ftM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PTB6Zsu5VaNXWvXIi2MOrhyCWE+ojzlL/rVtAyTjc6yfJORUql9ewuvzx/fa?=
 =?us-ascii?Q?vAhfT89+66f2u2GasW3p1aPX6d1CkPDPvARvs4VPlDkp2pudwgFqovGlTGN9?=
 =?us-ascii?Q?7WhUwZbLWXm7UOZFY/JMCB9xVNbL5ohExM86jJc5GwIEo/+lyVuaGl6frUSC?=
 =?us-ascii?Q?xJpomMtTWauF+oL5ShNWOQCqDTcmI+U6rW4NZf//ek+iP+akTMrTN6ol6w/Y?=
 =?us-ascii?Q?9cjmz08nKwSRAof5es7ZKCCRSyTRAgCjn0G3mPpGHY/RjqiOiGR7UbliafUb?=
 =?us-ascii?Q?UFCafDHyXzQxbduBKsHmCfiMzPCvrHsjKDrMnlJxjwg1m+f2XYNAeLzQ8RKB?=
 =?us-ascii?Q?Rkz48jkubHEseY68nlh6DK7/y2SyN/aY1AIw/6zyDOwC/aUXPqjr1nTjLnOA?=
 =?us-ascii?Q?TznjGchtX6ccEYKmUpuHZzpr4qfjs6YMjCWit3UXPrIXe9Hn+15HiV84V1g4?=
 =?us-ascii?Q?JvwIk1yos/XcaRpS1WhLkBgWegw14h2HuL3jRffP1+O/AUUmctg1a9A+yg3F?=
 =?us-ascii?Q?pKvmDXYPcPWjiqLJRJ/+EplF4AjED+ldUqEHxM7NwDFcRJ1qoN1nir+FalPP?=
 =?us-ascii?Q?rjGy9CtFB5bMhj4TkvyQFcmUyMvyzw+f5h4hyFwxSszvdfyth4XA6bNZZsU7?=
 =?us-ascii?Q?v7rhzRLxe5xYbPSmCHX0qzsYhL5ocYivC2fkg+WsvY8j9Ifq5frzspc7yJed?=
 =?us-ascii?Q?HDL/cNXPkKafsIMVHLDk+Wcnp8tZjktF+bSMDaQKFbFhZbJ7zUZi/IRmwRFi?=
 =?us-ascii?Q?3y9m/xR/fmeN9W1o8G19lnjnzYLCJIq522lLujZQjSlxnsKJntMDy89opikL?=
 =?us-ascii?Q?nnXnaY/Q/RS2P7k9joPwMJzdsCNl2W7kZG8k1riC7jx604W9fY6dyAdM00YV?=
 =?us-ascii?Q?Bqj10SeK79T0+eKUuy8r3pi3IaLifcyeY7ly/2rflbU+x1hodTkDYbFIfBVz?=
 =?us-ascii?Q?Xe8XC3HAzQ8ybfPosdNvbSmCAWNpQX9zaRRR8cMkGaeBFrFpfAUuKC6ao3E0?=
 =?us-ascii?Q?/0c0h+uXraVFlurvd+dXG6nlx+orT+bjfjfH6u+q+1NL4jYGwWfBCEz0RWja?=
 =?us-ascii?Q?DDYVR63jTi/FUdeRLpnXMXDFzigNbDx/1DITP3gx7sK52/st7CbKzgEFYkij?=
 =?us-ascii?Q?TrqzP+BdMoH2H7qJYaNQPfDKJpnCbGTuZK6JGtD3z5yWyk6d+6VILRzFW9re?=
 =?us-ascii?Q?Q7bW/pgW1VNbuT54Y+zNhpx8gjAJduQFDdjFROEFLDWf9ZTqJI2bbYdHigXy?=
 =?us-ascii?Q?o3ed6jsU5MGPInm1aoplUVPsLFQEqSkZt0OX6JX81jyB1vP1O3toR2nqW7HD?=
 =?us-ascii?Q?moTZNdgu9Daj9rmXFlWvGwp06BrYPGdRYOslbMW0KyLUVROa8VXZ7DpoIGN3?=
 =?us-ascii?Q?vBv307x4o+VAcHoVOw8doKkzL89/EDahDuB8jW1B7ukX24fICUmfQlME3mif?=
 =?us-ascii?Q?IMNQiwZtUedCbt5t3PS6i7C9jUv102UyBAiTxBBPZzhOHHlyDVjePftqLpil?=
 =?us-ascii?Q?RyF7JW0J9Loh/1ejp5prk6wuVBXoUfRvENR3zN2DHyt63ZGHaa6Aq0j0kuJT?=
 =?us-ascii?Q?6e6wLbOqCd75W30HsMadJbpEnu3NWhcvZe38I83K56oKDUvwACY4eapbSe3J?=
 =?us-ascii?Q?ofu5zCo6plHVRsIFRi+ig0WlRf7/Dgec2tkf7jn2svjWH9Jjc1O/tanu1Bel?=
 =?us-ascii?Q?4Ss2551Vyonc8ERYU4MZBeTBKPWWkcWPgjbMnsIQ3nxNsUG0XKcuQe5O/p0q?=
 =?us-ascii?Q?sPSNSfdXJw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a24b9c-fe67-4cac-c4c3-08dea0a0527f
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:52:37.4426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: crZXCdJdOkrazSqaKbopvylkgvt+pUSA7azuoEEro812FseoqzPVVKPXHPWAhoSLa4gKwuVaTG+Xo01bOA6/RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

From: Daniel Wagner <wagi@kernel.org>

Pass a cpumask to irq_create_affinity_masks as an additional constraint
to consider when creating the affinity masks. This allows the caller to
exclude specific CPUs, e.g., isolated CPUs (see the 'isolcpus' kernel
command-line parameter).

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
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
index 78f2418a8925..e0cf70a99339 100644
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
 
-	if (affd->calc_sets)
+	if (affd->mask)
+		set_vecs = cpumask_weight(affd->mask);
+	else if (affd->calc_sets)
 		set_vecs = maxvec - resv;
 	else
 		set_vecs = cpumask_weight(cpu_possible_mask);
-- 
2.51.0

