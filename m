Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020088.outbound.protection.outlook.com [52.101.196.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2253AB292;
	Wed,  1 Apr 2026 22:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082218; cv=fail; b=aRz92vxI5ExgQ2uDi+8E3zGlA9vxqUmnf0NUfun0Tfw1PYJbPTvtClv2w26Q8k9s4+g7DNqsi6hWQGXfTuOnSahwknqe3qE8EzH0zBdW9P/k4RT9c4TwReXMC/Bu7Mbk5aQeBhPiST9ThBHM/tV3jkUPuzaKkLujMTGtsMHbzOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082218; c=relaxed/simple;
	bh=9Alo6Ggnto5o9F8r3ICH/zWbOFimhkk4sqZdMk/Ogyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZHRBYQ7b9KfjeY44xDngvAeUrrlyhcZJsO+rSxpe1Na5jS6HdtFILrWmS8kPwA53+hI03CfioLAOnJHjlvU/oaXIdfRti1rZSdFdTpdSY5a2nGutcJYmg3p1Z4K0fy0ILMongGQL24LGDwyXgCJz5JT2DbRJb4lyjJVT+J0zprg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PsYJMB0Otvd8wR0thWfay9ox+ODrllhpkVVz0XFB52TN4QXlqreHDHPRKp5roUWifPAIWTruqDtZu36rZEKgPmGtbvN0yoyTxJtGJobTDt1uqMMa39t1arrhQ/45slzi0HZxSWdN3zOFBIWw2Zialp3ouOn9i1b3t1WP19asbOxgailxun/5UqXSHyNZjxppSR0mA11udeChv0wYbI/XrBQ2uOrJAhorCfxBz1m/5oEMzyTXNlGHDeva8USacY9I79Z75NIFbfIHcKbcuSypkIRkxF1TTTmMORv0p6aTtCok0DmuwirIBKcWDVuyryPrfkTA2IjmkykF0ROPpNWjQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jO5AsnViV+37FJO8UbrG1TuS0O9yU2W5f/jG+EPbnZU=;
 b=BNRscpAJQpzeNCGuueCTWmHUW27WRPlYlJtDbgMOUBFUacfJXn98oDBfGuK5UEF2pOb6pECkOJhKyq9SlPZcc7z0pa556LSeN6OhXDHP3N3PAn/uioeFd3Qe3azIIWDaJFZHj/gtRvMYeqxYYLGHnbWJIpq6Xk1i7B97Q9B8GW8mdt/3/juIH58CfEq/oMs2RqZKvF952DehevuTEnbab1Q1eOb83ZmHsMZl0DgBOc1Qm+CJkXnwpHjinBdbHzcA+f3ZC5C48SJ4JAjR/7XP1Q8e4VRTuOtZmMmUFnCstzgwAmoqWM3InuzllrtcDMoMpVsT+xOSDAwEJyNrAWbJbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CW1P123MB7844.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 22:23:29 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:23:29 +0000
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
Subject: [PATCH v10 04/13] genirq/affinity: Add cpumask to struct irq_affinity
Date: Wed,  1 Apr 2026 18:23:03 -0400
Message-ID: <20260401222312.772334-5-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260401222312.772334-1-atomlin@atomlin.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0556.namprd03.prod.outlook.com
 (2603:10b6:408:138::21) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CW1P123MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: f6ad1204-d9b1-4e91-d1c9-08de903d4d18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	X+JplQSnmLuWcW4srFrTXleo4XUaAlOkXt4Tx8J7prpFDu7jILdN/kzgvVm6LYCFOoda0m3+vZgCh3k0cui8zdgM2lFDKEys9BQn2XasSMVyU5f5XltlAMvYKy8wc8t4klXYnzalGzrjPCATsRPqeoGdzIg5QC9RrwUUx8hjqXsCCnHM7r2skOu4vdtTH4nuQfsRHWVmTHVA6pzNK5CDu1sP5QvDqplvziUGxXIzZVi3h9vTHxzPOoV1ZLh5nDL1+iji13520HGVATzc9nfJZ1SK1br8C6W5nVpwNAyJirccdeTyZ98XXSLIbuJDHJ+mV82OMHlUafXNGS1+PdS3x+zkpX3PscSgSd2j2AI1sXNeOtXkH0LbNkvXR4JtNM9bTUppac114Sgv7S1dga6psUexJVfRzde4/X7P71FHK4PbDRMqJw8qXDB4stV4dKilct7ITzQH9HiLTNYSfbIZf28N0jsj5ndddRySFeWvAMyP9dsNQJhFD0SaDsmdFPmXJxYZS+hQsV0tb8jBpHe+VTSeIF91H7TBb4rGiXL4tT6TWlp9AXKD5WDTdnqfr/9qEk0ISCvOdtW/9XVUJY9y8y5ibWG9clPlROeAg6MJjRJ+uB10pDq7qMNudhk68CAfGhKmDEWjxNr6VjuP69sDx5aGeuSlrR0lSDnfnCy6+jqtmu6d0ASXqM+Pr12dlEgZC7UXRmeLvv11m8MbxcBgqmJJerA1EvyP1TMjV8D+OaI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c2/gHFXS/tqWZGIXpIMUCXjaYNNKbXbZDP5Bzi5CWvQkamLEXBqc3oaUe6tP?=
 =?us-ascii?Q?yvkAq8zyobCtNOG09clYzLi0svHSFmGhceIegd8u2vjNzekFpHQRVXu7sNte?=
 =?us-ascii?Q?E4CtrcScOWRe//ExF25FhdWZZN6cfAIel0N+u6mf5b2JfH0jbc4z9+Fr7tfc?=
 =?us-ascii?Q?gDEQ77YHUmoUa2TktrZjlF93WW92eBQB87D4rawuBRyyi0RSaCG3jqIZaI9o?=
 =?us-ascii?Q?Q5TjCzT6UT1U+KA1BQAbJ92poVhfHcQP/0qvaYNzGP5TSSwJgaJ1mBpepuYs?=
 =?us-ascii?Q?54NNRcdLtbK4gCFuNHX9BD7CrhH7OdhhXLd1i9q2gsO1BIeTXV5miVQjeM83?=
 =?us-ascii?Q?k1Q5ZlT45PfF8bB7D3sQSuIyNfKgar260XmNQ6RDPKPXpB50ORSkNleutOFf?=
 =?us-ascii?Q?lSj0d7ZkDvg5O9cdwCAQiS/2D7B06ebCk9GA+DUhcdaK3TE8aUo8eU953r2j?=
 =?us-ascii?Q?iD35hrxMRbC7K4rUSnBvuj+64bvejmHnQFxGQihikCqRzXRwmAZ91iERaxOv?=
 =?us-ascii?Q?ZGK1Js2H75BzR/twE1PmDLWVMliu36lvReK+6zK4uuj2RGvZZaI2Sjsmaa77?=
 =?us-ascii?Q?gtgiZpZqVQI0eYd/I6t9wXlBlysUoKm3KQmGJsNsbvv2Yf8eG1vPFXtTTBHN?=
 =?us-ascii?Q?xohwOmx9LOCQn+uIrea5icmTKxn2D3RlX4bBJdZJSt9OleTxE8TIIGXVv2bg?=
 =?us-ascii?Q?MnOyZOADLXei8bg6pd/+7rcEIh/sDh788YLaCzYUP7kQx2J+VmvyVUlHBq59?=
 =?us-ascii?Q?ZchtltFc9+n8QoeNcCjW1iiPEEDfSJoRrSuOuZrDSP14qmiTYmrkLHpqbQFk?=
 =?us-ascii?Q?hUclSrlWv3IrP4Lc+laAdxTB74laVT1jfUNym/dbeJfRqbmjUOF7qjfxCdjM?=
 =?us-ascii?Q?ngvx67PEW5FRWRrPDiyg7NF9aM1zHO1sMhjhXN5XyKN/Cid0SZ+LvlKzeSEI?=
 =?us-ascii?Q?YdcspFyoRuMAZkRDbJvnJ2UyOmPsIruqAqKTZ7rb2xKvWKwWyoHUu1h6YdSq?=
 =?us-ascii?Q?RghVZVYdvTMRbQ7Udw6RBU0VGjuB5BJNmQFgEW3vnEL2noa57WSFnEzDaqLE?=
 =?us-ascii?Q?pcqnb90usycOP2Tzh6LGJN3VIwoKLGOKiVUe+jNJ+EOxuAdjRVmyyF4Ue2x5?=
 =?us-ascii?Q?lpKsOYbtfGCyJUegr2TpJruht0zSIDyTgRdBVnZd4SA++pmi1Zq16fAwCjLn?=
 =?us-ascii?Q?E5ih+Rf9Qlm93CtfUZ66/mEzgpwObnJI7/4u6a9F+E7u2Xlig6HpcmZurAIF?=
 =?us-ascii?Q?JyNqu6xT4dD81rnzXK7wF1kNdExffAmEJ6Rpr8JXFywljkbNp1jwJyLdO8jL?=
 =?us-ascii?Q?FXrOOZUn0O82rLwSJUAPxFPc2uQxSAhXh4bmolca9ZZPgD40dhzYGrTtIxdt?=
 =?us-ascii?Q?GYDFgmIZS/SKLr/PqyoQNFGerXALAkNEO3JNABF0N6/rK5bqjbaQGdp9SOCW?=
 =?us-ascii?Q?IMu4RfAcLREMsOfIWnPsa6QLCWmsXJZL67X5gwad80uQEhgkddGRiJAxU0fD?=
 =?us-ascii?Q?KmSQlUmOOmv10z/sQMGc1n12sOEA3iW24gvVKSogTXSDehSeP73Iumcy0ZLd?=
 =?us-ascii?Q?fkRnupSTTcFq90RzgGgvelZ0rxyY3sLPbx0YMLTGMHgwXV1ZIQ2IqnbzaYrz?=
 =?us-ascii?Q?yH1bLy8/hMSZt4d3CB4qJI+jENzJcnviT7ufCoDyN92OFeYVF0m9g6UCkYyN?=
 =?us-ascii?Q?wULjDU3zQ9QNQEmzbUXsWYlKfSBu27uqxFEERSt9votKuZAMGuGa4+hNeh5s?=
 =?us-ascii?Q?PnfmnMU6Yw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ad1204-d9b1-4e91-d1c9-08de903d4d18
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:23:29.5690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZU26sQxwN5uWxIRRu5VwLR+KkTtwpgMumdK3cp2uayY9LW2/9fVRPWcB2KLMGT+JMcylRVu6sV5U/58+loXDYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB7844

From: Daniel Wagner <wagi@kernel.org>

Pass a cpumask to irq_create_affinity_masks as an additional constraint
to consider when creating the affinity masks. This allows the caller to
exclude specific CPUs, e.g., isolated CPUs (see the 'isolcpus' kernel
command-line parameter).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
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

