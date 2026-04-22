Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021126.outbound.protection.outlook.com [52.101.95.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B682731E827;
	Wed, 22 Apr 2026 18:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.126
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883972; cv=fail; b=PbH02knH4DVytTzj1VHQLqTtS+cwRFpNOK4i5gEOCLhCBrydFCp0bf12gVGhAMfehBhKbajCCYUiLWo7U88Zbz/4AE909iVpjgzTCZOErtgGrY7QRtVQx8YWPEpA5q0fNzXPsP1irfvySb9n1Pq0MJR0PBEYgIe9DTGlwgJJ2hg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883972; c=relaxed/simple;
	bh=aspbGJGGlM2hSjKM4YmkAnwTrSgrXtM4co3HYQWQVC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qi+8yT+lQmu8eFxeIfQ5KX6NF/zaPkV0vLTmV15cv6i7DeX22U6Xcfb99VjBgQM5Dr1Ku/2qRoXYn+FVDAJD8bgio5ip8ZhMRt6/d5kMi4UOiUn6OiWAjKHl8pQl8StQ7jls3I8JqSZwxZtfMOMOCmIH/BTkR0jY1ActSYQ33Kw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkaK1fa66ls/6RXH0UOGihZEIhDLcxTlCjROlaZ2Q6zrivs+TDGSSFIba5RBjwr6saAYYgPPGoIupf0scMnh0RsOUa/lpVa6nl4RC2sZY8tsRfL/R+nfr2NmNsYCpJ2uTeciZ19TAQPCt2QmqVr3NpreyG5U7i7tHrUoPKNxMGihBDlDf9Sj2ib8/iz94s+wFFJysRSGjYmj3UC/yzwyamOcA+YBeqybkAX5wJ+9yYoVCEj5rXg4HbbAJQ9FvHYvx3XiQ6XxyUFQpC0DDcgNuxYjtyRcHY2knopfj9jXtQx0+mfXLkJxOSUVozzdKgSLiMqkqvK4RJ/FzknHCA1CGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1ioYCYAoZXZHFgjFhTL9LMHDkQaQnE0c0CtuflEgds=;
 b=ywlgEgTaZmpf/ii/m2d/BNYeCN21QlEym1F6KLZOpVdf5jaHJsq/9SeWxHapju/wMt3UOf5RASj0SmyDhLhMgFUsEAJCSeYcYJtcutmAW4YoYKMfYNkJysOZV5IEO4Ycd4vyE9Xc/H6AUFKs+O81SmZX1gPCjPc5gLvHttii5N7/wII57p3HFHvDAzbPxfV2HEDvfgCWTRokT8qvyC59O09Kzu3Hu7UNCXjHMnjpCacmqmz9s4IdJYJ52reyGWRziMCcCls+2qduVyQwbMape3kOF5uz0zF8492Yh44uOcIbCLss7uptMmZbXqwMuI8rcbB4t2vWa7l0EkMDzk14NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:52:49 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:52:49 +0000
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
Subject: [PATCH v12 07/13] scsi: Use block layer helpers to constrain queue affinity
Date: Wed, 22 Apr 2026 14:52:09 -0400
Message-ID: <20260422185215.100929-8-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0323.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::11) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 04576310-c4ea-4f75-d67e-08dea0a059b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	u3lRV7HiZz7EIPKXOpFOLNB85bpPkqzEGxTJk6yeTE0y4gRO65Ah05BjdeiOxd3Z7qouhiAXaxJVQla5mrQS1Tq5hShRnvzAZ5eIsqcC77B+GYl9Hz+PaT7h76AGkPQdLOHhkUoBuAYFyRWUtfQt71m+MU88/zO7aWlu0S/7Q/y4gfWKxf1w7N0sfLupPKXA3e5oiXvYmVq9BjwS2roGQm9AICtcsrbJUILAL0W81O1eBukaGyOV829HFh9vB6K+xeQ+dau0JNNHYmUe3wHzsiFMJ/QFZ8VSqOHxh+1O5MoRbJN5i/EGcpeS7fbamHFuvFkDFSF+IR+FU1qI8IEeQW19VBSC4wqHiqKfqnOWtcOb03c7v8vgdZj8IMrJEbNawEV+1643hz1rooZtc8RmzGGFdEcOFmSlVkQZrW7iDTdNb/JjSCEK+OBgT0BBoHpigXk6bPLdAO2ELyvT/oEkP+X+ES3mJE8JFPnjXPvnM08+OLFSeLsNccvX4+uYMjooqRSo+ckihZBlZ4hONxoFzcitT76Mz1lgK7ZYrqK1g/LfO6TnIcsn0qM7BwQzfXjspK8IpkN/pC8RKs7M2GpGJGi1E8FoaqhnTuLAUoma6TEi9I5PjQSHAAyhk70/gkvL6hhIw6QVvGoJiuNrtZSLvHZ8JDhuEwSuWxZf1AH5UcCs6zFXFp5dpzLqnzf4nV8wAbCXUOOc+XJq0z74soVRmcj31e2s0lFOFT9GTQy8GCY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NdoZgGbuF4Br5ZTZU4H9sT1GwHSMFmAceuKGdB7U2Jsdp+77vasgOtQS68uH?=
 =?us-ascii?Q?Ozvi5WPIiJdnCVV7gwwaYDThg3i3mGMxESoYJkbh/sY37Glp3uj5izJRYeLQ?=
 =?us-ascii?Q?1kfV1GXXJgILsYAsXi0LZig9arEC8TJIMLSjTZ/AjBtYn/p9birj8GN5bKmV?=
 =?us-ascii?Q?Im91dRHpUblKeRWtFeCJ1Ezt+N9V5uSGf1eXKoTSYbkPhHchFIasEY39VUIJ?=
 =?us-ascii?Q?x5WVPFbP49bLbYxjaw3y+ac/w6fSSGAXdA7WrEBHNJtEI/Mac93a02AkWFxY?=
 =?us-ascii?Q?LSCA/pdKygm4JeDA15xGjTL8G+Q+RHxwZk2NAx30YuMXAccZXfTmef4e/Qxg?=
 =?us-ascii?Q?oqR5yl01t1u+ilK5y9sjbhefDp6yZyNH+W9v8Uu0aZAxKqEoN/rhoiO4WszN?=
 =?us-ascii?Q?DcRsZO9M0Is2aQtmLIpjAX5gH+ECOOuyVGvZHdvcN61IfjX882e3UIzewYyz?=
 =?us-ascii?Q?GkGuwC5b7OMp6k3GJ/loFIWjoAv9tlaEAsf9z4QEeACVlXtcxvYWG+4zqQ6r?=
 =?us-ascii?Q?np4lISXfC+2rtmeSM+jkhALJlcEqS4ch/obSWD8Us8fGK3TbGY58LM+suH7R?=
 =?us-ascii?Q?YeS+4q1F8G2RUjLLEg3uSoj0PDkcw4hoX0kdLbcrL9x+e425GejP29ogOer6?=
 =?us-ascii?Q?eCZjIGM4QBFk3IU9bMKEx3eTw4rsMF72NZPVkGaFv6dYOlFXDwJSeSvzhbjZ?=
 =?us-ascii?Q?2E0Uin8pgGt8a0EvLsAFp2ITpci9/Tmtk1ttpiOWq9tVgHbTIEW1gFXdrgaV?=
 =?us-ascii?Q?9gspsQTAI9Rn+uI6vdcoiR9ViW3AVsHXqLzJald8aC1HyL6riTXHBRKDcChJ?=
 =?us-ascii?Q?K/qH28rDiXgDOg0AUoeymxCoZhciwnM0Jh9JKxGlZlFLCwbr+Bzv1EjYTe20?=
 =?us-ascii?Q?/NlZ8eJ1O2psHkQlb+TtQ4EA15tN53zPCL3955HVHia7jSeGpfQVuhgUhA+3?=
 =?us-ascii?Q?qWH69NhUEqcCyg7TB1aYGR2LWISsTufPFP/i3U+zdNt0IovYt8Axyvn0/3vJ?=
 =?us-ascii?Q?MzcAKc5mu0F7KIVycRFtepITP6fxY3OHy7XemNgvCjapCOLotd/KLWh4yCE+?=
 =?us-ascii?Q?3TQlGpk45e3FjduM/NRn64+apbMllMtcc6768ZEfiuIUGaHimurYY19TqQN9?=
 =?us-ascii?Q?e3AryNJsxCbruQKAF+O3KG0nb+Gnp7/VaddFM/hZyiEdBfuWtqXOSzMzEYKr?=
 =?us-ascii?Q?uX03yToWHSTRd5uslDWLNrqxD47XAMAI+0aopiVyE2bKWenef5U+QHTEbTod?=
 =?us-ascii?Q?7iL/XCbrLuQ9n7Luyahorv9kAwzHAA+mje3nR1+1crtbeRWYuDAauSCUP8h9?=
 =?us-ascii?Q?DLEJj9+0bwb/stLexEaE45W722I7RO7At0T+QIPnC/2lKnbr3owo49Qdp9Eo?=
 =?us-ascii?Q?naoTBE6sXpc0noQccXXZhIBvExTlhjFm9bWVfjAMeE+Q2UjBgHCnxLXRWH6r?=
 =?us-ascii?Q?Milo5NLqVwILMnWVt7y7xWZnrfPCWotzb+YmMV4pCmH3xgT1XXK1H6A5rFjH?=
 =?us-ascii?Q?fVVhFSXqWH35Zv3CS1KTdQK4XCm5kPygXGlz5HYE6W0yqA/jdhCkgTSVxUSu?=
 =?us-ascii?Q?dYgnZ9kLMtKJ4s2t3L6XLeH4NAHvhq4OXWOEB9xteY/ae1f8MZGkL4QAiOOm?=
 =?us-ascii?Q?VtdWaa4Ro1LbJtrsc1nnASHdf2mXWLYXe1QnNY9inICp+eD7o8PL9toSeVMY?=
 =?us-ascii?Q?+GKq6F1N5Be8PPxaa6nQzke9ERWEXWJHOrTSn+VZoD07IWbvVmTqi0IhrGmN?=
 =?us-ascii?Q?dprtVa7kXg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04576310-c4ea-4f75-d67e-08dea0a059b3
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:52:49.6989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l02qOg7eZyp1rnkW3XCW26MY8ei1F9zw5VevBCR7hT2om9OedKh9JGgpfr1dqvxO4BczzoPsRsKsKF9weakSsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

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
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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
index fda07b193137..4873c66b9f98 100644
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
index ecd365d78ae3..006a3bf0cb06 100644
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
index 31b19ed1528e..156323ab9465 100644
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

