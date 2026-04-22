Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021126.outbound.protection.outlook.com [52.101.95.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7434C2E8DEF;
	Wed, 22 Apr 2026 18:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.126
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883968; cv=fail; b=tYIbmn28nM0rDTZdWX33HlAS4eVx8AAOpqFt9apSHQto8H54stwNwuUFf0rfy4vXpp3ZIJS/b6TU8BDSjC+UOk4QurzkE6yk4rh//Qw+lnYQshrDaa8P0dUdI+bC+kwv8T8XQAwvHdp56LoDbzZ47QYkN4wJoqLs4DfFRLCB7ws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883968; c=relaxed/simple;
	bh=2POLte3qby/sLmbIsBi3hjd2wRiNqfCvljEooOUDn+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b5nyLA5w12/nQ5L8yjAOKOpOks7miFqf6Np8LPhQtOFm5ASEmetf6KK5M3+P/7XN9j69zjmD1P6EY9wLPzA8jLI+1Gb+7Vxwt5lkluwZuWnwTBCRzkYa1sYwgLVm6nef5H6eH5dkudM7tcAIM6IQLUQ79eO+I+qoTpxjJyssPB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UrHwjqYw813NXe4TF5niui011gLEaw9S+bpo0Pvn/Nuiw8Fe4A9zOrz6cU9E0y3Ub2ubvhdsEd1EHhV9fDO/UfdK0xpzKD+yNC4p6ISfYwPLktLd/fYNHuM1w4D8uIs7kXDTUYgQLme+QKzm+BFsrzoAomdLAidUGOXvhmWKllD7eAMC9V1aeI2Z4nmUtg0SLV5gL1T0R572UGv3MmmY18rS9xYCQYpuY3GrZvCUyVgV+zDHjl8nIUduQqQS8++v2PyNHZWAf1ZTkZrcMxQPrwFxcMCI4wWD+TEfnaBJPpTiSwMSeHa6fvJcSo2+9GnNSBuptoVn7mhvl6LltJ4NKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SkpJV0Acr6ivunvsCeqjk4MU1/anTGgNIBbWs0F3/tY=;
 b=rzs+dUIYEtGQk8NHTAgF2mPdiX11GLOQbRyDlCDl5YUcByBy364R9RnO6wqOpbPHCjVYr6Vx6N+FuigiU+R9XtQP7b+OEDxVzOyKh2Aecd3myjR6CaxxBYKwRLRIR1tmNbN0rnJ/iEuGQoBeML9bRj2J9quKvFcbP8+F4/BvKWFd/nXKAjg9JvrT3ihxY9rJl3WCXFfvVDoAL1nx/pzn/BfIwkczU74WQfHiThN+slAiXSKA67iLYrl20zUMTgLPOMgQk84v1ZE5UjEyymS2aPTjh/Ws32PP0o0E2BTFBE5yAEDZHHSIKNi8FQ4mRkkwzqT2QQhej0ShRNy25ORyoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:52:41 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:52:41 +0000
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
Subject: [PATCH v12 05/13] blk-mq: add blk_mq_{online|possible}_queue_affinity
Date: Wed, 22 Apr 2026 14:52:07 -0400
Message-ID: <20260422185215.100929-6-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0585.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::19) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: a71ccf6d-f41a-4237-3499-08dea0a05510
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jikstcdpvatv+ANXVp72Xd68mGNZPiEwLmHOZ+b7hXq7kb30qYXvwY5dXyPAqQr0ce9XJ708/GhpiUET69XWRzlEagYVa6MC2ZFHt1mWlCX38EllQQG3p+HUIxYO4vYf+JxbhJsEAzO29PZXiG7nsV++lSgn+TpCPaO/g1QOY5t8C8dwhShyt/uOjigGv+nB8wGdH+1Yd8GvcGWttgb+wJUCWk4H9p88//HFHeoIXqOs/OEKrqw4ZAZT9Do7lgbcfcbQ+qzh+qGP7EKs+576hpavi8DEkxPtjS/mgTWjK/tekfiE7vefK378VZZIMoyzzT6v3Bhy7rb2fP0jGnoEAdBIp6ZyB+v4CKUWiw/NesR0c3HRXAwtraxTP9u1/lLvjDNd0B/5x8NBRnI5CJnz2ItYbtkc4sx6jkukpBRLwJUqVxYOb6O6CtVTOlPDDJcV+mgf+0eZYJGpeoMoInKtlYgawuC1fJXUepOLldBl0pI4sAj5kohR3J6tHsvZx6/W0W0ICWIlu1ENXOuv3KxcXjci0iXVDJSN5/BWoc6lhkOVHWgdadYOhHz3k6Rf5jzMO13EcWxFrIqaKVi9SrgXiRYzlTP2RyOrYatptMvluI45uRcYcONLLyg231ehTziy+v4AZ2w93nxBG1sZQo3rwqWYVWZQPcJ6Wi53nGJqVcT4lND65pF4Hld6o6HVm9uqxPjiLJr5/EaUmC2ST8DvelumO3ZtBsdRw8qZW3i08U4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l5cu6pB5ErwSwrUM2uUK+Tf27PT1GyaRtES8WVjh0xZHvngOTTU0RBJu2p5T?=
 =?us-ascii?Q?QM57q31D+z7/cZP2jO9OWL95GRCcVxGxbL+8GTiMIIc0iNgZFQyWh5+yJho4?=
 =?us-ascii?Q?MOtXfKA3ae41t5T8nU7TviN+qh5g35l51AUOUKjEKATjFMevmwhPGur7HS93?=
 =?us-ascii?Q?XG5wXY5aCYqWeZ/RCSOCxUoTWZ1m7z5lRvlwQyn1VCGQx20CpygGyqUIuJjA?=
 =?us-ascii?Q?yE9YVwn6jQb68NwMITU7sxgaAb+Jbzirm/LXH1TzjzN4q+PS4vOip3Dw9mkn?=
 =?us-ascii?Q?tq7nu8DBfeel4wnQeIfy8+0939OKjgCdb8Is6E1YAVycbkIi88VdHboSYTqb?=
 =?us-ascii?Q?1fowB/E3W58W1FPlx09255abNPgNdRye5l2A8ZLiyGCLE+b7tFD3cwYjnHqf?=
 =?us-ascii?Q?GKrAy0DbilIi++3snzARthekm8yoB4GQoSCUI+c7vZR8Q+B0e+mJVrZ7P0+0?=
 =?us-ascii?Q?0eGVkoBUH8qh9fdj13qhd85GBT3TGtbjLgon4NFctMFATx4XGN65dR5P34Or?=
 =?us-ascii?Q?aGUbE+iRYkhYSjz/K6jg5YTrwUHg9SONNyor8jhh4mtZoQ1EJm2NrlVkKXyu?=
 =?us-ascii?Q?fs4cpYvKtUTOnqfftBbFYgWO/oubERBONLmkGlPj6Iqkit4uq2zr2XygNLUJ?=
 =?us-ascii?Q?Gury5u/0b4zCpDCFTr5DyNdYSZgPD+Sa0d9dVYWcplhTWOcG9gVmD3G81I1d?=
 =?us-ascii?Q?62sNh5ag2WfVnEeZN3C89zUljh3QPDV7iYIZIGy2Esaq4BhGUwhmTMic4RsP?=
 =?us-ascii?Q?pM1Pjlv5ODeXNnbdp0Thn+FKiNXdZkh7KMfw8XCLI/eutl8c4kWHL9IPPbim?=
 =?us-ascii?Q?D5TGlFeoeoNYMoi3xAVUnw28z3m7ATKCTUYT853npu1RpMq4SxNFOTr3aOS2?=
 =?us-ascii?Q?Ap4mrOAki0D4So0hfcVbDaerMOVDo8ybZq6S7PAknI9iB0impuqkSWVKqPgk?=
 =?us-ascii?Q?g/q1lSD3qpgSw7SIqBH7PtTijahmll+fyEtM5x5FZ5G2vHwOsOYvK8kYBjFR?=
 =?us-ascii?Q?7ib/LcAABxPQjUjwNzMfG2de/kN8CVerJB4ojysJV2FX1j9S4Y4sfJrwiiEQ?=
 =?us-ascii?Q?DHSh7S3sm5QzSHyzrps5yesFAWo8Rq108Uu5YeOzrVEVzbc196YRlqPsIQvW?=
 =?us-ascii?Q?XIBye63SQGmETEncRmq1mwpjg3YldcS0qEf15aQN4xMNdFtG4DHbQ9tduJtN?=
 =?us-ascii?Q?gaFjIhNK9AlWTzq0x/4YmTvMW6cWXpaMbQmfxOab3oWtbfHAcEYr1muQqs+e?=
 =?us-ascii?Q?8fpN3CzdPXnANx/qn5YQkVvQpeRph4uGVhpslxidU4x8XruqgOONgk0ZvYER?=
 =?us-ascii?Q?OSCE0DhnaUycopqX1o0V8jd4552FzM1M3Y/n0XLoMXqiXQaLCeP5eii/sWhn?=
 =?us-ascii?Q?43Mf0yNK/uWAOf55LfEWzUiBD3x1UtJeRnzhKAQH40NQRd9FQMSq0rQpbsun?=
 =?us-ascii?Q?bVDlozLc7mc1p4fBt101odEarKjQtGUkGja+cDPmbMHy1LglLU1PEaJHoiu/?=
 =?us-ascii?Q?6JYAnFDUWRPFRtPAcC7VSajkh/n+OjWaAbOoVinpfR/Z7alCTrMFYf5QG4Bc?=
 =?us-ascii?Q?zog/S6Bz9tzbKxondjiVixJWU4CZf2cp3qaJVvNuUB1cuLKCgT4KBtfbYIbU?=
 =?us-ascii?Q?yb3UlEmiAKHeNZmMqoDvdO1uBhRBX1IdNQAf+lnCeeCD5SFDCqWdeQjfpaeR?=
 =?us-ascii?Q?vvKDtLGEjcLRsfQn5tKo5pmk9fnkhv6ePokLWY1rpVLLthShjMOif7XicAOT?=
 =?us-ascii?Q?wKwbNOfqnw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a71ccf6d-f41a-4237-3499-08dea0a05510
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:52:41.7957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6AtSFH/HwPANJ4nj6mcid0HTtBTRX54zoqZjNwQVAeF/R0MRMhSYYzY9uVvc5I48TvxLTOiu0BIi7CkbNVn/Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

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

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

