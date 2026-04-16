Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022129.outbound.protection.outlook.com [52.101.101.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61BE3A63E7;
	Thu, 16 Apr 2026 19:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367800; cv=fail; b=OPkntJyzg2wJ/j36StXvOwdBz+FQVfVIE/+zvotEd+tn5cyVBKbED2C8Ph4WRmR6wNvKQgn+lBPj7pw4d5p21ynygbMQFKvYrdskE0DMgQy4fk4Dpjvk8Vdw2P62HBqVN65YhBRGNaKDaR5EpaHyf0qUv56tgPKYAKjcWLpo6bM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367800; c=relaxed/simple;
	bh=smdQ5hjKxRn1uM/r/eMcjk4aKiNo8ujppxbBXtPZHF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pk+K4qPdUZlJmAXiltyqNAZuNVrYW9easyyXO3EPYgD6qlrM8H3NK+6yI/Y/ly2jP7aIE6I8xxOX1IJf5As3aJr1cWFUtbmfvDqpX+P8wFtPwfL/yWY+Wy9HWp8ef5SHP1oG8OT5udlQt64sQADfmhroPJ4/RdvKq6k+U2rOTmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nevI+AxJnYOBXLuJYoYOj8ndGOIcLQaN25J24OM5QeDauXFxqqH0tIZG14Fi47QQjPUTlBfktc2gSjMHyTGeoQdx/mjTEo4NxUushGiJVGEq+LKFe4dGlJz+Vt5JuJzP+ELNL8q3/BVYkB1oxxCvC58hEHmjW7HuqVFsNA7sNwCuGHMXkW8ePAMKNmWuoBNrm/I4zUj8MV64PFP+LZX/voHAJEvaI+AKmUpRL4VcT0jX6IUGbR+2nla99rhQ3h6aK2y5yzD5citc03XHvvV6Fa3QgX1BP8N2oBULe1FIoUA1b8vfd40mZYKKnFvMmU3swaIOrPzb+9/oA1Ly6Q4CTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bilJYMMCtuhuq3XIkP6Y8Bj9F0vPRCvDdzhNx4mVl58=;
 b=y9Qyb5VAVnglVGJ6beM1/kikGC2BDhhpR7VDJPO64+jNHtzPDIl1pSouyyRDJd+KXV6cYfQVSzRCctkEGDUE6chawfeDWd7G7fdWkkFU88P2T+THzoUjCSrQ1jistgyAuWP8De+EC9mewbM5MoMXfqqUEgINY2TXuGWTBXj3UUlMhfiWf5JxWRohsyfXKvRaPmi+3Yw47RxZ3BSx0Dtu/AYJ4YmmaVEjLk25l9fHKvls3EfNumHNBHxXsEZhzR2E5/RY5ciRO+0apTH0puB0mybK9fRbsqghBrY4WSDVR70R722DIzN0s391YRCHfUpzanGfUAyy7Qr3gaH4sZqerw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB4039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:29:54 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:29:54 +0000
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
Subject: [PATCH v11 02/13] lib/group_cpus: remove dead !SMP code
Date: Thu, 16 Apr 2026 15:29:31 -0400
Message-ID: <20260416192942.1243421-3-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260416192942.1243421-1-atomlin@atomlin.com>
References: <20260416192942.1243421-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:208:530::33) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: a76d283e-306d-4f57-080b-08de9bee8962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	43pyS+XwBKEVpG7dYjnSuFDtoPoWIQnYONQSsCfAoFyeH/XtYIg8LHVzoho/TbIENgka0waYNUi3fYclhdjXA69gl8sH+7nHWmcip9W3F0gVwwbXUXu54VfDvmXf2SE3mRRmQ9qX5Xk5+YFpctsaAtO5qIJ0U9MuEpLeLQ9Nn8wL6upqtCTaV1QzFsVThqwyuuDMqYK25C8rxB8YPnD6f1H7IJ1EQNkmTgIzuVlo3r/eOZ/ioBdSJnH5OgJodVNnj+o/PboDgNSR5w2nfPRbL5sJK21BI+l3BOutI03KmqpfMb1lRGlGfZUOix/Mkl3MY8nat7O86bj6tM/jy1hjvqjV1q1AjFwvOyGj7xfAlxLesrO2Qo7ONB4NNULE8T0Na7GUlvyjYIqF4vNJGtuEieidctcEfKPSOSX0iZWoOE017HG9zHybxxsc6FSwWIhL73B0DJH+2RuiEPzF5bztmTuohvA/DDWUOBxxc+1ra9YrP6imBzz0ReNCmUswitdYRtFn+uZiQtnIWA1p9m38Ee9Ora2CUPvXLZkEp+biZyXywwNUKaW/dJzHT02wQoOACNySCq1dAX5eHflGN6CdYkGmez5rPYHx68buabuoZUv89oP/60m7TPpuets7ocsb3cvgl4m/bHbseyc1G3xFCCn0luuXDUsdezDjOU4qR6u4mFgPmBBFn8nigkDyJKUeDN58LK1eh2FW+hMD8AwD6pe6zukGo/HP4XB9EkbWKkQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LThExueOjV4HwSTDj9BBlyKgUZjQVXY9frT8DpY8bp8C/ST8noHQBraL59WE?=
 =?us-ascii?Q?4NT/9f7pKx4eiZqYqlor64sTL3MMSUCOXhRkWVSbq2KoC0nzhSHyMQmKYBxl?=
 =?us-ascii?Q?W8yQHomBPbEloTaPwvzCMpjgB3ICM4+KSUlNT/ZGI8mUy5yCGdhWr7g+J4Ag?=
 =?us-ascii?Q?ly/CyWcmWkeC60Sg4BqikIVc2Ndro2d90Y+IX/PPjxGXYOkjeUS/IOrm63Lq?=
 =?us-ascii?Q?dymqVPChbMLaFiSyt9m9W5KhdT8Rw1pDVFudkUZlHZN6PD4AVpeXWXhnLKII?=
 =?us-ascii?Q?ebvH3redAHT6q4jUXsbYcVMjGRJyb2d3rb17qlfeofvHtFbN6Y4S2LQ6Rwor?=
 =?us-ascii?Q?Z4w7Lf6O6reXxX2w21jfFhejyw3P7CV3wXlF5GRBQ97cQm+XOyVh3xWDcckZ?=
 =?us-ascii?Q?nhnci2OkIeEY5fCDS0Tr98YRoDbdm6xZbCZ3FCnuRUXNHcEfFt/Fel+cMw9+?=
 =?us-ascii?Q?HkkGSA24r4+sUX7MUxLk7DUsnx3+Hn3zrIpX+kwrugsmix+pJJDqrbLbp86P?=
 =?us-ascii?Q?5DZQTgRcip2nLF/LfIAxd0xxhKT2ECCNjJOzWNl8uOsz/LkkoOWBG79kcMqh?=
 =?us-ascii?Q?t2qPlcQQ3YgxTvnenz/jI2yXrGpxsQKjUyNiXjUM5xT/pa455Q5Qa3PHq/R5?=
 =?us-ascii?Q?peJpLEJ3VP/rN9SRvfp4/0bkNaOrJ/i93n/GiALzBMVeWkVG87dH8ik0OP/7?=
 =?us-ascii?Q?eTLE/vT8528hcfkM+mqYieHQO+goQrsRZXwpnBq28bIBPu4u30dHVbV4XD5L?=
 =?us-ascii?Q?2kOLC+RSLUiJdMiApmWXf05B8KBO3ULybkD9u65f7UQfNyEjzM29CXBMqduQ?=
 =?us-ascii?Q?mUz648IHUmwNN6nQbXMt5g7qaU6baFctpxbWTvSs25dZ8YsQWzOdTaZMllbK?=
 =?us-ascii?Q?BHeitJB1rHy5zMVAagjtmZjzx77KfRbQgubNcZDfGGf7Aiekf6r6HwZms2o9?=
 =?us-ascii?Q?h9HAnjfLhZ684ZTVeqj/vH/eFC5fMz8Kt1EovcIdEjCX65sjOGrhkMQ5XBFC?=
 =?us-ascii?Q?e0DJzGUXY2HMV1d6PQM1aWuY3OTrrqvcDfOoAtai0m0YX3VUAINEJON6JC4h?=
 =?us-ascii?Q?Qkx5GKJA1DlkAyz8dMbWta4uetw+iAetpj2ZJrcF4+zr7oxSBRmCZ2uv4CY5?=
 =?us-ascii?Q?XCNY6MKlMXOOpOSYX+62NrjNqRS2LBzvwPooQWOa8DZfy7u/F0pBQh+Nk+7x?=
 =?us-ascii?Q?2EFbrJkYUexfkEDRdH0o+Yz1u4pGk1FC2bgrkavsc5Rc0qG53gnQisdjuHZn?=
 =?us-ascii?Q?HDRq1h6WokyaEI4xvz2wf+C5VVRiPfgaPNEC6Qfi+RyitkNRBJpSdrV9PYvk?=
 =?us-ascii?Q?0JttfI89UNdlfk9lQ5oUFsaMbWtCisInjlUBd4U1ZhetbtauFS5fyE7Z03Zi?=
 =?us-ascii?Q?po1ZmInGvN3Ad/e3fq727Gbpjses1eG3eHX8npSDPOlkS6PNqr8ylL0JwIxe?=
 =?us-ascii?Q?Jh051za0ajmlRMHua+wnr2DPvh6zi39xj6qLVJ0tVA59EAr4sor68P56PgbT?=
 =?us-ascii?Q?CDigDgeC0fZEmfixE3DTtOF1/7X8Tm8I71DBbOK1wWj9ow/ym2iB9XO6Yj64?=
 =?us-ascii?Q?W3WjCjVe1R+jf4lHgs/6CukSDHlCabhkuw2pdFxyJzvMSdfTecrdMQZm/AA9?=
 =?us-ascii?Q?SQV0GSUKVuvcqLa6rS+WbGAegS7bm5eTMSU9pclQKAmH6ASXq5qbiD73CBBy?=
 =?us-ascii?Q?yB2NfAgd9/3kBcql5TaMxTYdjfsPQVFaELxDMW3GYHr8FnfF6ucsQe9cITvF?=
 =?us-ascii?Q?ULXLJe7jrw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a76d283e-306d-4f57-080b-08de9bee8962
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:29:54.4303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UcSyuZzJJ5OdMFSmHijcMKlrzpauOGNFOJ5vbR0n+QUW0VbJ5X+vXgblV5kxUFRafuqdKc5lE1TVuHrYH55U7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB4039

From: Daniel Wagner <wagi@kernel.org>

The support for the !SMP configuration has been removed from the core by
commit cac5cefbade9 ("sched/smp: Make SMP unconditional").

While one can technically still compile a uniprocessor kernel, the core
scheduler now mandates SMP unconditionally, rendering this particular
!SMP fallback handling redundant. Therefore, remove the #ifdef CONFIG_SMP
guards and the fallback logic.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

