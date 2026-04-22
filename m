Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020141.outbound.protection.outlook.com [52.101.195.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AB52EF66B;
	Wed, 22 Apr 2026 18:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883952; cv=fail; b=RDZ9/ggVZ+7VS0tnH/BeA6vpd+cIQoG5PKn8FMxVhPI/RUN9gXAUbi1IbaeqaEuePKf2GvMAFNn64Focy2A+14Ec80emXfdBKswPsd3P7T1OoaFgk+ZS+rE/x8UY1JIJnSvDrxQssuIZIOnYmFdniXq8455HwQm6SvIn8DWkCkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883952; c=relaxed/simple;
	bh=smdQ5hjKxRn1uM/r/eMcjk4aKiNo8ujppxbBXtPZHF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sGhtw1h1UzaEND6bfCVn/O9UDAFiaf6RSxmF7s4NCMgA1BvQ+wOXTz/8jjxT4qhQEBQIp3I67MrQcZO18ReEfPnCKy76ZSkE2qqG4lFXkidul4FBU2wNIQYeVz4uthRaUDt7qC2ShaddWNBsAkUUPj0FK/vfuJZlEwNTQVFcu+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m0Rh/Dv+oTdDMFooIovFIDAIyqxMoA70JL7i+c+XEZF9DU1irLV5g99pkz+dNbxFamhQEQOabYESlLq4tdYM7KM1Z0+2MALmAyGMbhSijH7pUuLtG0GcZD3vbRdloGzLVNrC9FRJf6omh8HFKy/1bqaKOeLTPZXJ/kwIzhmrSwBan+LfK6XCriDdrMMmj8xxoAPlV4I7H+QLNzHoCVDFbpSlFozlGoXr2Dk4PXtJg8uxt2KmqvLgyhUm/xo7g+oobeCFCCvyvhjfOd1WXtS1O05G1QzXvXvqLkk0lGcbAUNCCB9DJaA55TFdfRP4SCDVsR0LB8vgHHKh5D9rl6Jw4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bilJYMMCtuhuq3XIkP6Y8Bj9F0vPRCvDdzhNx4mVl58=;
 b=mW7oVmuCU2BuH9YU2OGCpGMggwJaHzWPEFFRTf2h2DG+CPEsKXF8kN12TVbkqeZZt0MjsS0m6Eegqd4GNc6OpCB6VXtP4vzdyRCZQFQzK/PqwrhAdxk9nNbpHf+PptTyccu5hifBuT8McBHna2xJJQkFNl0F95/UTBWABLV8OOdgH3VpjXL+FmFU/OC+11U6drllhoa2Jd91qEVHjuxRX9uaTmaZYf1YyXaQ/0vQK78OaatjmDXT99KICe3uP9pNCXTw6cyB0bTFNkm6NCQ0prqVGGJoGlsfEaYlCobAw9Qdc0zD9OaZ1+v43LlfV9ktnZ/WeVdOnMMNtPoNktScaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:52:28 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:52:28 +0000
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
Subject: [PATCH v12 02/13] lib/group_cpus: remove dead !SMP code
Date: Wed, 22 Apr 2026 14:52:04 -0400
Message-ID: <20260422185215.100929-3-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0167.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::10) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bb37fd5-1278-417c-3bcf-08dea0a04d18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ANxhwyucpVHpjrOAFIviGyiMsMyNznfAB+Er1uXBs7u7fiX2xH3zbgLuuxhtNI9RRkyJlceWHn6MsJP3xAO6JPRQmoA05bduoetvMABDIuXCEKVBSkreoOIK5t3XUtmCgzZ3B3Tvp2qVRU49EByU1i0SWXUCQUINSDZQacXmnyA/oOCyCI0pRzDjRQ0JRXPE9GOUW+Ch5QahNVFOkS6L6pPZeegQkF395E07A6MHiyMOjgrNd0PvD6W7TJzenTMJT1bpMdXqzPEEpXBRbNUTlHBh6bzOSiy1eavMXFPW9vZaw2CTI3MnZc3nE/IxfuFaszQ91PTKYn55ji2azh73SM+21SbbSq8gRum51zW87ESruMfoo0+aIWDZK1CaihgpUZLWUjCpA8QvN2MJk6w8MPClhL/olQdU7DAHYHGZnXtzsJnzH+w2SK4n1qwwTNR6192V4NPiqIDhBSVKdrNcB/5bSvPPEVhlsbeaSZPRkU6SPwESzKJ8fQuzEvBBJsqbBYKYK+wxM89wpl67d9EF/5ZnvuurQxrvzlQJNtdTTTp6xFs6ZCc16IizG9zKOBhjj9dhplWqnsiZcaccsVV2myg4g5N371MfdVA2UyYKW6v7CHnrCm8Hj6vsN8zICX8+wy11N+uEEw11aQcv75SB1eR8uWaim9/0SZ8IMBpxzzbg5juEzfDuAoDSZbgZk8+sn8InSFguxDNgWJRxLMx1BSdWotzZ4iBQz8gl+1IFuGk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wzmqQX8EVAJsztjsjzfj5OrG49EzD9gnerAU3E4YJ7xlFV2a9Z8ijZxiJawQ?=
 =?us-ascii?Q?W9mSxvd1ZiWVRhz4HqIvmw7cGEN6vkNI97FP7KrB/F49bnallvHT86akUSM0?=
 =?us-ascii?Q?2qTwtOr9jw8PFas/PZRm4iLNBhgkJRM21xVUGGa5XXc5cbbNo2UDrJeSjIAX?=
 =?us-ascii?Q?s3hwk5DY0BZCip1SyhPNWXMQ4Gz4NTU0wbEL+rq6q+UkS5k4Z3T7x+ra/eNM?=
 =?us-ascii?Q?cluv7ug07FlvXAdqhuU+rxrwEg+2xL3nRcdwWQtP3xh+/G3UskJxSb1XjKiv?=
 =?us-ascii?Q?EaFsmHXP1Z/mR6oqSIRsrErzQM3UWWMSCDY/ScJxh5CwihknHh2sukCPxtq/?=
 =?us-ascii?Q?UDzH3/U1FvfGd1XCryQcwneRYy1zxmV9gDcoI9TBK7uUKZUIIUr5+M8vis+J?=
 =?us-ascii?Q?pURXD0cKR6ezkPk3l0YM5uqIaxOdZVHY53p5QDQfYiSgtiW570ChLyxQI1U9?=
 =?us-ascii?Q?p04RpZ0PlV3tzmka2n04R5CgD7R9SbGMOsZsTfMmwLo1fF3x9xWJ2ThBGTOb?=
 =?us-ascii?Q?QjkzZQ2D69Yj/EQZFOTzdVXe4c9gLVizxOg+a71ijBqHkMhvTKaueE2h2jV2?=
 =?us-ascii?Q?PDQXiaMCHP0PspsnvWyCXJGBtLC2frKQSgdFeF86kzNAKkbf0YylSFNPgivj?=
 =?us-ascii?Q?V7qFUKlJ/TAMLNmTBAT7wBry/LpxtxMtrLAto1m60nuQj8xl8/IRwa6sQilz?=
 =?us-ascii?Q?4trJ8USVtdaVZ28WWdVESfJuc7UThmmifZksfADNwqZJ+8hJHqhrXXB8sQMg?=
 =?us-ascii?Q?Cuz5r/n/qKwllE70lgGCxqd4a+FG2abgk2r43fhO7Lge4j0HAHV8WUsp44v5?=
 =?us-ascii?Q?vi0L8prgamLfqRJCSrCbR6dO+Qp9Og0nd2XNVr92QLmaNG7meZnC9SY/5CJr?=
 =?us-ascii?Q?ESMnZywV4xp/SGO/idHuIHUJF8sAovMJT2vc+8AjBaYlhos3nGRMIQcO+lgd?=
 =?us-ascii?Q?xXk4/C1bfUzl47x919jaKwDy86iOclG4DKfVwZPGzjir82tgcJ0GYAijA+bz?=
 =?us-ascii?Q?YLHqdOGr+ySJihRkOVzOvQkyWEtfMza3C0wXaHbH3TqtCfIjXhghDAoJiOky?=
 =?us-ascii?Q?kykFPv4r8IDBnA9Px+GHR/q2eoogyxXdS2tFwBXo2AqspOvrGPFIv7NzhVEa?=
 =?us-ascii?Q?m2brBqTpqtP/QLcXg72usJ/CDerGC1QfJTig/hdrLkKKP4/px2cG68O/UccS?=
 =?us-ascii?Q?5mXuxKbj3KDejFxbzUyw+34uYNVb1W+p2AuBEl5F7ESV8MApcZUKnFNunpoq?=
 =?us-ascii?Q?bKH3zDPsYFHiByGusVHmdftm6v5kch4MskB3ABc6nAJSn8QkLRJIsGWoHdC/?=
 =?us-ascii?Q?IqaYZ7mvimSC1hwLsXLglpPIN7dXaauyob8vtrcrgXSfsVMsSHGV2tgVv0OG?=
 =?us-ascii?Q?d74Ee7ijbalBdu15EwDVrwJHsymqnWhKAbwvXSrwzY/Iw3S9Imq+xGtiddC0?=
 =?us-ascii?Q?Lk4FRxUxHiw2adtarNKM/GPOVnjHACroC+0HbjNkAbGui+grhjhNXzj1asPf?=
 =?us-ascii?Q?ytKpBCWuEFUBVusIc9ObsbEqybUXBKHVNAjEb593/EZcbtLxuWm1okvIfJ0B?=
 =?us-ascii?Q?+MD+sFScz+UUVd79ymGEV/jnk/L5tEldjaRMrIY/4pKVMDH0RHNjLBYd0V/G?=
 =?us-ascii?Q?eoLdxnprN0CKRmWfSAZVWi9LikLI7yTpv9NIYfADAzFcAFkqWZ+dvP5Lbrse?=
 =?us-ascii?Q?NwlUDsdW5mGLP11jGQeo8c1m7Nuokv7Ez4sjzL1AGI74ThrTKyNDmYEp7Kc1?=
 =?us-ascii?Q?iScOol/TUw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb37fd5-1278-417c-3bcf-08dea0a04d18
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:52:28.4814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TGpyQZGVWWPnbuvt4o9iU68dQAI8Sf8tlUpXtWFe5JML94zRbsGFr2E+yhRlnF+qPoFr/b2ii3JqXQ1rwwq6cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

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

