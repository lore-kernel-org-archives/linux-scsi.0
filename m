Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021137.outbound.protection.outlook.com [52.101.95.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE8C52FE49;
	Thu, 10 Sep 2026 16:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.137
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058598; cv=fail; b=dIOX1ON/QssOEUqB45Si7hLZn3MSRLTfw1QpRuVbPCo6VT4XWwVNUtsVWeNys/VIVF6MkugSMRDzcXBQHeB8tz3QwAYodmTASmZUc/+6w4Cn1uBEyNu7UipCuOpSxHUNWfGpImNXWk9SHU0FXbmE5fcRq3T1SeSqlJsl6UwML08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058598; c=relaxed/simple;
	bh=R0Y0++b3wTryGm6qxjuA/IWlpPOKn57C38IY4CIP/5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XAKK1sc0G9GN0Ff6Uu3fwo+SuvWCSTFHhgSDDmq0UXl5c3hXtOgAG1CLwKiz5pQw7kzvaRFcBOLTacl+40jiT1VnDb7URALGpZWaJBzAoVdmgyx51g/TgrTY2BRbzaA9qqu2Nz0k8FrF9R0WS1nueqLYgnzJFZaFZ3p2CrkYf7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RJvHHvhl0rZIivGs1i5whg66JGEVAs3WCM/60m205Uw9msiJk5ie3xyNc5CaLrY+SnSTlEUB/96zfPHYm01Dzd8LyOtkKwHUkDohw8HOiDNA9zL60DFj3u37elK+XQOP21GmXHlbNxd9AtJ4LKLLNXF2m6lvh0a6NevAl3Uc8qBB7Wt+7XxttrJ4CxYesnzIG9PwGD7zDAseRVup9jWGqmV4EXh65+X5WjT54r/P07kCQKtIxP1PP4v0IIRXsC7LzDB7JC2SCsIb12DOX82+hr+GAgZt1UMniiG7YJmu+Ff+hg4q1dpz15RjlzPDJ7WUZ6tj/beXVaQaDedEp4QyxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=rGvxRhp4sPpXtArJejWdWKxHhXRJNIFARkTYh0w49Wo=;
 b=p4/eQNzvOZn3JGJUGihUK55wrBtNKR9TvnuaTOdCI/XubC83JGrGcF6T8kxgq4K5fO4d2CD8iCLnF2IZ2PW/P4SY+dKMVUfYfb9Uk2SDLWniGTj/4lya2GeL3SFFVWO7O2fvGOZ516na9RhJVb/AZ9/js7mVA0JEvpkig9vabysezHbBAg8RMFRkXquEmbQHsJCvj/+Nz+U783/Rz63alntBb5E/jku48fIAsvqHafO82QiSNFUaqxjycwtqIQuB8RpNsCL+KiiVh/XgGcamkPNa+YXH1cQTaM4Bic/imJGo7xq6mMHEQXEG0LK2HF+oReVNo4itQXR/YeU0FER/3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by CWLP123MB4179.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 16:43:12 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 16:43:12 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk,
	tglx@kernel.org,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	frederic@kernel.org,
	bigeasy@linutronix.de
Cc: atomlin@atomlin.com,
	ionut.nechita@windriver.com,
	corbet@lwn.net,
	vincent.guittot@linaro.org,
	mingo@redhat.com,
	peterz@infradead.org,
	radu@rendec.net,
	akpm@linux-foundation.org,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	nick.lange@gmail.com,
	marco.crivellari@suse.com,
	rishil1999@outlook.com,
	linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v16 6/9] blk-mq: use hk cpus only when isolcpus=managed_irq_strict is enabled
Date: Thu, 10 Sep 2026 12:42:34 -0400
Message-ID: <20260910164237.500196-7-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910164237.500196-1-atomlin@atomlin.com>
References: <20260910164237.500196-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0500.namprd03.prod.outlook.com
 (2603:10b6:408:130::25) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|CWLP123MB4179:EE_
