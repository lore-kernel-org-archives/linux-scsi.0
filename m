Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022122.outbound.protection.outlook.com [52.101.96.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81913A9DA0;
	Mon, 30 Mar 2026 22:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908680; cv=fail; b=poCoagdBaaifJxPv5lSjmjVxG4LFv49PPh+KvEw3E2wt4oUKu0eAwo2o/19G+vTUDQZKyR9PjbGkJVqRM2VFoXJea0DrqPfNa9PVoh1Fyl+d0syndCws7issb6+MxpPFzmgD6COj50AM5ZUTz5rTcwkVYQXNifd4CDYsDeGr8Vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908680; c=relaxed/simple;
	bh=ZtHXTXuhRLixZ8YDE4VWjxTulOWcXwiKlpbtJPApcHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N3b5nXz7qwz5NKFtkfbvnDKBz2K7n/tvC0LdlSxsaJe/DQM88W3LoPAXYZw/DCfzMCOJfQM6rU/vZWBu5Ie5khxvK0RjGeIBzjqb33c27U3tO/1yk/BRVTnMv2GMS+aA5NbcaARhddhUXn7ammHo5UqzWdowEjULXrgMfLXAXsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cYU4jPyD+Re5/Or9X5hbuSFghFkClL4fQ+qfJQv1gx7/fXIkTYgt+JfyW79HVzG9p0wV8fP2kfUUQrfPdlzPhyngG/+/rwJpj0y9WEUKdsEskWHUhcjSIlK2LUqo1Z6gog2ZlHzrYUDW0nbLTyRREhQDMIV//7gEu1AjV5t1A8jQb0fR4sD5O3Y8uDl/HAXdzzp6ml8lA08UVbcJeNaEPPRrVHlI9uSIkp8RRrWspgHKxQgClALB0HDMlOW1wOC72tIqtWIelhV+lEQjiUXfAcyFcHaeXvk7+WkcSY8eM6D3Ax2egrDAO9RRPgZ9xgdSEo0nogSyIrJNGRTFx24tkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0pTvN9P4etYBk0A1+gap7BVahQIMJJqvkuPhay4UMdM=;
 b=bDnCNpE1v21Go/548M/tiwT98NARhfDQJQ3GDR5a8aNywnSNBX84pMhDU70XxxMIv3UjKpkCS4W8Qd9QSCIR/boHMXA2gtUgZHdM006VOxEtOMYwjPzQ1eAuVzGds/3aSGztJzvG65r1edlKxmEnV27EquFofERQyDqpgJQ2zlXCCOqLdSmTYpigB+E/9oIgmkYq5vkyGvogkeXFmhYyRwuqrz5ch2PpKfpgV4Fy9Mex9UWzuADhOdU/mHLVJxg7u50I1a2bhh+DKzmMak4tqB9shUJMi7MOytQojESFGug9DKGRJuar3LnsmzrjmhXHFIMM1wZE1YiKMoOjEtrjZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB6512.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:186::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 22:11:16 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Mon, 30 Mar 2026
 22:11:16 +0000
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
Subject: [PATCH v9 07/13] scsi: Use block layer helpers to constrain queue affinity
Date: Mon, 30 Mar 2026 18:10:41 -0400
Message-ID: <20260330221047.630206-8-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330221047.630206-1-atomlin@atomlin.com>
References: <20260330221047.630206-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0894.namprd03.prod.outlook.com
 (2603:10b6:408:13c::29) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: 0038dc1f-f3e2-476a-3dc4-08de8ea9436b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	w8fgREJDIaCKCobUPyA5m1i4p/+XksfzPTRqIWe2706Z1qUITSgXb6M3S8928f7F9YSt59Uciu+QAQBNy5rDpX60PYNPUPlt9h+dRB4WmYGH8jcqe3jB27dnt5wF3lI9UJ8WgX4VTgntyqoTlqnNH5uxEiBSp7AHRzkGaWhyVjzudtYoVKMaKT4SuQXf1iDxgZK5l11ngCm9XzXQr+XATO8QHO2ge1acTwkmVG3Try1LbJ4B3B8+LJ+xOEn4pn2wzZLUr16e2OJEfvLCXLGuNi4QmZoUMp36igMWh5OxuYeQYzzgapWAOImjWm5SAFphluoek6eNmPhR0hviX48CIYDF7dr8pX86pojCldsf0CdDDm3Y+/qSJWkVBek1byUjySMgi2WKtp7ryiaetHz2ip5xPbe9jBhwYmioQMIq3kQTSHEvS0tmutygu+j3yLN4tePBHraaaeNrZMXwlDQaY+qIjTZYpHSTLlz6ceJ1wKGsTHvsrbRU8VJGl54yLjcVEKR11VxlPShNqunBGpbOk6+74s4l01dIFlLspHiyeDHop6CtPEgQd93HgpkPOFVHh4SQVKRnopptSN6ip3Esy3pOhdNVxVJ2cvG91/8k7laE+Gtl6Az+7Hgzso8VZ3W2M4FDIbmNjQscFTaqje4hBXD2lOtQ8QZJKop6bT3prpr8ma55iflYEQgfGJXARn5SZ7haIZ9oiasu5GtPV1ImDitjmkCFyjuRhQj6bg4MU/8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kl/QdHOXg4S4vZKEQp6+TrU84M9hSdzJRhKjFFyIEQ7BUe9sN58xhuvfoNeU?=
 =?us-ascii?Q?en3yJermeuuLZk8tyFoGtq+4OBMDAzGtBmGSfRg7pvsJ1sRA82jsKRwX4tFy?=
 =?us-ascii?Q?GXpdYH5UkBVfTf53hzKyEu01o+EoJqwKfsHFm2icmlmj+XEuv+CbSNAIyWcz?=
 =?us-ascii?Q?2KQ8C8VYQSpl/yCkFV5vmXi8esOPUkbC3Bhow5bMrpmezzmFR4LpZLhQJHmX?=
 =?us-ascii?Q?ax2LUBBcHdL2U38/TAC7nE4No+eoHK5ukT3dmtDhCaPgDOMorA0uugREI0PH?=
 =?us-ascii?Q?Hll8VbQexf1Q3jM5WgKu7kTXHm5KyTU0j+kNqFyrkbbBN8SxobER3jjZUpEv?=
 =?us-ascii?Q?RsvrTdNzvXpLE4iyMzsINFz45SGnMeZ/cAWWATF6opbkzCL5KVQTpK50QjCx?=
 =?us-ascii?Q?OVv5nnESZL/3UInR9ei818wjYmNJJe2VF0GW4Jv2ysj0UbTo7IQK+xWdSQOi?=
 =?us-ascii?Q?m0IAeh/SkCkBqPWkpW+/ejd3fF3UxkkELK1rhDG/jB7X9Fa48Lf0Udx1D9NL?=
 =?us-ascii?Q?PLiPzedhGXyok4OP6IdwWtRrJyfpgToN8f4WO1l75j0BV/ybaqmlkGeSd/Jx?=
 =?us-ascii?Q?GUdY8TiWrS3XSMqnqT52mUJnc6shrnHiVhzjNQV4TdrE6dXsYRi2qUZ6QNSO?=
 =?us-ascii?Q?9r4Vgtu2F7sVzFgAOw8gV/OVnENi8cwIxbJDdNyH5JRLU63ZvMBbw6fhxr4j?=
 =?us-ascii?Q?dvGTQ8z+uqgayZs7xLl+8KUqPnFqTExNhebysrP5Rcmj9ItmWAfOe7r5xncj?=
 =?us-ascii?Q?cUaAPxTzefvVD8+0vQbJu0bD73dz2M87mzflaEcJ9qOVDXpjWIBQ0EmDrdLx?=
 =?us-ascii?Q?7SaWQd3Jj83jo5uFMU+fM00+u4MTlsNJOdPJXWi/UWdEjbIBzJ36zvK12ibq?=
 =?us-ascii?Q?bY6GFc88pEdg0kKtZ95HFY+arNvfxcrDGQcoj/e24feV89RI/UfokTCZiYgI?=
 =?us-ascii?Q?1LVOkIrF+rxMuhLXQL+8jBwGIJKu8VJavCGAns4Y6DCS+bEXnaSRLTl71u6w?=
 =?us-ascii?Q?XBOYO5mYJ6usoUOxVkdCb3lMLrcDeh35Bkbrfq6e7PC8ZtOmhZn/uQyLD/sB?=
 =?us-ascii?Q?7pTP6rc7Y/cekAAcoH8C0KRTpHPOfUiUBA31XDo7MJtv1aXgfYoiu2j/Drmy?=
 =?us-ascii?Q?cz4/kG6OYx/EXy6/sxT2GZhQSSuMiG6xrM98dGuyBZgWKJQ/CeF3zrR9HTM0?=
 =?us-ascii?Q?Lxlh/YgjZkcSaUbtre1hiwkT4OvEFyA9xuXsiC919qI/MK+vXGstKLdq8joc?=
 =?us-ascii?Q?TV700CVesXVYqCCuiMHfNJQh+/PAsUy76r31C4KR/QW8XU+s3pVuRH7wbhl8?=
 =?us-ascii?Q?Fkim4Xn4OVMNZTsRJkbhI4eYG02MhM8BYvyVFDfdAYbh2fRekL1fEkCAvnHM?=
 =?us-ascii?Q?uL5D+x2KD7/3iRLTqRm7UfHF7Bkw/LpWjykaNS28DWtMV0aD6BwQexTFZbCQ?=
 =?us-ascii?Q?zvKGamKRkgIgbb2HePfXOoxHBDiy/ZXiay/Yxf7C5CwZoJosalplo507hhzd?=
 =?us-ascii?Q?/1APVorYU+DD00jTP6wVKuXGdjenvteq4lnGTgDgBPywM53+wicM3LM+4wKK?=
 =?us-ascii?Q?UkAv4y8kvcmICoZVAUFZql6RbwwYuL1RTVyfZtwWi5ilbUOMdJ5KJhbWRtgr?=
 =?us-ascii?Q?B4bNDMifG5Ki2G0M0dXNIBHWnSD/uRBAhjltf4BzdwkjC8zIqcUFUhJc7HvE?=
 =?us-ascii?Q?SLbWxAQyhlRx330PHXNoJg22Myz0375B6lsuq5V3V8AIfSTXOkeG64LWThmt?=
 =?us-ascii?Q?3RWZj/AyRw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0038dc1f-f3e2-476a-3dc4-08de8ea9436b
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:11:16.6096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DLh3lRvbS+7N9qvV3jvlgNGGGT5xR/SN87A4QUuAgSsD6DIQNZw4HLm6ZhZhlq0QE3jS1K2Y9Oe2+1qcCQXvYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB6512

From: Daniel Wagner <wagi@kernel.org>

Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
constraints provided by the block layer. This allows the SCSI drivers
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

Only convert drivers which are already using the
pci_alloc_irq_vectors_affinity with the PCI_IRQ_AFFINITY flag set.
Because these drivers are enabled to let the IRQ core code to
set the affinity. Also don't update qla2xxx because the nvme-fabrics
code is not ready yet.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    | 1 +
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 6 +++++-
 drivers/scsi/mpt3sas/mpt3sas_base.c       | 5 ++++-
 drivers/scsi/pm8001/pm8001_init.c         | 1 +
 5 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f69efc6494b8..d1f689224e7b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2605,6 +2605,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	struct pci_dev *pdev = hisi_hba->pci_dev;
 	struct irq_affinity desc = {
 		.pre_vectors = BASE_VECTORS_V3_HW,
+		.mask = blk_mq_online_queue_affinity(),
 	};
 
 	min_msi = MIN_AFFINE_VECTORS_V3_HW;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ac71ea4898b2..7e2a3c187ee0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5925,7 +5925,10 @@ static int
 __megasas_alloc_irq_vectors(struct megasas_instance *instance)
 {
 	int i, irq_flags;
-	struct irq_affinity desc = { .pre_vectors = instance->low_latency_index_start };
+	struct irq_affinity desc = {
+		.pre_vectors = instance->low_latency_index_start,
+		.mask = blk_mq_online_queue_affinity(),
+	};
 	struct irq_affinity *descp = &desc;
 
 	irq_flags = PCI_IRQ_MSIX;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index c744210cc901..f9b8b3639c64 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -830,7 +830,11 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 	int max_vectors, min_vec;
 	int retval;
 	int i;
-	struct irq_affinity desc = { .pre_vectors =  1, .post_vectors = 1 };
+	struct irq_affinity desc = {
+		.pre_vectors =  1,
+		.post_vectors = 1,
+		.mask = blk_mq_online_queue_affinity(),
+	};
 
 	if (mrioc->is_intr_info_set)
 		return 0;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 79052f2accbd..91e1622b5b77 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3370,7 +3370,10 @@ static int
 _base_alloc_irq_vectors(struct MPT3SAS_ADAPTER *ioc)
 {
 	int i, irq_flags = PCI_IRQ_MSIX;
-	struct irq_affinity desc = { .pre_vectors = ioc->high_iops_queues };
+	struct irq_affinity desc = {
+		.pre_vectors = ioc->high_iops_queues,
+		.mask = blk_mq_online_queue_affinity(),
+	};
 	struct irq_affinity *descp = &desc;
 	/*
 	 * Don't allocate msix vectors for poll_queues.
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e93ea76b565e..6360fa95bcf4 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -978,6 +978,7 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 		 */
 		struct irq_affinity desc = {
 			.pre_vectors = 1,
+			.mask = blk_mq_online_queue_affinity(),
 		};
 		rc = pci_alloc_irq_vectors_affinity(
 				pm8001_ha->pdev, 2, PM8001_MAX_MSIX_VEC,
-- 
2.51.0

