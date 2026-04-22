Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022121.outbound.protection.outlook.com [52.101.101.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1818630F523;
	Wed, 22 Apr 2026 18:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883995; cv=fail; b=qjLg6KNIJRl7dbRmrcp1DDmkHgeq7hYs+C31U7y3wrRj7EFO4FKuheZnXctriC5M0qF1UnXxHEMlDWNRpSr+74ODWpji9pUtXhvikv2wPn3BVKv95XxIItg8oCFcD8czvYHIyMnPbZhI1srYlK9K2WBTPbAFQKCKDli8ivk7rZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883995; c=relaxed/simple;
	bh=w7ejSIrAujAicIyGs/TvT6jahUowQAw5SRWPIFuS2fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=utGavszytU4os+pHEV63Fmc9B4WBLilnzyZTc5+0I4mTZMQGKBzlY3Vv2NqZnEAgzM/99VeC9sXWmqNR18MJ8gfkOMvtSlLw5ajeAq0fZRihuMsmpPEoTkhpB1crmVsFpfB9P6CnAhCMLB4fqEz7fQDaUfVtMylx1MW2sZqht9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=otyyPY4jn+5GtYPgGyUWWnirSQJTLTq/Evyf3UbLmJHivrkRWdhFNQxpZ+SafHvNAoyYSI7I99dabI9M6DCoYtUSS1fjF1ArTftVXhK/wIkKnfZia6yjjo6OpoLQZ+mSzg/VryYefHj66YBdY4sf/PyNVJfVWcTAfjs74xJ8aXSTuymNwdqfV1XfFxDG6+lzi+yrQ9qYs7QSMpPDJkdbHw0BhhKAtkW066baTMjFiyQhDXM8QxdajXrnrPcDeDc/69Byy9771580+Kn9bhcw8DlNCP2yH7mCGwIv+bQSLF+ZAqhsCaNFkYbIlwqMsvC9ECJTafLltMXUnThw5vlDKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xmv01v5xOkdmCwMWvnEyBsgYEHh1/yym+aD21ZGgYAk=;
 b=IlQ9dS2jYc/CwuJ7i/lUV+jrVqaE0xDeH7JVXRzdwEy1/0j+YuofOj/SNyd9126XmBcaqvvfcfmbAnv1z7XQSVEr1RS8s1NvZmHtREdBsp/IZHREEnhmSkas5EohSY5q8rphGM8L03YA2UH09spl5RylUvwimQaQiNNyR3eI9milPkZWrqcHvW6tT1q6n6DASVcJ4pdqD02Pxc2rpt7Qruv0SjEDVnr3Oxb9F22pul0ojVvIKc9TrrZS+60ckOlDNrmLW4D+ny138V9BtKqCWAoJt5yuQkpEqK9l/OfNxaWkT/ToKsZh3I0NI3zX1XyzBRFSedbxh1qheYsm3vdXJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:53:11 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:53:11 +0000
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
Subject: [PATCH v12 12/13] genirq/affinity: Restrict managed IRQ affinity to housekeeping CPUs
Date: Wed, 22 Apr 2026 14:52:14 -0400
Message-ID: <20260422185215.100929-13-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0018.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::11) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: ae656e7f-20ab-483f-e419-08dea0a066d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|20046099003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mHfnUze20+/VqTJnb1oCQOIeZ0dysIzs+6OWpvhubOkBKruW4u18IeoVus4/7aLAywho0dK1Gna/uB+YWZg3Ht17dZSR2M5jD5PkZ3xXHvrczGIjLtxmuOjSCgwX2zArUZHf605NbU3Iv2e0m6+krNBscw+JiIDRqdmK/9L+uRhJOmYjQmwyg/vPugVPwzts0Hwh3oN64GYftf57bs1/sxamMn2fqmR7rF0wrEIMNDRNlk6LZ744spe4dLuQVJIizMXLO6i7p6neuWU6rG97N4ZZYDyyemWtxt74akbsriRyjNVdnvUsere0UMkoywyTGZ5Q6h0SQkzqlwEMxH5r8q3cduVMo6/oky1mRPnofojP13Tc/WtsoEVZ1ZIZe/LqFqEC49Drevs7pPAL5p9REOHzgF+x7820HL5wpBSa2k8PLHkqV8TCmcdxeDS3VzrHbMfQSuRh8lQrH+8jFRLovqSSlexIt4p24G5WWknlXFBL9AjWC2C5pWajJl05T7slI5zZvkZoPmogtpRFr56x58n/TVjqwMcNsHLgCEM/UJR7Zygn5jLecKbgHabyrULqo6RNAEJ8AVN4qVoicH78N58X1mS5p2Ens94G4/H41LT1N9PuE53cmUQCifR9b6w2eNV38FlMuXDrn/ADQJNQ6JNR93L8XdW2CIfXA6yj1S4GkoeDFahM7QKrEdMrLF9zwPlqIFLfPLgGAyC7p1pVdjet2u6jYlmlsUS0ThfSejI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(20046099003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PxAAotVjt+pHfLC14S3DIt+fyFm4NUe7bbTx0vakKiFXWnxZHfuhyKAvEaKM?=
 =?us-ascii?Q?tJioSdUMOI7RRY2NwgieVjPoiMbXLp0Aeo44av9YK4WVj35z4WkWJzInHSo2?=
 =?us-ascii?Q?+8OT50Xm0zfbnVlGjZ8huoH++DXxLY6QMHnMCiFHspSptLxwklY8ms/aBWXI?=
 =?us-ascii?Q?RxDtQ0pECFSn2rLlVzavfZiqqWt130MgfZbOkkqCApd66+JjsHVb0B5o7ike?=
 =?us-ascii?Q?YYRmhrnwG+8wcZx+YdKAhZI4NbsnnBfavQp63KbJ6Qext66L/wCdMxiTm6WK?=
 =?us-ascii?Q?XelxG6VQUqYgxYSDyyshIQUge4WYnERvtzCvQy3h7t9XHWj9DoTHdpP/mZ4g?=
 =?us-ascii?Q?anQT4NWJ0W429omurn+SDPESBYuCiCaxUwnQrmpEglJGMBxzBPZ+W38MbO0r?=
 =?us-ascii?Q?w1+FIRIv2t4r6de/6QAeaOadwfBXOV5MFJ9+Bxx8+CXftk2dFWj+a7BCx9Ui?=
 =?us-ascii?Q?1YGN4Xq/LerkX27uIUB2B6ggyk0U6cZKY1nyD+FSvh80EYLy5cDC1iglQsH/?=
 =?us-ascii?Q?xPAFiAKc6ZwGtwVHKOW820eJ/eNNOYTfgSNdjVnfyUkC3HUkqfi7WqZeTX3f?=
 =?us-ascii?Q?X0Hq4jzN9DoW8cMblft8amJJnUlfrA3lf+wzgmXpCEuMI/Tlpi38nYHh6DKf?=
 =?us-ascii?Q?fXaf6wBKTYsabKIThdvu5OGB5tIdEPL+/Y43DNWr2G29dcWln34xi+Xo//AL?=
 =?us-ascii?Q?mEFFgKkCu5tJDDitD7PfmNUQcInUvzYAvjjwB0T+0j1Xj2af2mlY4v24mbsa?=
 =?us-ascii?Q?h/+YgfBjPj4ki6Pq4LndU8CXyLirGLFJgpsfWclfE34jrOeijkTFumPfPQSl?=
 =?us-ascii?Q?9JQhW4d51NkAgljB+a0/Yh83KWjj4VxWqUth6cTaHcNU18gs7xaAxzC8V/a6?=
 =?us-ascii?Q?5fEn7Eoa7Cx5q26fOrvga2U9QSY5amxh2VO+ns/43Owe/Ry1TKkJVa3JzePv?=
 =?us-ascii?Q?UhmoECctM3zHpaVRbp1bgQYfWrvQtwWHgFbPbj5m8Pzj5BK9I0umwZKbHw/+?=
 =?us-ascii?Q?vbO7VLuTT8yeW/fBQTtyRmnJUTAAnKfdpzKWI3tNwwgJ3d1GWq6Z/asJ8Iiv?=
 =?us-ascii?Q?kZaLUuXk6XtQutZecMlxjLqnQbyryVZyPj2CHp+W+budPUVn/M69MDP0YgRt?=
 =?us-ascii?Q?6O+epJymKMI7KsIFN7y//WvtgMriUz0H++Kfyb6SQzCO2EouKw51KMv690Cl?=
 =?us-ascii?Q?HeOT/aiDw8Iqx+095Uv6CmD5EussA7mDL4Wu3+9L50DYmqOUMK/aLHGBNHZ7?=
 =?us-ascii?Q?NGje/lT8RPMX5QARKmPlk0QL7pkU1LcCfZtNLZVWW98EDyOBTV1Tp/dyKWkq?=
 =?us-ascii?Q?Bv+tkZGd+09PoQqV1Le9ZI8Woecg+09ivxh9S2mKq9OJPTtDmnUkWHhQraZ8?=
 =?us-ascii?Q?gc73ebHBncNy7j4JTqw9CYYZKM/xo7VYKkQQtMocPwuRedZoBd1H/hV2HGmt?=
 =?us-ascii?Q?aFpZnpMDxlvGUhowWBDdmXw9lJUYPBdMDG5CZGFot1ERFamOqJpag/SvOnKa?=
 =?us-ascii?Q?7QrIfZTlYPRLWGtRqtV5D6zKFlR1RaRtVa5X3wz9nQmpjc++vMx+8l1qWYdK?=
 =?us-ascii?Q?s6N8KHp7uyLMorYHVGGe5K8/250xFSon+lCK60YpF4q1DuqebRYcyNtm/FRg?=
 =?us-ascii?Q?taPVCHkDKAmmJW7Rwr7cIVRptzg+d+tNjVYE9Xzrch3k4YLkWSnvx5QuuMY8?=
 =?us-ascii?Q?f7khEZT3T6bokQPjjjJB6280BZII9mdxOA2vL36NVtP6RULa4orVaum0cAZ6?=
 =?us-ascii?Q?hlvi/hBUhw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae656e7f-20ab-483f-e419-08dea0a066d3
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:53:11.6472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmx9vRDWH3aEYg2rUkcKkFNQHmzPhqVit8YJ1Vg4+i2+RvyboTITv9lTrR8h91rIRPXjywzopOdYEOkyXvOXcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

At present, the managed interrupt spreading algorithm distributes vectors
across all available CPUs within a given node or system. On systems
employing CPU isolation (e.g., "isolcpus=io_queue"), this behaviour
defeats the primary purpose of isolation by routing hardware interrupts
(such as NVMe completion queues) directly to isolated cores.

Update irq_create_affinity_masks() to respect the housekeeping CPU mask.
Introduce irq_spread_hk_filter() to intersect the natively calculated
affinity mask with the HK_TYPE_IO_QUEUE mask, thereby keeping managed
interrupts off isolated CPUs.

To ensure strict isolation whilst guaranteeing a valid routing destination:

    1.  Fallback mechanism: Should the initial spreading logic assign a
        vector exclusively to isolated CPUs (resulting in an empty
        intersection), the filter safely falls back to the system's
        online housekeeping CPUs.

    2.  Hotplug safety: The fallback utilises data_race(cpu_online_mask)
        instead of allocating a local cpumask snapshot. This circumvents
        CONFIG_CPUMASK_OFFSTACK stack bloat hazards on high-core-count
        systems. Furthermore, it prevents deadlocks with concurrent CPU
        hotplug operations (e.g., during storage driver error recovery)
        by eliminating the need to hold the CPU hotplug read lock.

    3.  Fast-path optimisation: The filtering logic is conditionally
        executed only if housekeeping is enabled, thereby ensuring zero
        overhead for standard configurations.

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 kernel/irq/affinity.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index e0cf70a99339..03e914ffd720 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -8,6 +8,24 @@
 #include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/group_cpus.h>
+#include <linux/sched/isolation.h>
+
+/**
+ * irq_spread_hk_filter - Restrict an interrupt affinity mask to housekeeping CPUs
+ * @mask:            The interrupt affinity mask to filter (in/out)
+ * @hk_mask:         The system's housekeeping CPU mask
+ *
+ * Intersects @mask with @hk_mask to keep interrupts off isolated CPUs.
+ * If this intersection is empty (meaning all targeted CPUs were isolated),
+ * it falls back to the online housekeeping CPUs to guarantee a valid
+ * routing destination.
+ */
+static void irq_spread_hk_filter(struct cpumask *mask,
+				 const struct cpumask *hk_mask)
+{
+	if (!cpumask_and(mask, mask, hk_mask))
+		cpumask_and(mask, hk_mask, data_race(cpu_online_mask));
+}
 
 static void default_calc_sets(struct irq_affinity *affd, unsigned int affvecs)
 {
@@ -27,6 +45,8 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 {
 	unsigned int affvecs, curvec, usedvecs, i;
 	struct irq_affinity_desc *masks = NULL;
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+	bool hk_enabled = housekeeping_enabled(HK_TYPE_IO_QUEUE);
 
 	/*
 	 * Determine the number of vectors which need interrupt affinities
@@ -83,8 +103,12 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 			return NULL;
 		}
 
-		for (int j = 0; j < nr_masks; j++)
+		for (int j = 0; j < nr_masks; j++) {
 			cpumask_copy(&masks[curvec + j].mask, &result[j]);
+			if (hk_enabled)
+				irq_spread_hk_filter(&masks[curvec + j].mask,
+						     hk_mask);
+		}
 		kfree(result);
 
 		curvec += nr_masks;
-- 
2.51.0