X-MS-Office365-Filtering-Correlation-Id: c1ec5574-8408-4108-a6ee-08df0f5a9a52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|10067099003|56012099006|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KtjGCWBz7GGTBBj1v4emeJBJV+FJbEdBjQjq3IYPbDlhThBMQ4ovIQcQ+WPp2ITTyVlzINjDrZ3DucyiYxj/wkXgbG0p5Xc1MXTG1QwNxurS7+SZWdvsjNIHkWKyfzU1Fs7TuSE1jJAqQNiK9CGOODIppa0UxJN1pj0pcc+RaP/lwMX7qSXFLuX9p2ONNL0zMmctulpyh69prXaEYQ/aBKAXtBF9m9DnmMts1Qov4BEfC5UXlpVC0jCzhlFbGGZBpA4JAnzwd4esJOPcldOrhaBXRVjbr9Q1Ul1d3ZpMlq16x5u5hmXDoLsZddx+P5Ury0XhsZuNxRTENVzMfMcZMUOJiSsp3Dc0Km4r1sTNqTdnc/uzJtbt0fYXYg6JLbjsxHU4BSOo5ZzQNx1lcedLqoXTwzMfJcuIMGvfiqcQ3toMEKt7JXhHLE6F5/gP9HpbT26/NRfsVsBbO7Qdw1LoXVkOvfNfwUycTAxwrTOoMkxKP3Az2+m/p9ksxHtgxhKjBlwl2+VxztXZRl6NStEXhMWFX1RyuL6VG2a5PF9MYL9MipCMnRcENt2YGvpNRtLzXaLdYsmO6+GK4uRrxBqrRlR/8iuuSc3ZEMoW4lCWw98ZkCmsMmJrB4J4gaTMEIKBjUJa6Wsi31+htQYNWC++zBWxc0661znw7WoIWP5lW2Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(10067099003)(56012099006)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nKVgXOwZptIlkWePumq9eMdHnOPbEctE8MlNBw9At3zqqYhuroVzWk/YkLGi?=
 =?us-ascii?Q?Ee45Uy7zP6OiNFgcsyPrQ2N+gO79o6OTPfsTfaSjpIaDhgKOgGPw9qmnqWfZ?=
 =?us-ascii?Q?WUp4wYeoKsnQt/6P0Oa/X3JoPaOkZXFkQUrLUiNAk15J13ZBX3dlYlNeCZhO?=
 =?us-ascii?Q?V7FIApic/sGR9Ao8CrE6JlTAVOQiVKzrYnHSNvEFY+P/WKgvlVxzem5P/F2w?=
 =?us-ascii?Q?D36QgfbaAWBwQt7YhyLPMI3yzJM2dFADjB1PlPVt8wnaylFf4fA6cBkvR28K?=
 =?us-ascii?Q?wnpQ/js8iGv7ODyNmA8pcbvFkogWsd6ZWjKDVIu0wdCKoV+rrscZfKdC+2AZ?=
 =?us-ascii?Q?BJEHE0cDPEmHIv9JYyuqO2dGigrXrSdd9v+8tue2kc/+kYTmP4C3Z/ycv3kO?=
 =?us-ascii?Q?F11zSJzGIRFuTG+zhGBiZNHvrBo6Szz8+givXTDTUxNZ2LhGhB6buJfD1mBu?=
 =?us-ascii?Q?fKuIqhIoyu6ZIw81nN6vkGiNjTzJkfoTRpA/oyCpXRcwIfkro3JcYV5MkZxG?=
 =?us-ascii?Q?7O9oZNfMtaxqm/sz7uytM1rdqXcFNns0t3gElGu8HgEUP4L6xHgsjSqoFH69?=
 =?us-ascii?Q?4ujt5jgFQl0KCknTGJXR60MmkeVBhPSmyzuMCax6Fr5jrfwQHp7l0jblkukS?=
 =?us-ascii?Q?8D5eDQEtY/wnSoe/JdojPNSyO+blVbF6Ef3g9HOLH/wBMj3GB1KOe8T7TX56?=
 =?us-ascii?Q?rJ1vvHk6Qjl82QhekKSRm0e6llcPxpR3298Mc+hVeOibdNIlP0+k1uexltPS?=
 =?us-ascii?Q?PC1tMlulgIFRQguqP4tdVHuDWpgVQPjQ0S05jYiwWkaL1DPORlWnDE2HQMFV?=
 =?us-ascii?Q?ujwLlPIIkMErTB70/sF/TpV7XMD2nLziSDsLnSRgG3VREAzSD74p2uaTzCfm?=
 =?us-ascii?Q?j5Ph9MWgaQcIQPpSJqktGIbpqeZt2Jo0aVjpjld5k9hQoYqZZdmJrrCBA+z0?=
 =?us-ascii?Q?NsnqCGxByGBDnlTKyNcDSr3cXP5/IYsYwqTzhBLtq5g0s81UsV/mpHQZ7N6d?=
 =?us-ascii?Q?vSb1/hQvYlHfm8pjg1EPdHxOyLpf+6RbY5NrpoW8zwI0DqrJR8LF9XWWvulA?=
 =?us-ascii?Q?a+hM9l4r+/asfwOcZZQ3A775O3G1X5H5aXJt/zownbr0QrWuZv7+mhbaVVzy?=
 =?us-ascii?Q?mdF8Xtf9uH7q9CSA2rSjX0QvUoJvOd+OvthUHZRQH/uad4VZ4D760ZL4gyw9?=
 =?us-ascii?Q?AWYvdmNkztuaZVe6kqk2OiXc64e7dmHgLaXmTLb8K0aYHu7VTU3pL1ARFdgn?=
 =?us-ascii?Q?Cupa1G7MPc7KHDhCb8Mp78lXLmhN/9UCs3sQcq27wTnH7OJOl9Gh+5pY9ZrD?=
 =?us-ascii?Q?EGJsevHI8t0bI1KvO/sg7IBvBvuv4YE2j6j2g3P7bumMET2hhcbhFCEh7vhO?=
 =?us-ascii?Q?o+SiaxueNoH5Myscs7G2AmxrZIKqhlWT6ut7OyYEMZBfhUMoXFFipEcLeNNs?=
 =?us-ascii?Q?vrrc3L99j5rKRjMabJZcsxuObD2jQY27HTSByIQBVgt9pJS+6cpJyhPnMLqC?=
 =?us-ascii?Q?HTi5S+krh2K86wpWKJS7qvwfeyb/tWMgGKjvTWFkupetY+6A0WBiQZumd/DW?=
 =?us-ascii?Q?NBQG/Eh3I5m9JedOpQ1r1VNmgiaADBZLV6zUq7luz0dT4CGwIgBNjhygw+6J?=
 =?us-ascii?Q?FCzBt8t6FsYmtTAbt+HRztKdLjASUBUu7yH/5A97G+GaWYEgxK+mA+9vS2lW?=
 =?us-ascii?Q?hVogjBEe/pnxtgw4JM1FjrKBRDc2ermhPkoFVrnaEJ+0wzU4OkAUTLqoxXZO?=
 =?us-ascii?Q?3jkOIEQJpA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ec5574-8408-4108-a6ee-08df0f5a9a52
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 16:43:12.2828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jT+FUh3CJqI8JbWScaEYZK4i4QxcEyzZuE4Q12VUeG92Lt87+E+21907NrBmmHT5RC2SC68yMwoYVOyCGX2OCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB4179

