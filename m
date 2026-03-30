Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020084.outbound.protection.outlook.com [52.101.195.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1253C3444;
	Mon, 30 Mar 2026 22:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908690; cv=fail; b=hsrsCP1qqDflXIHLQasxWxPmO2qlEq839+Wz4+fupmeRHLtS7HxTqayDKi0YwXkCK2ztIC3b/vxfxgNaVen68iprJtAtdz74ocE+7Sknrl+uU5tYPBZZPHIYiTjhABKYTzi3DI21tKm4zLwOI1XRzmFMCP9qdzZQnKpid30nvHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908690; c=relaxed/simple;
	bh=p9a1Awwt0GnRGkxYrvS/gFDn3a5+cWAvEinlCjUUtHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kaPmR66wHEBG8W8ILvHnltyd8zhfkw+6jh6qrqyWoo3XWcXeBPkmIW7hptSQ5YJdPaF7lw+Z1UdpiYWiMzTleymfV3crYKQHyEvmXYc/DlyD7Spm9DZUTMfttRj61jrXHMI373nehg4ihw1GUSKK62n+Pq89nxLF/+GC1Khv1gY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xNou811H+vZxYqnjMEOfegeVPDADxWIT/C2+iCq7mcydAzPFJukJo0d5HRZMfhPiaxyArxUEgioXdMWtR1MRPg5/wJtOCAShi0JZjfL/BlaS5kyp6GXcWF745H8RviuHUb9HJMm0kGanwU36nR48+JL5fzj6La5QHpoYQ9Dz7bOFREn2CXqIU5HuaRvWXmXyl9eFz745+3EQTGgBc3vfjKDTAYbF4wSA62/dwJ6feuCsCQTRd8d0hwWQOgP58mZVsJoaUc7xJYn3UxC0NOIpCtoasPU/I6lRIm4XF3LzyQlpdbqP61TSmFsJGVGwD2C/hDHYJHrjg8ESgFF5NbDG1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwbSgF0zQ6kcQMV4IJAB2dAsXSyIdeIWB7Femz6RPNU=;
 b=KCrVRM4G+KDj0RUWqySMeaRgZ2aMo0YlmEG1zZZUchxh8lv+/rbUU1FmkcY/P4GwG2v59vFgQalm1NyCpRo3dgwWTyTlA+MV7fEtM90Qar1DCuOM9yffBZdBd3JnuV5bPjtQuvRSDFU0pE1SM/YnnepAnjPCpGcIA0LNc9JVok3ZFMQ0rqt4FfAqxyzBHBMa8KjtFnlfLKudstJedi2w1rEN4TUiO7DyIsyhVpA/+ZKV/HJReews6iO5u0aTIHPxPwTukq1niucUi4rRrf8/4hXjJ+w1L7yvfayqfV2PZYPTaGLLpWjnWesnSTXCYAZJGdTOdOkwhDtT5LQ75b496w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB3841.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 22:11:27 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Mon, 30 Mar 2026
 22:11:27 +0000
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
Subject: [PATCH v9 10/13] blk-mq: use hk cpus only when isolcpus=io_queue is enabled
Date: Mon, 30 Mar 2026 18:10:44 -0400
Message-ID: <20260330221047.630206-11-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330221047.630206-1-atomlin@atomlin.com>
References: <20260330221047.630206-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0559.namprd03.prod.outlook.com
 (2603:10b6:408:138::24) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB3841:EE_
X-MS-Office365-Filtering-Correlation-Id: 0decf02d-19b2-4fce-d164-08de8ea949e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rC610bBAju2OjvyBdD7t9K+UJXIcnSaaYHl7swlcEftWIG92MJgrAMk008n+dV3tN25wUwyxvaf/HRr5Y6WSIbh+TkPdkufdmIyubA1KF9rLJ4+VTOk+Sk+ZorCIts/lvCONimnBDV1f/2Zt8dcBVgzLHzk1i4/qz3EgiqKeBWohTM43+2H6+KAU5CuNcGvZwM5lEMVGh1b8ZVHRBDN3Vp5UpxgNhQAPZLF0Yg2COHk6qhl5a5acGeJPFKlmnt0a3TQ9LKlhzGBGkolZE/KVzARDrpmlnxNeJwIbwW4sLsVFDFrns1pCGb5f7U0Y+90rapDnemdDuWGF5xI4P+Vna8jkz+x9R9zmQFwkMH9x3k+ZbBkVU+l9KJA4EyBXFMSHCaVe9XhlJU/kR01a8Ah/ZcruS+xKOhqxpdGZmet2Mlir+nG69J2Qw/iX9aiVhgN+sUs7IMEB5gTZp4j852NvMoPrKo7+CquDdA8GDDDP8mgL+90fMEGe5IV6R5/F80XLMsiTNoZ3cn3NsKQTV+yAThoBAILeDpW4qfIu0lF44RAII29V1EJ4olrnAhXez+kDnqHAp+7pH2cIofjmzzD1vjIQMxofRBxA1IU/kFJL1Rkvi7rphsd9JprO2vH47bt/sPVLUJcipaA7X4GBAoGy1+/71f11d7RZ6RXatRiBx+qCGz/y641RY9b741vfpnTHbEHyd3JSCIX5iiswNmTIEXxfoVrDvQMtS74sUbV2KUM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2E97DfTE8DRg5RWYszNmt5/nTtxRnKHuSrhkg/Xgy6BpiZI1cZbr1oHBNgrM?=
 =?us-ascii?Q?t7SrrhpXdOx8LUE2JiLMMUVIlKz+FH8DrnGyTVDI2EGq9K0SgxaQw7laDvzp?=
 =?us-ascii?Q?65zXpZu620tKSVAvSWs3Qb7BHkXlpEmiR9epigAJwSRarqm07fvcfz+HNh+e?=
 =?us-ascii?Q?3Tc4q4spasVP8OvjZ6CL5/MjWjKkHjnejZ0XD3YGBCfJ1dpHZd/HD6stREbi?=
 =?us-ascii?Q?jl0I/QE/SEod6uSTsjvZtMob2UiMJaiPJWsDbnAGpd+syrrFFWqpiiExqbAT?=
 =?us-ascii?Q?yBX31lWvml/thvQzQbXoh3WfLVgTo/43Hqv120c9XHk1oJmPW855ZcOz0b5T?=
 =?us-ascii?Q?Y7RgOPLG/iw/4eg0AwvhFoaxk12oqd422YsyTyZi+za2z56rUK/yrOX90vnK?=
 =?us-ascii?Q?4ys0KMed3P8pwO7mm+ajwjin7FfLFRcGQOP2ypa1IvhdZq4B6OhJ2JbCDmi7?=
 =?us-ascii?Q?/CJ3V50eZA2eJt/qQdSmMAUlX8ugHsoeQw9+Rfh7R86rVn7Qf8aNRWaEUrRZ?=
 =?us-ascii?Q?ZaqHW1IEbEzwJIbx9eTS1U1VIEf3A16YCY/Z+LwKmRt6Y5Kme4ToK6AP9KXB?=
 =?us-ascii?Q?aFjvPXBNr7HkvCfOZQXP9G+R77m/l8e6L8bfwEtzcEdYU7RLAmOI6tppm/id?=
 =?us-ascii?Q?Ubo2DRuAJvyh7tYTxUfpgN9QEq0ff6lOP3bQvLBmJck9HqWt8WcznIPWV+3G?=
 =?us-ascii?Q?t4EV+t7Tkx7D+s8EtRnIaP9yn7r6Pgir15aRnyidHlC/u9VSF2/tqiM46qD2?=
 =?us-ascii?Q?KXNCcrFXyoIvg12bM6wZkmyPqejAE9p3HdFVkKISmr5JFSvY+MHyRDDdwLin?=
 =?us-ascii?Q?HKz/7AQeloECLX1E/tvSzJpkETVMckRlTsIOrGFVbWNIBmFd850gKNyms9zK?=
 =?us-ascii?Q?u+f+NBxXOsdcjnAQFXTwGn/FwLnsIxwkaTlWa6BHSRPMzvtm6EFAvxzc0p9b?=
 =?us-ascii?Q?O0xpYR6Xv7iWRr4lewUgxK0uIE+t1//WYugjWn9s8Htqb+7H6PT4hkXpZVUi?=
 =?us-ascii?Q?i3YcTGChwmPrb74dpd315ouwKbVg1wc/cz90LyOO/s5CjQC5IgZauwDZfY60?=
 =?us-ascii?Q?vwvKK2zpLgJHccAhBwa739uN45zDOD8fF1t0MCQ4brBNudXTIIgxTeL4PV1y?=
 =?us-ascii?Q?DODmx/pplpN4n3kY5/fhUSK8hCL6lRYNOzRoxx66daicKrly3a0BSVwaDFmx?=
 =?us-ascii?Q?3taH5Vzfxq9UW9sCT9Jn7LMa+DTgulTNOSjr1a9QQvZ7vcq8c+mBzmnHcxpF?=
 =?us-ascii?Q?6Y2NvRk936XOFjJXtxXpnUq7N1Z0sCd77NfYVO2+NNBhbD2zlnQ0MkQbp6AX?=
 =?us-ascii?Q?bvuldRliMGKHp5tdDQ2CReAywEyaQzEX8dXav0pARltTZtmCjtbTV75ej+0f?=
 =?us-ascii?Q?23OvmOyP77UNGUiKQ4ChaTC/8wH6QmREuaxasxjpcV/VmNlbaJ9ul5lQGV//?=
 =?us-ascii?Q?7gqtFKfTf7nZ/oPHzaIysebPbLrC2eVvwBC4Wufdlgvi54CbX7HE9htr2n74?=
 =?us-ascii?Q?UHRZ/d/ziZHsMAh1Sf5la0hNon1sIZe2LYxcXbqBruGyBvRMJf4D8+E/qpwM?=
 =?us-ascii?Q?qnrreKUIg1TbGu1LZOgzUnFu091uhNCm7uNFLU1XwycRKLx+Du8/eTIzUOdb?=
 =?us-ascii?Q?2iSRHl555kUEVvMU0mVGc+Hvn0ndnP7QczZkftM3lGYz2QiDrE9vmxCp0u7t?=
 =?us-ascii?Q?jMPk/4PHji/E30uEEs1UamkVz0u54axA9OkTI6JRuh3zNIui4AhIEf79fgAu?=
 =?us-ascii?Q?4Ppcpds00w=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0decf02d-19b2-4fce-d164-08de8ea949e5
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:11:27.5338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8n/Fr8AiPEAR9UvCUGQ3XPEPgu+T2tIYrLtHxCi7fOZVSvRF2IX3MPNOqhBE2DC8Pz+AzHfg8C8jyBiTB/YPtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB3841

From: Daniel Wagner <wagi@kernel.org>

Extend the capabilities of the generic CPU to hardware queue (hctx)
mapping code, so it maps houskeeping CPUs and isolated CPUs to the
hardware queues evenly.

A hctx is only operational when there is at least one online
housekeeping CPU assigned (aka active_hctx). Thus, check the final
mapping that there is no hctx which has only offline housekeeing CPU and
online isolated CPUs.

Example mapping result:

  16 online CPUs

  isolcpus=io_queue,2-3,6-7,12-13

Queue mapping:
        hctx0: default 0 2
        hctx1: default 1 3
        hctx2: default 4 6
        hctx3: default 5 7
        hctx4: default 8 12
        hctx5: default 9 13
        hctx6: default 10
        hctx7: default 11
        hctx8: default 14
        hctx9: default 15

IRQ mapping:
        irq 42 affinity 0 effective 0  nvme0q0
        irq 43 affinity 0 effective 0  nvme0q1
        irq 44 affinity 1 effective 1  nvme0q2
        irq 45 affinity 4 effective 4  nvme0q3
        irq 46 affinity 5 effective 5  nvme0q4
        irq 47 affinity 8 effective 8  nvme0q5
        irq 48 affinity 9 effective 9  nvme0q6
        irq 49 affinity 10 effective 10  nvme0q7
        irq 50 affinity 11 effective 11  nvme0q8
        irq 51 affinity 14 effective 14  nvme0q9
        irq 52 affinity 15 effective 15  nvme0q10

A corner case is when the number of online CPUs and present CPUs
differ and the driver asks for less queues than online CPUs, e.g.

  8 online CPUs, 16 possible CPUs

  isolcpus=io_queue,2-3,6-7,12-13
  virtio_blk.num_request_queues=2

Queue mapping:
        hctx0: default 0 1 2 3 4 5 6 7 8 12 13
        hctx1: default 9 10 11 14 15

IRQ mapping
        irq 27 affinity 0 effective 0 virtio0-config
        irq 28 affinity 0-1,4-5,8 effective 5 virtio0-req.0
        irq 29 affinity 9-11,14-15 effective 0 virtio0-req.1

Noteworthy is that for the normal/default configuration (!isoclpus) the
mapping will change for systems which have non hyperthreading CPUs. The
main assignment loop will completely rely that group_mask_cpus_evenly to
do the right thing. The old code would distribute the CPUs linearly over
the hardware context:

queue mapping for /dev/nvme0n1
        hctx0: default 0 8
        hctx1: default 1 9
        hctx2: default 2 10
        hctx3: default 3 11
        hctx4: default 4 12
        hctx5: default 5 13
        hctx6: default 6 14
        hctx7: default 7 15

The assign each hardware context the map generated by the
group_mask_cpus_evenly function:

queue mapping for /dev/nvme0n1
        hctx0: default 0 1
        hctx1: default 2 3
        hctx2: default 4 5
        hctx3: default 6 7
        hctx4: default 8 9
        hctx5: default 10 11
        hctx6: default 12 13
        hctx7: default 14 15

In case of hyperthreading CPUs, the resulting map stays the same.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq-cpumap.c | 177 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 158 insertions(+), 19 deletions(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 8244ecf87835..3b4fa3b291c9 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -22,7 +22,18 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
 {
 	unsigned int num;
 
-	num = cpumask_weight(mask);
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
+		const struct cpumask *hk_mask;
+		struct cpumask avail_mask;
+
+		hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+		cpumask_and(&avail_mask, mask, hk_mask);
+
+		num = cpumask_weight(&avail_mask);
+	} else {
+		num = cpumask_weight(mask);
+	}
+
 	return min_not_zero(num, max_queues);
 }
 
@@ -31,9 +42,13 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
  *
  * Returns an affinity mask that represents the queue-to-CPU mapping
  * requested by the block layer based on possible CPUs.
+ * This helper takes isolcpus settings into account.
  */
 const struct cpumask *blk_mq_possible_queue_affinity(void)
 {
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		return housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+
 	return cpu_possible_mask;
 }
 EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
@@ -46,6 +61,14 @@ EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
  */
 const struct cpumask *blk_mq_online_queue_affinity(void)
 {
+	/*
+	 * Return the stable housekeeping mask if enabled. Callers (e.g.,
+	 * the IRQ affinity core) are responsible for safely intersecting
+	 * this with a local snapshot of the online mask.
+	 */
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		return housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+
 	return cpu_online_mask;
 }
 EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
@@ -57,7 +80,8 @@ EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
  *		ignored.
  *
  * Calculates the number of queues to be used for a multiqueue
- * device based on the number of possible CPUs.
+ * device based on the number of possible CPUs. This helper
+ * takes isolcpus settings into account.
  */
 unsigned int blk_mq_num_possible_queues(unsigned int max_queues)
 {
@@ -72,7 +96,8 @@ EXPORT_SYMBOL_GPL(blk_mq_num_possible_queues);
  *		ignored.
  *
  * Calculates the number of queues to be used for a multiqueue
- * device based on the number of online CPUs.
+ * device based on the number of online CPUs. This helper
+ * takes isolcpus settings into account.
  */
 unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 {
@@ -80,23 +105,104 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 }
 EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
 
+static bool blk_mq_validate(struct blk_mq_queue_map *qmap,
+			    const struct cpumask *active_hctx)
+{
+	/*
+	 * Verify if the mapping is usable when housekeeping
+	 * configuration is enabled
+	 */
+
+	for (int queue = 0; queue < qmap->nr_queues; queue++) {
+		int cpu;
+
+		if (cpumask_test_cpu(queue, active_hctx)) {
+			/*
+			 * This htcx has at least one online CPU thus it
+			 * is able to serve any assigned isolated CPU.
+			 */
+			continue;
+		}
+
+		/*
+		 * There is no housekeeping online CPU for this hctx, all
+		 * good as long as all non houskeeping CPUs are also
+		 * offline.
+		 */
+		for_each_online_cpu(cpu) {
+			if (qmap->mq_map[cpu] != queue)
+				continue;
+
+			pr_warn("Unable to create a usable CPU-to-queue mapping with the given constraints\n");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static void blk_mq_map_fallback(struct blk_mq_queue_map *qmap)
+{
+	unsigned int cpu;
+
+	/*
+	 * Map all CPUs to the first hctx to ensure at least one online
+	 * CPU is serving it.
+	 */
+	for_each_possible_cpu(cpu)
+		qmap->mq_map[cpu] = 0;
+}
+
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
 {
-	const struct cpumask *masks;
+	struct cpumask *masks __free(kfree) = NULL;
+	const struct cpumask *constraint;
 	unsigned int queue, cpu, nr_masks;
+	cpumask_var_t active_hctx;
 
-	masks = group_cpus_evenly(qmap->nr_queues, &nr_masks);
-	if (!masks) {
-		for_each_possible_cpu(cpu)
-			qmap->mq_map[cpu] = qmap->queue_offset;
-		return;
-	}
+	if (!zalloc_cpumask_var(&active_hctx, GFP_KERNEL))
+		goto fallback;
+
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		constraint = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+	else
+		constraint = cpu_possible_mask;
+
+	/* Map CPUs to the hardware contexts (hctx) */
+	masks = group_mask_cpus_evenly(qmap->nr_queues, constraint, &nr_masks);
+	if (!masks)
+		goto free_fallback;
 
 	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		for_each_cpu(cpu, &masks[queue % nr_masks])
-			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		unsigned int idx = (qmap->queue_offset + queue) % nr_masks;
+
+		for_each_cpu(cpu, &masks[idx]) {
+			qmap->mq_map[cpu] = idx;
+
+			if (cpu_online(cpu))
+				cpumask_set_cpu(qmap->mq_map[cpu], active_hctx);
+		}
+	}
+
+	/* Map any unassigned CPU evenly to the hardware contexts (hctx) */
+	queue = cpumask_first(active_hctx);
+	for_each_cpu_andnot(cpu, cpu_possible_mask, constraint) {
+		qmap->mq_map[cpu] = (qmap->queue_offset + queue) % nr_masks;
+		queue = cpumask_next_wrap(queue, active_hctx);
 	}
-	kfree(masks);
+
+	if (!blk_mq_validate(qmap, active_hctx))
+		goto free_fallback;
+
+	free_cpumask_var(active_hctx);
+
+	return;
+
+free_fallback:
+	free_cpumask_var(active_hctx);
+
+fallback:
+	blk_mq_map_fallback(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_map_queues);
 
@@ -133,24 +239,57 @@ void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
 			  struct device *dev, unsigned int offset)
 
 {
-	const struct cpumask *mask;
+	cpumask_var_t active_hctx, mask;
 	unsigned int queue, cpu;
 
 	if (!dev->bus->irq_get_affinity)
 		goto fallback;
 
+	if (!zalloc_cpumask_var(&active_hctx, GFP_KERNEL))
+		goto fallback;
+
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
+		free_cpumask_var(active_hctx);
+		goto fallback;
+	}
+
+	/* Map CPUs to the hardware contexts (hctx) */
 	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		mask = dev->bus->irq_get_affinity(dev, queue + offset);
-		if (!mask)
-			goto fallback;
+		const struct cpumask *affinity_mask;
+
+		affinity_mask = dev->bus->irq_get_affinity(dev, offset + queue);
+		if (!affinity_mask)
+			goto free_fallback;
 
-		for_each_cpu(cpu, mask)
+		for_each_cpu(cpu, affinity_mask) {
 			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+
+			cpumask_set_cpu(cpu, mask);
+			if (cpu_online(cpu))
+				cpumask_set_cpu(qmap->mq_map[cpu], active_hctx);
+		}
 	}
 
+	/* Map any unassigned CPU evenly to the hardware contexts (hctx) */
+	queue = cpumask_first(active_hctx);
+	for_each_cpu_andnot(cpu, cpu_possible_mask, mask) {
+		qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		queue = cpumask_next_wrap(queue, active_hctx);
+	}
+
+	if (!blk_mq_validate(qmap, active_hctx))
+		goto free_fallback;
+
+	free_cpumask_var(active_hctx);
+	free_cpumask_var(mask);
+
 	return;
 
+free_fallback:
+	free_cpumask_var(active_hctx);
+	free_cpumask_var(mask);
+
 fallback:
-	blk_mq_map_queues(qmap);
+	blk_mq_map_fallback(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_map_hw_queues);
-- 
2.51.0

