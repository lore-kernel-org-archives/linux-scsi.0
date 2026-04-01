Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020088.outbound.protection.outlook.com [52.101.196.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E80392819;
	Wed,  1 Apr 2026 22:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082235; cv=fail; b=M11b+goqZAgBxIlQKfRoeBtV8AJ375Vs/xuBI6+BMC2etb9UAD9gbHT+Rhh7BLcczIx/pozATXLXrZDGU2zn75J9jk8fXHC01BuzElNCuyFhH7hbl/1hMulQcIN6pAHMi5CiTfted1Acfurqu3vw1Yn3oe/oHTc8mrECfYIet9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082235; c=relaxed/simple;
	bh=mAZzEtiDp2k8X7T7NcLNFzRHJnp1HJ9EU2jjPZq6Ahs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GHx27tEL3DusfH9hpWbxxmDZJH4l34B9gBtd5+Pbp6rIjBPOMo/SXuSnZ0zmz4yjT2EiVU7M2pwCiUPuRaehSexCeQO1b+AVAQWtbv4rHoq8qPEre6lFFNYr2V6a+G4Srce4O+rfrRLP5rgZJ7q3yO6cVr3Yi04UGDPQINLzKOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uAjrgoR7GgVF3MF69OzaC+B2hZDt/TU0MgNOB1eydK3CpBsVgjryj3AFBgm4Z0hMmU/BqP7DmxmFdSdVgVGxhmc69hxY6JYL5hvQAze06wEVQyyBhOxbW4s5t0ff6JDoqo4zqiqVrr5M8Qmptr55Y9YOsTCltFSQHTjmm3fOCAWFKnDXGdhWubwniXX1BGlePVRpgm+bVpqQxatfnr2zgAiLPWQnP8YtXbFRwUcZoU9VXzIaP3vgIBiv+1MupIdgDvONwFD2rgDRfgZhD04eY+CWNCGMLIa8BhNFRSSZ1GgmUGxE1gNT1Cz+YddROQLn2kpomkRh+1OEy1dMaNpMeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKKCp62NMexRNS60zS/mIQGlXVrUGwa3gshRWaDYRhQ=;
 b=vHGt7DUIc13QFW7LOYeBsVtvlyLJRhuNk6Fah3DoWqRAcxwvlVYUPngZtNBLXdLo2eMZFo4fHa8So1S7Xa0Z436wm4zzlXJc+r9l5vmzKf5pVd7wF9o0iFpl7PzTohuqch2hPmbotFZ8riw47zatz+CbjwIAG8iEuNscaDwx2SQ5U1uecBmK2BqWgNma6Udqrri0TwL5DGIZ4HCG0T1GD0k0zuYS9QD0M5XH5scTEseu+i0Lrn1ijw9bv5dkfSfY8ErLxNAkkL2Np2BHuqZpdv0ba3csKCd+tvQ5Xizt1JNebrl2iZ1t81eRAN7lr3R1zPj0FC3fz6Z+SsNT+u/kSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CW1P123MB7844.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 22:23:32 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:23:32 +0000
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
Subject: [PATCH v10 05/13] blk-mq: add blk_mq_{online|possible}_queue_affinity
Date: Wed,  1 Apr 2026 18:23:04 -0400
Message-ID: <20260401222312.772334-6-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260401222312.772334-1-atomlin@atomlin.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0747.namprd03.prod.outlook.com
 (2603:10b6:408:110::32) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CW1P123MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: ae5d703a-0095-480b-f84c-08de903d4efb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Tsen79tqGALlqNoqGo70EG2fMNbL9yQ6WC9K2XO3Jv4hn7b9c8V4I840aFm6r4ng3gP/M0+D6oIA2BkreBDOC+UCCxrs65iAIJoIrf1UYyEhB1ISI5Nao2BGbxAohGIAK0xni6MXe7zx7klOoLR/C3brg4+0dixv7tdE7dgqaEMNZ93+/bxi2VIRu1J50EnMl4EU1JeJCpt5en+Lhv1xWiycm1htw4kub+9wAC989RTts7rCgHIasaPVhQYcNA5myCocav1wrOHeRh61esEyPmGa2RR8kNI3ayF7XjUw7iNUzWCGA8mWV/DOPXiUwYGD4+LpeguTc36q+A+HQxm0wCHmR7NI8d5KM1CE1Di/XPXo3Vrp9IsuUPPTV4Q4GJE1LwP8+0k9fBaz2/Tf4X7TCy3GneBnJtu+C+tu8aIYyQSptYVW1NerkjtmWUZjkY+c+pQPLLVIUo9anbqNAvuP90OPB1M7YcWIFAe+mA7ZVgAFAeWjuJjho3wLXiQmxFdTKtYjbAzKFG8qeJNRDIv0pGsRlUmwiCYc+LIQg8qCXeVxomjg/2up7ZueVpoSMxN0s/V1yCBv09yy81lQi783cX82efffUJuq9hiqi9cS9lD36lisT81HzomLclgkNpoNHfB49fph2dYrDlz4Pp8Z50/TbBID/S+NgW8fjgSmP/dppJn31ssr2W9r3cx9K8GxC3ImxkBA9In9fMp1vFVZ1UfbDGilzGqNaNPnJej2H+o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5xFKhE/U/pnSy4OnIkAOrta1j10uqYzSbxEbmz0xqlvDpVZRr0jhz9CMwoAt?=
 =?us-ascii?Q?W//cZOV/MRODYF2xLW8/vMElVFp7sqqKb51AGnaTHs6N2NOsM2Y7lLEuxboO?=
 =?us-ascii?Q?JHDcB08QTvmT5Z+YZPrgTSz3z/7k+tdF0Urq9IPHX0/F6baVnCUQhLdaxYDL?=
 =?us-ascii?Q?iIwBZyoseUcZHHiVkNvux1Wwl0DMY4iKvNlnzDdcU6zhIqEPtJ/5ewyh/JBc?=
 =?us-ascii?Q?wI+F9yc9J54Co49Rm7SMeoLs5IoD6DOIPWDFFE6n8aDH+qRDbQH9GgtKnr5q?=
 =?us-ascii?Q?dCLkNFqEBc2tuKRn9wuONkU5C6xFKwBPjYCA58ErmMFMPZjuq0MSl4O01Nfw?=
 =?us-ascii?Q?9aDuaMhibwEh9SfNeVnwolCQQhjURRjYbkBpPcHPIv7mVU9+2ALGt2ULpHNx?=
 =?us-ascii?Q?hxHTfYvC9Fd71lr6ljSpPPNPEX3DQH1bm8tVt3ZMccx+BSGJgeUR+PKaO/KL?=
 =?us-ascii?Q?LtGwXUpabWnje1QqqTV7sTW6vxNbeJPYTLiGVzNo70asQqHfPZqAxOuYtppA?=
 =?us-ascii?Q?wFgB1wc4qnwLpZZ2CDMgqALHZIpf/jqxwzGOi1lzKTGA9Qi2KbleAUELAWIR?=
 =?us-ascii?Q?eBSIrqjz2zVPDgJCEwKTiyfRUFlKk54LQ3s/tfHxX+BQiX7fSEAjIYXRJni3?=
 =?us-ascii?Q?F2cuD/ajtZGFyrJAyadajw2HX7pSIMa64ar9AiPw2W/envip1TpA2zNnTEho?=
 =?us-ascii?Q?99Lq74ggzTDk8338rbvGdTPzzbOIAgSTL8Y8kovrPFpV4bOAjs3F5PNNF1VT?=
 =?us-ascii?Q?bQxxxxGov0e71iVkvtsZGZdsNkpD9njKYYkCwirlwsbwOJj+9ctLfi1b0ueH?=
 =?us-ascii?Q?4odZpMCQn5yLbukVoDYS55IiRWmbxADObH/tn05Cqs6eBA56KFj98dFj8bIJ?=
 =?us-ascii?Q?0CDttuim6HSysb2XeDoPkqOFDTyJMtA/M9zXvsS2kPOhklRKnCHfeNz97VFH?=
 =?us-ascii?Q?MJxujtGMBi0TDKjp8zyBydjIcV2rP6vjcjKLKQd/kHEbaeal1n+R4gojDhkv?=
 =?us-ascii?Q?B6EfSQZ8g0YtcgVNNBv1SvCq4sNlzQWj67SMXl+SdjeWPI3ihboTR1clVxDN?=
 =?us-ascii?Q?HcnwqiS5GTRXXqAr+GE0zeg2Q3Q1jBwgsxORkW4/RNF8O824lnpCUxrs/FDx?=
 =?us-ascii?Q?xdjjCIKJhsbUVTSijMEM4uzBUooUad2KWF/QK+kr6sMVFTjOLJmXYTNoAHeY?=
 =?us-ascii?Q?NPWBWaleaTTrwJxswy1pZ2H7xkb/RBRqRc3WCMg4DLIahwXy4S99PhLgpfWj?=
 =?us-ascii?Q?bXVe+zEy++wAE7fXqVwimgMYvKnUtCS0b7o36ruyTvjm+AHJ8oXbJOJf1lYc?=
 =?us-ascii?Q?YZrx78mmw+0cNGlXAoiR3EVYFgtAK1B8tQGBWv6KQHPsR/wLlc7r9JUhy/8V?=
 =?us-ascii?Q?2mV64pglAeBcRB6WxhE4Cg2vAbpvgzMGHO9I9q8UskXY2YEX7rQ30OH/NaVQ?=
 =?us-ascii?Q?cqutiL6ohx1ZNAX42BrT3GOfQdvEJTPBhnozjviZqhYWeGQexMS98lybt0wx?=
 =?us-ascii?Q?fP/KUK4oZm+871YpqA5s/4Cg5IfaBwnF3lGCAh4DAB8KCCqN+qDoR1fIbW8e?=
 =?us-ascii?Q?b79bRCAB+I/fbIIy8XtUKdgIyShxwa6RBYBAtAOHgLm6GD9dX6eIBAUEK1Xv?=
 =?us-ascii?Q?44t4vdSv+n2hnA5BJ3AGWG9HAhIyqx50YeLEXS1qzKRMYxlNaUmpLP238u8K?=
 =?us-ascii?Q?c+PWI6ijuQ7bJ52BSoa6CcWBaODSN/QVSisEumB9d06W3JIbk2Dx/rfafx/e?=
 =?us-ascii?Q?kpIdPP+RqA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae5d703a-0095-480b-f84c-08de903d4efb
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:23:32.7518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kVXKwTy499ywrV5mUdS+Usb7B9Yr9Fo9tF86/z9nIXnHsYfQk5uud6mRT2e6vlB4RSLRrySm6Z/vEtop1bftJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB7844

From: Daniel Wagner <wagi@kernel.org>

Introduce blk_mq_{online|possible}_queue_affinity, which returns the
queue-to-CPU mapping constraints defined by the block layer. This allows
other subsystems (e.g., IRQ affinity setup) to respect block layer
requirements.

It is necessary to provide versions for both the online and possible CPU
masks because some drivers want to spread their I/O queues only across
online CPUs, while others prefer to use all possible CPUs. And the mask
used needs to match with the number of queues requested
(see blk_num_{online|possible}_queues).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 block/blk-mq-cpumap.c  | 24 ++++++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 705da074ad6c..8244ecf87835 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -26,6 +26,30 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
 	return min_not_zero(num, max_queues);
 }
 