From: Daniel Wagner <wagi@kernel.org>

Extend the capabilities of the generic CPU to hardware queue (hctx)
mapping code, so it maps housekeeping CPUs and isolated CPUs to the
hardware queues evenly.

Example mapping result:

    16 online CPUs

    isolcpus=managed_irq_strict,2-3,6-7,12-13

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

In this scenario, the system has 16 online CPUs with 6 isolated cores
(2, 3, 6, 7, 12, and 13) and 10 housekeeping cores (0, 1, 4, 5, 8, 9,
10, 11, 14, and 15):

    1.  Queue allocation and ownership

        Rather than allocating 16 hardware queues, the block layer
        allocates only 10 hardware contexts (hctx0 to hctx9),
        corresponding strictly to the 10 housekeeping CPUs. The 6
        isolated CPUs do not own dedicated hardware queues; instead,
        they are mapped across the existing active housekeeping queues
        (e.g. isolated CPU 2 shares hctx0 with CPU 0). This ensures
        tasks running on isolated CPUs can still issue I/O without
        restriction.

    2.  Interrupt routing

        All device interrupts, including the NVMe admin queue (irq 42)
        and the 10 I/O completion queues (irq 43 to 52), target
        housekeeping CPUs exclusively. When a task on isolated CPU 2
        issues I/O via hctx0, the resulting completion interrupt (irq
        43) fires on housekeeping CPU 0. Consequently, isolated CPUs are
        never interrupted by device hardware, guaranteeing zero latency
        disturbance for isolated workloads.

A corner case is when the number of online CPUs and present CPUs
differ and the driver asks for less queues than online CPUs, e.g.

    8 online CPUs, 16 possible CPUs

    isolcpus=managed_irq_strict,2-3,6-7,12-13
    virtio_blk.num_request_queues=2

        Queue mapping:
                hctx0: default 0 1 2 3 4 5 6 7 8 12 13
                hctx1: default 9 10 11 14 15

        IRQ mapping
                irq 27 affinity 0 effective 0 virtio0-config
                irq 28 affinity 0-1,4-5,8 effective 5 virtio0-req.0
                irq 29 affinity 9-11,14-15 effective 0 virtio0-req.1

