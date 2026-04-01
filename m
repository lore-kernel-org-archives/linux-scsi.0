Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020088.outbound.protection.outlook.com [52.101.196.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65783C2762;
	Wed,  1 Apr 2026 22:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082269; cv=fail; b=uVN9H8PUeVrpIM2AKAAs1/6ge5Jy9QTzfeFAvB7erXxqQehbdmOR2nvpI8lesKwFyV3ltgaOIpX5/90WZ3+I0KuSIzCyDRmHS2zAptsXEvw/VyCAVt8eMpESdtbFjNM8FRsv38TQmdrD9w50yah2sz7k4Gdv++y7bZJMg1tN9Zo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082269; c=relaxed/simple;
	bh=D+njnNDo/HbTiSyGcClYVzNaZMerOJ5Uyaoq6X2mz2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y1OaZD8g2eHZqux2DiO+Ect2GlAhId8/wfs3hqb7KAxAhKQFTr+/tbBGjbY38G6Swfu/S+RcBvqQgdhgd0+uRd7fflQiV6NLG9OS/v+TdqzbKZbJbhw4Fwlmi8e/w5Poo2CAkEb8RyNayfBt/0w9uMSWtYPp6Jc+90xQQdPw0ac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s8aXSivFH5l9FFJ32f/8leUJ7+ZUjWxQ77+rBstK75w4cdHJ+Ki0MFoFlEjdA2RQSxFUr2EABv+c4Y/5C8CjZXnGoGxH6FSQP2rw1nCRl+h38c2dxxB1Rz7W6H9sn+iSKMaW8Zka+09AVV0Q+M5f/LgKb94ZxYiMx80AYtL2p8yqGUDg2/JXqYu1hwNp0NuHfbR45vvXbLFHOUj1sODITwPYFULSnq8xvJWicanHwUIV4uxOaDSE6rbD/pkzFVL/OXqALoGJIR/sVpc9uuYhXzaq8JftBC0lRuk+fhAUHzUMbyw0smr2+t+TKxv8zew5WOxgGmAX5GyKBEOFln8e0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhLiXCPzR+KdQXTmGMyp7QYYvZ8Gjwav0RePxxHwgjw=;
 b=vfHYH9JbqYYE5XFJ+y3j2cLpxGklUwBpqQFCz84j6jo6Zu6qgcs0h8EOlZzFYLzNTynWoYiFlS3B3m+QNjg/q2WgupWgW7Sf2G2qrISjwEaWdZxcqDUqES+xceRMkWnejuSqAaMgHywsOMc/MSd7vnL9eZDn93L0p/S/0JIgczGc7srIHA35cI8z1HiJft4zqczU6lVfSEf2qe/obX7bWw1JdJlxNUXuzU2z2hLTc8AmMtxN0iz2Aengj5I841N5JBlTIbdijp53IK6JDjgGK7HrjOoeGsYR9tki+HgZXstttRziz5ucTuivHfh+k8Lmabt8pjIBeXT4sBxwixUinA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CW1P123MB7844.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 22:23:41 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:23:40 +0000
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
Subject: [PATCH v10 07/13] scsi: Use block layer helpers to constrain queue affinity
Date: Wed,  1 Apr 2026 18:23:06 -0400
Message-ID: <20260401222312.772334-8-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260401222312.772334-1-atomlin@atomlin.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0041.namprd04.prod.outlook.com
 (2603:10b6:408:e8::16) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CW1P123MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: 04dc94d5-e357-4aa4-ff48-08de903d53d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hAsxrOoFCisqjLYr37v53gnqpd0347J0GRFTJABLpP3AoQYuXiw4qib8Ylw+8xI+Hyy0jNHx77JWk8o6Sdd0OWrl/10VWWOuY5aPKT4JzWMVmuGXQJGl6Rvi8HjOL8mprZshLEaSIBNLrZgzh7JyruE09z0WH0byv60eXzhZz4GENDD7u1t+8dV4eWmrF574EHoh7YkrpGgE8NRk5UzdO/G7T9ZwRNia9gm6KmMJS67xgGkcnGxrMlw7YYuDYPcnk5v+lXmJSnAU1BLmsz3pTSsd0LIIkhGTW5Cgh7WbKENWbG3EPm3bX0Ovw8JdKDGgAWhfE8QFxWqLax/9SYF62pezhKGpFDTxka5brzNkYL2bxhGkMjkRTd1QldlMzQHznHVAp2NVYUZEANwf3XxK3SJ2wxVajNYB9QpiPaMmMcO2IDOwrB8OA/w+p5Vp1I1hOsZJhAVeE+O+cj68bvYZMXTfmDQC54FbIuDhrlMqJHVsMAamhv7B9XO+DHuX7op51RkZwd2BNsSGeHYRcYl4O0dAaY94zoWCtoSe+9SqNXrWbOKayGetH1zN0NEk8DD2KAOf03nsoOdMgCtBsBgBxQqo+5ijBiiQ5FEUSdGsZcTX43omTYKETD34tnJBVI2zNqZEQA69T3F0pnw/0DUcYbNEYxtR44MbnLbeW4tjizqFVzD1oF7DVaitUgdza6yDz9BkVfbBXtEz2Sozz7Jek/tgiWI7aFQeLtVgwTGnQsU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yaU1oAln1m7NwtEc6sZ5v8KqE4xH05dUftBDZhvTKFihkR3lz1sjrHoeq2MJ?=
 =?us-ascii?Q?7PC8ldZUX+HDzErpXFVZIae4pA4apsFPZjf4nir9SqixMEigkfwQSFxZTrRl?=
 =?us-ascii?Q?lCM7bLGk8Veud0rLYB9ZTd4z/8+u0pIFAHrjUO6A5gvnyt53YDAvdmfCRLGj?=
 =?us-ascii?Q?5y6mPN4NTeE4QL0gq9g6bap3cyVPD45b22YAlzor8UaXXKTgzyZoRQrHsHEl?=
 =?us-ascii?Q?8xrj9m2zkSsWQhvq3WmnbJaM/avHpsRkjfu+xfboEaHNHAW0RpernuJ7SCAZ?=
 =?us-ascii?Q?L9vxioZ7x2KNnyS35/sgw4DofztToiqH+TXbtr4j4O66qlnvozZtUtoC9lAV?=
 =?us-ascii?Q?Y6NM16lIBT5JpBmVh10tDWAroDLce0dZAFceHTwV2nv4QRMyJl34ahVtqVAy?=
 =?us-ascii?Q?x2jxd4y3Uzfn5QQVaw6bkJ3kGmO4t5iyrk9YIHPllg4GZl/CjZQ7/A10K5lj?=
 =?us-ascii?Q?mzfQ8swzLj+NsUFvRsH5y52IRjrDQiD8mZS+03CoFY4xUymMCcX0579egdhC?=
 =?us-ascii?Q?sNUg9OX+lM8ONShaZe2jZ41D/+PJiH5rsdWrJ8Hc2aD7rvtA44wS/FRLDu35?=
 =?us-ascii?Q?Jjraxzw+9D0fzspMbcGNJQDUAklSDNqqv5j0xlpp2RHoMto7gyuqmh6qVtV7?=
 =?us-ascii?Q?6geGJg9j3WInW2zMzgx6yP56fASdi00nd2yWAEDwte3ACj5vwftrGOqMIr3B?=
 =?us-ascii?Q?8/UD54SGY5c/hnRh5uRa0xGNbv1rGzSPTlswzZ99DMzaH12J6jc8OBTL0r7v?=
 =?us-ascii?Q?Ll1aukK676bxStsadDm8cRtUSvAjiFLxU34Qwsa8WWIU7a4iw77mm9XqO+HI?=
 =?us-ascii?Q?aesaT92fCIntTSA9TggQ0Xva/ctSzPn2WEjAp+dgG/TKMGqOj5fD3xSY8N4U?=
 =?us-ascii?Q?L+y/dl045+Iw1vGnJtcDs2UtxVdgK3iFmIifElyo6tjlbdmBeuSk6BLwMs6P?=
 =?us-ascii?Q?oZhhUScVzHOlo1Tl/vs4sOyx5dsGcZXxM7V1f/INi87wQS8uZ3dextXckYaT?=
 =?us-ascii?Q?h67rwhoSb1oTOb8MYIxXQcrimRVYh89Ir6yaqctyeN9rSFJf5zd2KaJDg/fV?=
 =?us-ascii?Q?Y3MtIlwyy3PHr3u02huW2Cyo3x0ZVqRoFQhkFDJ1peKLezjUnIjsytkq6IKq?=
 =?us-ascii?Q?NFialU1yI3mbSnEGeP4d1o9xCq/BUnUm4IH4h0O9tZsA9hs9iPFjLmDdxu8C?=
 =?us-ascii?Q?3qQ6IQON/05sXYEJIC+c/D9GDSr4xP0jRhEFhB81I4r2otoJkMMXgqIOxdk7?=
 =?us-ascii?Q?XT4syYLJF3AaHeuHDTu10ZKMS5vg18rir7y+u9hIAkCuNe62qPu6PruwyEZq?=
 =?us-ascii?Q?Rr9QF14HDiEEwUYon3tzvd9N4/h3U2fo/bN419vFvMEMX/7eLQmLCdWhZEoF?=
 =?us-ascii?Q?SrPDN7JL8RC/g1G3tI36ygLt54s6PibLPf6yYqYrNq70nU5ayGPuz/5x0Umz?=
 =?us-ascii?Q?FKWEm/MDfimswzA5oLUMOYmWgAqh1YoTJ1GLPBJ6KMdAKjllDfckvSA0/9JR?=
 =?us-ascii?Q?fq+d95+ck0M83luhZAZPpg9O8tBFaiUgPri/SK1mxOyrSwY1m/dzKss5gBqj?=
 =?us-ascii?Q?fX1CYiGYKxX06Wb4J4YReo9fVGepw0Hv8zQFmvRFux8UrHvfwbahJ+eLHiwO?=
 =?us-ascii?Q?OXfCs1VaLC29U2TLcwPjgQjo8F1KWNdOFM5uvGSlKvM0AqzauuzoHdQIJuR9?=
 =?us-ascii?Q?en+ceuKaz5JJoAB8/Rkij+NmF6xf8dWx2jxVtzXBhnJlOjBs6m/6+QYp6nl7?=
 =?us-ascii?Q?Y32eWUS9Ig=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04dc94d5-e357-4aa4-ff48-08de903d53d7
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:23:40.8834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKmdoK/wrGu1HlSLZC0i7pa1eOSREjZT74BbQhEx9YD99gAfN0gLALYXzsBwKpnXjlso0GfP4ZNWq54UmIQJrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB7844

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
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
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

