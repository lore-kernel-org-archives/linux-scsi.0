Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022129.outbound.protection.outlook.com [52.101.101.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486CA3B9D81;
	Thu, 16 Apr 2026 19:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367808; cv=fail; b=gSpuHe9ydc+LHkfI8kazo/SJu6pktAT0jCP8iUi1HwwdOLCmC2PvTwqUFLrigm3kvPLvv8HnKZ9DagDsQ+lTny0TWneThvTBuSnrWKshlI2X7oYPkzUv+UjDS4VzOKkiMPzWGa/2ktcD8AXL/7LH73YG3IhghJZ/O6X2i5IwH8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367808; c=relaxed/simple;
	bh=FaZekD3C42+yjEy9awRzIqilowN5iYKqm/tpc4ZgqNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T/12ZgvMXIiu4Mnbk97vCdhGf8RjLepU5NedBs6saKzeYwF3WQSfco9uKIeTX5vBc/6UGdDuy9D3bWMM4jS4rIc0UYNeLJztsSpZVhZzmhbghbhz37VTjv5knCPsat/8ENfikJDOyjwvx+GrXabTBBf0TmfuukOZEic0N2SpasU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=drW5s5aO8z6HF4nxhcEIWhhxdFBml3O37YVlUwB4XKxf7ZmIsRYkkBQvoVGxyFvDsJgbt/g1piz37LTH5W/4yzsxkmxxoLFhADye8VJfCdzxUbKesSlejnGcw/BjQWid+NUqhrmpRQHuGlLmsQ02uTdb5r0C4Jjy7XNo+okB87WzsmnQKPM5Z1vlxaa2pFWx7hDzHwQ7FimUFhQGaYrvg8HMqYp7OONlMn488PrL9TpawpRrXzMjTHVe4ixD9ynuSG72m9PAPgJM2BgxyL8IRdFm1mV66NGMogi/fa1IwtVV7oFeyP5J/OpKiVlpdTpKwb24PJv11DBOH7HHgwV/aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73cHbAAS0vyELOw8jPY45qQRpZ5n5iGfFMs0OdWQTJE=;
 b=jsZ9VqpeYNOvTzK95IlExxUUD62y51qsswAbOLp1CJsYHfU79YRhhaKwRC1FrDV7d1OnvMBUjt3K97WqPW+k9Pm1f+js6SEDhrbKZ/qS9gJhB7lywvZPFqGxsoPaWrmV+c2VyQ2ZSINYxVQLY1sEdsDbmZv5vzLaJoQWK7jgv5P+8qeDpvfMvSt4M0+SKCEG9/ag1JwYU3e5q/Au6t8Hf9yr2ysqoTgX+sm7zKsIyT4wqpRLJ05mgFToxAXt5NAKztEC+hx74ZR2ZfIfuC2YFuhy3Wkrm575vIjglsl1JbWNLtJJ5nBvdv1JmNOfwtPxti0m4/vKBsRgXc7Cg1kmaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB4039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:30:02 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:30:02 +0000
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
Subject: [PATCH v11 04/13] genirq/affinity: Add cpumask to struct irq_affinity
Date: Thu, 16 Apr 2026 15:29:33 -0400
Message-ID: <20260416192942.1243421-5-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260416192942.1243421-1-atomlin@atomlin.com>
References: <20260416192942.1243421-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:208:335::23) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d65ed75-9635-45a2-835d-08de9bee8e42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7u8QX/0dF792ApbSsepFVYeBnPxmtQCuAlkYx02k5JR0U3f26hnLS0Od91+jD9ckIbLfgTUQgmMcL9kiHrZtB1cDIFLR2hWxeMLdJu1oNVdAmJRlrrYF99jae3/lzdGqT70A610X+Qaclu3lDi7sFhy5/3p2PhMQeVMmrqmMo1PGQF5UeSP8eG7NH23wiaVN6OekL47xYu/SXe/Hjb/VgpbM6kgr9826rBHHZhsqBrXq9AB58x34PkDhZx9Qw2MqA7eDs154i/j63rDZWSfLiRVrUAmV8AAURUW8cToP3s0uB18o+p0dYwxsgtOW/q7b/mIATNkPFkY91rfEJ8VOVFJGNrlZ5Z1ClfeUlh2g+gsCKLz0eVVb5WEnj5gR0aCH3ajqVEuiOM6wpsmrKAeRuZCKk3G7bpPinWiiXm/k/KWNt1rGfiDsKHJkM4zGF3OE0TIgFhbr4Xaz15EDjfIn6VkcIvCgK7kXwr6O1F8+wLiNojgJrreyPf9wSi6Im6fthLBkVnFwEV0qDKpHh0ekzaBuJ/t1+FdqXIfGg6ncBThJLXiMCZ71r8IphtMFEdGYUeW/7sfsMrc7KH6mR4fUtWMr1DzhGHwxVxmXg/JbFu/+7odVT8YqsTDvf/LtAOXAf4rQBDO7ExgA6bXYIO7kO/a++8/9CpurpM++z5XAUS7qahT3wL1zDheUY0GlRDh0h9nthVxK4ASOQcqes+G2OKpLSo8JQh/STIyo7tGQWoY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z4lRjJI1hyR69msQZ/hJgXono+MKcqAGMNdiNI1SdCOI6dWdU+iIaoYXJhPc?=
 =?us-ascii?Q?rSBNfXFRmDTNJiJahLL9i/3eQOyEKSYnCpyyRQDJdpB/DJkdWynEaUAB8EiW?=
 =?us-ascii?Q?cwQPjQxREHgzBZdCxUrXizhDYG396OW8PZaKxTn7kXo5z3Dmcutr4L3+C+JE?=
 =?us-ascii?Q?sfqF1iooDy2y+X7H7vHqQHSi1z0HQ5k13E46A/EUket9II2xeZoBAHL7EI8/?=
 =?us-ascii?Q?P2f6SKef7YBFWH9Q/X+JulxeCFCc9KgDj8cTiFn7Ik5bL8ohbsk+WVWbKUO9?=
 =?us-ascii?Q?UaoP1jV6bJ+cWt7HEYKgBHKx9Av8LeSn4BHIgR6xFwiMlWlkI9B9dUZLICuF?=
 =?us-ascii?Q?ZX9C0pUKqp2rexvBzuXQYDcd6nEbmApFFty6EAG6lNPwsGhXK/7ttwhnpu0s?=
 =?us-ascii?Q?+R9jjjRfrxI8jUQKZwyr5OLHs3oRpsg6k5cPAXjw14NI9vEmgyJiEPiLYaRa?=
 =?us-ascii?Q?3k4Wy/L9MRLThH4dcqukCgrOx1MhGMpP+nAOIB8+2K3zjH5351Pw55vxFsLN?=
 =?us-ascii?Q?tveMoT1vmob57qZKYrpjxiLfjjGg8i4cgwpEg7SshkzEzURqGdZA7vIKHEHu?=
 =?us-ascii?Q?LuSTNohYckJO1PNi54TRuBFtKsMrEtUn4kXo3R2dPgkvu3y5r3uBhQduwzJS?=
 =?us-ascii?Q?m6XUrBdGGs+LpOSUPlnX8FcnngNK/0UE8dclt01R/Ob5d+0gYyIzphXvVSet?=
 =?us-ascii?Q?JYS6REUHUs3q1UwfB/ulFXBs8LEVRDVYgsIgTEvyuvhWaUTi+1xG1lQ+tU42?=
 =?us-ascii?Q?wVnqo2cCoD7ifp1lR6tDzzH2jo33rPPZWPo9KDb6NQUGfY+w4tCBVQow/EAt?=
 =?us-ascii?Q?JKHFDYkuKjkX/zpw8ZweA7idTLU5LIuqSn5Kd+0R9MeQxD3805nlTV7DGHEg?=
 =?us-ascii?Q?ZVIBoQ6plMa0ja+gAnZkYn2Yn0WZY6ZwxFkZWcQhcbGeTTYXsfsCmpEA6l30?=
 =?us-ascii?Q?m+DSHf018jf0pG3qGu2xBzjITWXE+qWc4JYMSZRSlcQNjHm/YAE4p5GtF28O?=
 =?us-ascii?Q?uAnyELYIP2drXW21IfU40iX3vmNyKiS02HAcflmm5cdANGLexuK3mgizoYL3?=
 =?us-ascii?Q?czDi8eGgNkqkjGFUIWJToVCHzYKuq9WWHLsANXmKRJSJMNAZqtwfjNU4mMrd?=
 =?us-ascii?Q?200gbCPLuvls+0LlMn8jIcSzhoRHpylp5eRcwlZiHrbgfhSlEbofyOS6t4gP?=
 =?us-ascii?Q?IjJOkm+qXzTjlZYxBGWmYagZ6+C65WaMOPavZZojlGsxeW6ROp61Jp9SE9eH?=
 =?us-ascii?Q?9V0bXA26J2O/lw3sy3YNFlJqyU89GlulnMCUwPf0GG/6jQaTHkpW2P4rHhx0?=
 =?us-ascii?Q?5mHaZ8aFMxkuN0GgFZnxntzRfIQ/qAZtdrIrbk/osAImh5l7x2uBGIqUTgcL?=
 =?us-ascii?Q?J//B2/CKThDxAhny877yNDcDwvTu8ltfmFdLUKzpV7+iZCRRfzx3I2mRMCWI?=
 =?us-ascii?Q?xOZeaLhQst0aK/jhEiSLwVdwW+mEn1RSc9pObTIR1nvrDrbNuhaBCmX1EDIn?=
 =?us-ascii?Q?w7vObAa8DltvZa78OK3CR06dFIX+cD2pHB1d/b5LHoY/mqY73r+LHB+rssWO?=
 =?us-ascii?Q?oTBekNeLMLNesXFrEzRp0VL1NATpkAn+hZDMB36VcU2Hx2xvJhvu+TIp+/1F?=
 =?us-ascii?Q?AMrQuGlFfqUdOWsqq1GwfLVF6xc5ss11mX9VjXYX0qwD0zLR8JW3plo5s3Ik?=
 =?us-ascii?Q?uSEQHXtnGSdFg8qBONNKu5xb6y/Rd5aFuAsefveJJEo+I5cHV0UYrVTy1lcv?=
 =?us-ascii?Q?qns2/kkoDA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d65ed75-9635-45a2-835d-08de9bee8e42
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:30:02.6639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: evIUVDXTOqTgBksGLxp8YAIGJou3Cd0nMqyXz9JXoTv+Fubb3iPYkE8re7kAlabpB+ASW18OmMAxnnhYpy1V3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB4039

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