This corner case demonstrates behaviour when hardware queue counts are
constrained (only 2 request queues) on a system with CPU hotplug (8
CPUs online out of 16 possible):

    1.  Coarse queue grouping

        Because the driver requests only 2 queues, the 10 possible
        housekeeping CPUs are partitioned into two groups: hctx0
        receives CPUs 0-1, 4-5, and 8, while hctx1 receives CPUs 9-11
        and 14-15. All isolated CPUs (both online cores 2-3, 6-7 and
        offline cores 12-13) are mapped to hctx0 to share submission
        capacity without allocating excess queues.

    2.  Isolation and hotplug protection in interrupt affinity

        Although hctx0 serves both housekeeping and isolated CPUs, the
        resulting interrupt affinity mask for irq 28 (affinity
        0-1,4-5,8) strictly includes only the housekeeping cores,
        completely excluding isolated cores 2-3, 6-7, and 12-13.
        Furthermore, for hctx1 (irq 29), whose assigned housekeeping
        CPUs (9-11, 14-15) are currently offline, the kernel routes the
        effective interrupt to an available online housekeeping core
        (CPU 0), guaranteeing that interrupts never spill onto isolated
        cores under any hotplug state.

Noteworthy is that for the normal/default configuration (without
isolcpus=) the mapping will change for systems which have non
hyperthreading CPUs. The main assignment loop will completely rely that
group_mask_cpus_evenly to do the right thing. The old code would
distribute the CPUs linearly over the hardware context:

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
Co-developed-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 block/blk-mq-cpumap.c | 163 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 145 insertions(+), 18 deletions(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 705da074ad6c..cec5b26bd57c 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -22,8 +22,15 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
 {
 	unsigned int num;
 
-	num = cpumask_weight(mask);
-	return min_not_zero(num, max_queues);
+	if (housekeeping_enabled(HK_TYPE_MANAGED_IRQ_STRICT))
+		num = cpumask_weight_and(mask, housekeeping_cpumask(HK_TYPE_MANAGED_IRQ_STRICT));
+	else
+		num = cpumask_weight(mask);
+	/*
+	 * Ensure that a count of zero does not inadvertently result in
+	 * allocating the maximum number of queues.
+	 */
+	return min_not_zero(num ?: 1U, max_queues);
 }
 
 /**
@@ -33,7 +40,8 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
  *		ignored.
  *
  * Calculates the number of queues to be used for a multiqueue
- * device based on the number of possible CPUs.
+ * device based on the number of possible CPUs. This helper
+ * takes isolcpus settings into account.
  */
 unsigned int blk_mq_num_possible_queues(unsigned int max_queues)
 {
@@ -48,7 +56,8 @@ EXPORT_SYMBOL_GPL(blk_mq_num_possible_queues);
  *		ignored.
  *
  * Calculates the number of queues to be used for a multiqueue
- * device based on the number of online CPUs.
+ * device based on the number of online CPUs. This helper
+ * takes isolcpus settings into account.
  */
 unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 {
@@ -56,23 +65,81 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 }
 EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
 
+static void blk_mq_map_fallback(struct blk_mq_queue_map *qmap)
+{
+	unsigned int cpu;
+
+	/*
+	 * Map all CPUs to the first hctx of this specific map, respecting
+	 * the map's boundaries so secondary maps do not route into the default map.
+	 */
+	for_each_possible_cpu(cpu)
+		qmap->mq_map[cpu] = qmap->queue_offset;
+}
+
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
 {
-	const struct cpumask *masks;
+	struct cpumask *masks;
+	const struct cpumask *constraint;
 	unsigned int queue, cpu, nr_masks;
+	unsigned long *active_hctx;
 
-	masks = group_cpus_evenly(qmap->nr_queues, &nr_masks);
-	if (!masks) {
-		for_each_possible_cpu(cpu)
-			qmap->mq_map[cpu] = qmap->queue_offset;
-		return;
-	}
+	active_hctx = bitmap_zalloc(qmap->nr_queues, GFP_KERNEL);
+	if (!active_hctx)
+		goto fallback;
 
-	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		for_each_cpu(cpu, &masks[queue % nr_masks])
+	if (housekeeping_enabled(HK_TYPE_MANAGED_IRQ_STRICT))
+		constraint = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ_STRICT);
+	else
+		constraint = cpu_possible_mask;
+
+	/* Map CPUs to the hardware contexts (hctx) */
+	masks = group_mask_cpus_evenly(qmap->nr_queues, constraint, &nr_masks);
+	if (!masks)
+		goto free_fallback_hctx;
+
+	/*
+	 * Iterate directly over the generated CPU masks.
+	 * Calculate the final, highest hardware queue index that maps to this
+	 * mask. This skips all intermediate overwrites and safely evaluates
+	 * active_hctx only for queues that survive the mapping.
+	 */
+	for (unsigned int idx = 0; idx < nr_masks; idx++) {
+		queue = qmap->nr_queues - 1 -
+			((qmap->nr_queues - 1 - idx) % nr_masks);
+
+		for_each_cpu(cpu, &masks[idx])
 			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+
+		__set_bit(queue, active_hctx);
+	}
+
+	/*
+	 * If the active_hctx bitmap is empty, attempting to route unassigned
+	 * CPUs will map them out-of-bounds. Fall back instead.
+	 */
+	if (bitmap_empty(active_hctx, qmap->nr_queues))
+		goto free_fallback;
+
+	/* Map any unassigned CPU evenly to the hardware contexts (hctx) */
+	queue = find_first_bit(active_hctx, qmap->nr_queues);
+	for_each_cpu_andnot(cpu, cpu_possible_mask, constraint) {
+		qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		queue = find_next_bit_wrap(active_hctx, qmap->nr_queues, queue + 1);
 	}
+
+	kfree(masks);
+	bitmap_free(active_hctx);
+
+	return;
+
+free_fallback:
 	kfree(masks);
+free_fallback_hctx:
+	bitmap_free(active_hctx);
+
+fallback:
+	blk_mq_map_fallback(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_map_queues);
 
@@ -109,24 +176,84 @@ void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
 			  struct device *dev, unsigned int offset)
 
 {
-	const struct cpumask *mask;
+	cpumask_var_t mask;
+	const struct cpumask *constraint;
+	unsigned long *active_hctx;
 	unsigned int queue, cpu;
 
 	if (!dev->bus->irq_get_affinity)
+		goto map_software;
+
+	active_hctx = bitmap_zalloc(qmap->nr_queues, GFP_KERNEL);
+	if (!active_hctx)
 		goto fallback;
 
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
+		bitmap_free(active_hctx);
+		goto fallback;
+	}
+
+	if (housekeeping_enabled(HK_TYPE_MANAGED_IRQ_STRICT))
+		constraint = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ_STRICT);
+	else
+		constraint = cpu_possible_mask;
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
+			goto free_map_software;
 