+/**
+ * blk_mq_possible_queue_affinity - Return block layer queue affinity
+ *
+ * Returns an affinity mask that represents the queue-to-CPU mapping
+ * requested by the block layer based on possible CPUs.
+ */
+const struct cpumask *blk_mq_possible_queue_affinity(void)
+{
+	return cpu_possible_mask;
+}
+EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
+
+/**
+ * blk_mq_online_queue_affinity - Return block layer queue affinity
+ *
+ * Returns an affinity mask that represents the queue-to-CPU mapping
+ * requested by the block layer based on online CPUs.
+ */
+const struct cpumask *blk_mq_online_queue_affinity(void)
+{
+	return cpu_online_mask;
+}
+EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
+
 /**
  * blk_mq_num_possible_queues - Calc nr of queues for multiqueue devices
  * @max_queues:	The maximum number of queues the hardware/driver
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 18a2388ba581..ebc45557aee8 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -969,6 +969,8 @@ int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 void blk_mq_unfreeze_queue_non_owner(struct request_queue *q);
 void blk_freeze_queue_start_non_owner(struct request_queue *q);
 
+const struct cpumask *blk_mq_possible_queue_affinity(void);
+const struct cpumask *blk_mq_online_queue_affinity(void);
 unsigned int blk_mq_num_possible_queues(unsigned int max_queues);
 unsigned int blk_mq_num_online_queues(unsigned int max_queues);
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap);
-- 
2.51.0