-		for_each_cpu(cpu, mask)
+		for_each_cpu(cpu, affinity_mask) {
 			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+			cpumask_set_cpu(cpu, mask);
+		}
 	}
 
+	/*
+	 * Evaluate active_hctx after mapping to handle overlapping masks.
+	 * This ensures queues that were overwritten do not falsely pass validation.
+	 */
+	for_each_cpu(cpu, mask) {
+		if (cpumask_test_cpu(cpu, constraint)) {
+			queue = qmap->mq_map[cpu] - qmap->queue_offset;
+			__set_bit(queue, active_hctx);
+		}
+	}
+
+	/*
+	 * If no assigned CPU matches the constraint, the active_hctx
+	 * bitmap will be empty. Fall back instead of routing out of bounds.
+	 */
+	if (bitmap_empty(active_hctx, qmap->nr_queues))
+		goto free_fallback;
+
+	/* Map any unassigned CPU evenly to the hardware contexts (hctx) */
+	queue = find_first_bit(active_hctx, qmap->nr_queues);
+	for_each_cpu_andnot(cpu, cpu_possible_mask, mask) {
+		qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		queue = find_next_bit_wrap(active_hctx, qmap->nr_queues, queue + 1);
+	}
+
+	bitmap_free(active_hctx);
+	free_cpumask_var(mask);
+
 	return;
 
+free_fallback:
+	bitmap_free(active_hctx);
+	free_cpumask_var(mask);
+
 fallback:
+	blk_mq_map_fallback(qmap);
+	return;
+
+free_map_software:
+	free_cpumask_var(mask);
+	bitmap_free(active_hctx);
+map_software:
 	blk_mq_map_queues(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_map_hw_queues);
-- 
2.55.0

