Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020116.outbound.protection.outlook.com [52.101.196.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAD3317145;
	Wed, 22 Apr 2026 18:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883987; cv=fail; b=tRs7fg/Ouu9j/4hYDQqAmDDUIHcYnGw0R68fFZOZXU4MJwlTYNqRUq5yliNYUvBZWaT+zSt/Z7WY7ibilcCE/pMAIJ1RrrRItcvhRhyoYF/zGJ9WFCdWaUh4/xbHJF5pBRGT6d3Ff3/cMLnGFXKD7VkMF+fo/jbDOavGh3xlEMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883987; c=relaxed/simple;
	bh=BbcA0NMwKLLRwpfrWSfbTBNx4JJZLTZIW2PVdByU5uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=crKDJ0LdK5L0X8YYMC6P4JGu+Ub/HSqlm1Ks5YeB+8ano+d8E4tSmhIkILOpVqrkf4xO+D9Myev4q3rVyMnshTjEoXwE4lt0s6dI5pBpgvK7vHjzxl18m2aTi6nHMD+h/6RHzXhhKehzy0v7/3PqE3NUYn9vk066tAkxnzju5KY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A8N5y8qH19hquLmLbzt+fY13LDVOw6RfUNVbvTDO3vfBhsGlr96uTb/V2IdpZzB9okUlM0ZLjfFr9SH9IAt04XLZYQ0JQ/A+Ebp8ckoXZF31qE5PxXwJeMHQ/B16LrmCcCxzVs0qcIpRanCI/1x8oHmRmt4EYSHv7QbDWnEqTcpsjfNITpKu1G7tsviQgLrzdR70Q9Z5mBxZEKl1Ylmgl5UEomHslURgW1CiYWvn3npniwnLnX87xZKEzC2YhDdEGu+VvbFSEXrcilqNjAM5lhBLq5/T69QPbvlEBpkM+20GICIWuBnue7eO7nwmHljqdfrtTsKdGi56d9wZm/hpXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VEbXocv90EEQQkMDABahd6vYZwcvOoK0laAAb5WiV4I=;
 b=ke+GeKU94STfTrHa2WET3rGPycX232YfsKJAG6neBMPY4SNzBF8UYshdEZJJmtzLWlfQvvI/vnU9133ILAdnC4PcDZBS/bOvpP9vlrKiHib3W+7N20cH6i+dz1bpcPwmSI+15h0fn9cZbbafiptrDCKWIVjQrv0hQonyUaf1jj034mGIFwmvxDS88NGyoc8gQj1t23N6x4Ltaj29GejS0IjTaY5pAFrk0LV8spdck9D9OvbEQD365bO5dhkt+u6i/QerkIgCdSXFxzjv+5V3VhPiaacxlH/1HA9dqlL8b7pHaOZfbyWZH8HIPrIl2X8GNNL1C67jAL8xE562Vkas5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:53:03 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:53:03 +0000
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
Subject: [PATCH v12 10/13] blk-mq: use hk cpus only when isolcpus=io_queue is enabled
Date: Wed, 22 Apr 2026 14:52:12 -0400
Message-ID: <20260422185215.100929-11-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO0P123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::20) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 687608c2-8a6c-4160-ed24-08dea0a061b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mie5G+6ZqRAJ4o5BdwEjqJV6XcoZFmwjG3QMVE7yNTn23bmDUvo/JyS6cT1Lbz+r83esREXpagEm8bKsQwUzTmTosask8Wema09uKy6Iz980+uAAHZdo2lWLjifecFqgW5T2NlFKHMunQecs07LpHdchrDjKAJTHbumY2qMxZj4E89h4YNFHJ7AkILlKEENJVI1a/0miQu6QbxnyLFxUK5dgbd8ND4EXOcOPUdtK5KntGUAmoARXWuO2xibCEV9gOIseI/uq09ZmYoDRD2/7/Z887jYo1eKVR6BnzZ5d8+QbdRTVPhvOKcpY3YfJ09nnLqa0GfZWlTAqwhW0MrHRYKRgzq9n3LTAVE6YqLb27fzb/h+gC3sLV6fCx3b4/qvo50zk97dSgepKnRjFNghIqy/GNtCVtSAaZElV7RCakDn+GyVYXf64aSeZ0uopWuShR/3CFfFNV8lOwjU06CICS1SGjdl30qowq3jOM0D0S5AdOdysJYlvNBhfwmdNt0qfu3gA6gKN5Jx+Pgv+Iw3qtG7oxCqrQ8hhKfRS6GBOmqyVIwfZkvOFsgFyk9ibWoXnWd3mqvvHBMmfeKBj+WoNyox9JM3x6OKVCgtpCqpfLxXxsn0OqKsrSrAC69vGOLw4G5IybNHLzfoN7rh545XzzlgBqgnM71o4z1BBnSrwn1YxphatVDwFbXyFzNWg+ZqthONDTaiAhjN569J+cQoFyyL8T8tjMqghzyl4aN2GmRk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DkTU/PLoiDTIuOL9kgI47+tCrHHXTSaJGjtnb4gPBvY/JyGAjBQRf4xZdXek?=
 =?us-ascii?Q?paUwjVhKAgcyzYHF07difn+IbKJdWZxMZvmbbrcicrRHbVIsSBTocy9A83gv?=
 =?us-ascii?Q?5Av3wlGZnXlgA3hS8hLEftLVLTOYVB6aDvPLNqnMS29QgUtYybgv1ISFMw0M?=
 =?us-ascii?Q?xvqsaajRgENcrbSGjKfaV26/XORxY57O95Wgoghj82Jtg1WMzCWNqXuSyWkK?=
 =?us-ascii?Q?ga7ZP1sncJ+YYbqhluwehUYZGyNiA4Jp82M2X6wPGty2SgSuo1szUiH6k5GS?=
 =?us-ascii?Q?iFJOZ1skLQscXQ/8mapefLoZJGcNQG12XxiZbD5gJs1cHJDFAiFwYpOE59Ge?=
 =?us-ascii?Q?D1UVoz7j63FocA7IX5YiJ4CDoccu/h1REZn2RqJvuctLNOPFgAqI2CJzmZxA?=
 =?us-ascii?Q?6pi4MKPalxR026UUM70iA4TV6cV/GrgsqlJ4pd8PId26M1VztiIMzCSaoGap?=
 =?us-ascii?Q?e2QcW2aroWhjUbv3gTM3iMpGTjKjxYxZ2RBzL8FAgOA5WCkEB8aHXoEzDuv3?=
 =?us-ascii?Q?G6eFmjYhWBSu2ca9qG+ke804zzQwS4+xrpNb4cGO9rP1iYzgWce5mPHgJUjd?=
 =?us-ascii?Q?VVBElKiyzcXpjZuLRTATh5V1kPt5ipUUnQW5KdDdfrXU/oHpsEV3m2q8Uf7D?=
 =?us-ascii?Q?Q2aBez+9HVofckyZZC449YGHckJRRzmS2u+Py/gKK3HvFiSFGGm/rmqElzUy?=
 =?us-ascii?Q?nShRtThNwQUqFvC5ZnOo56ikdDfE6AnWOXIi/wUn8gtaicr4vn2hxvQ0pabZ?=
 =?us-ascii?Q?RGnCANfIcA7M8JFF0xAKwyNErulRkU03gnmSjNKxS9LyrXnOfrZS2FzNMWh+?=
 =?us-ascii?Q?ybezgffXoa1BCLnKW7WVR87RdkFKi2ihtGhD3RYaFqLtmufkP3/NdqqmaxPT?=
 =?us-ascii?Q?3sh9OzSayV3UtznwfC3B2OgGwTxMJIlrGHdGN0pd46L4YEq3ihbs9hvtu//V?=
 =?us-ascii?Q?CCEAStKlMms/CP75g5bPhG+Wo0w1/p4uDi08Abybt8SvWA6OSWzxZXOMb+0r?=
 =?us-ascii?Q?MEAjY2wqJ6dYloyMNZZcSJnsKAcA5z4uA9LNBuTP4eXmqy/5vhpf9X7jy7vx?=
 =?us-ascii?Q?O5TWmDnONKQ4dyyDyMjDfPd7oOhfiXJ6VLfY+pNppJUfWeBIPLe435XbUpIL?=
 =?us-ascii?Q?1BmmpW1u6rwR+TTAquFdMiPAHuuCj9yRD3syH/58bVo5/rM0kCYAiPYYnwzN?=
 =?us-ascii?Q?YE6CaP/QXdHty4oF8R02yCYFn/st1iYHaXC5Fj1sYqYhfXexM5XMKTW2uFd/?=
 =?us-ascii?Q?N5bBJuAn+dB06TD7fOJeS1KzdMNyMeFf9Q/aWSAS+Qjz7hi3Ik/qlEnwqO8E?=
 =?us-ascii?Q?K8EWxi6PfwaKreGqchShQrdX47x5Cpyzp8/HQVTGWKggu157v2QeEWu2xNpO?=
 =?us-ascii?Q?uBxXSoEafMlzd2dvtKOPx7U0fp0NxZRyqiBexpUNyeH/qiQsg8NAQ4E7OqBy?=
 =?us-ascii?Q?Tjn93WLp4jBUQTZITE3m3Wo22ec2OjAjE5WnM3ya164klIy+RvNEKxDIgCaF?=
 =?us-ascii?Q?onXeDWNSs4T+efbO8v1/SI7Xeuw/owQjL3rK2sx0F+wxVkQWT+as4ZXzx8k7?=
 =?us-ascii?Q?m1D2RvGFKT7gRAQlEcVbftpCXSWEYDMYADL23J/ypeKqCLGEbe0O/Hu1WhE1?=
 =?us-ascii?Q?HOcNQg7GZRt4Dmfn5XzGttxPHEqOR5qlDGKzPB2zKi5a+v6ICJ71uxgjDreY?=
 =?us-ascii?Q?slbkf/aLZbw7cZq7m5sWZn+zZ5CMHwuu1lbQF9HkNpliTgs16X7kMjrLumKN?=
 =?us-ascii?Q?fPvJT3ZkVQ=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 687608c2-8a6c-4160-ed24-08dea0a061b3
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:53:02.9592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7A513P7GJaH+RArYcLSUB3sKiRCKrKbHxMJ/cSH9AsAcid4xFS77XQWqnJkOzX3tbFg8LHpKpA4VVsPWPgpluQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

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
[atomlin:
    - Fixed absolute vs. relative hardware queue index mix-up in
      blk_mq_map_queues and validation checks; fixed typographical
      errors
    - Reduced stack frame size of blk_mq_num_queues()]
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 block/blk-mq-cpumap.c | 168 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 150 insertions(+), 18 deletions(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 8244ecf87835..f7c5f52f3b35 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -22,7 +22,11 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
 {
 	unsigned int num;
 
-	num = cpumask_weight(mask);
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		num = cpumask_weight_and(mask, housekeeping_cpumask(HK_TYPE_IO_QUEUE));
+	else
+		num = cpumask_weight(mask);
+
 	return min_not_zero(num, max_queues);
 }
 
@@ -31,9 +35,13 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
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
@@ -46,6 +54,14 @@ EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
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
@@ -57,7 +73,8 @@ EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
  *		ignored.
  *
  * Calculates the number of queues to be used for a multiqueue
- * device based on the number of possible CPUs.
+ * device based on the number of possible CPUs. This helper
+ * takes isolcpus settings into account.
  */
 unsigned int blk_mq_num_possible_queues(unsigned int max_queues)
 {
@@ -72,7 +89,8 @@ EXPORT_SYMBOL_GPL(blk_mq_num_possible_queues);
  *		ignored.
  *
  * Calculates the number of queues to be used for a multiqueue
- * device based on the number of online CPUs.
+ * device based on the number of online CPUs. This helper
+ * takes isolcpus settings into account.
  */
 unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 {
@@ -80,23 +98,104 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
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
+			 * This hctx has at least one online CPU thus it
+			 * is able to serve any assigned isolated CPU.
+			 */
+			continue;
+		}
+
+		/*
+		 * There is no housekeeping online CPU for this hctx, all
+		 * good as long as all non-housekeeping CPUs are also
+		 * offline.
+		 */
+		for_each_online_cpu(cpu) {
+			if (qmap->mq_map[cpu] != qmap->queue_offset + queue)
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
+		unsigned int idx = (qmap->queue_offset + queue) % nr_masks;
+
+		for_each_cpu(cpu, &masks[idx]) {
 			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+
+			if (cpu_online(cpu))
+				cpumask_set_cpu(queue, active_hctx);
+		}
 	}
-	kfree(masks);
+
+	/* Map any unassigned CPU evenly to the hardware contexts (hctx) */
+	queue = cpumask_first(active_hctx);
+	for_each_cpu_andnot(cpu, cpu_possible_mask, constraint) {
+		qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		queue = cpumask_next_wrap(queue, active_hctx);
+	}
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
 
@@ -133,24 +232,57 @@ void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
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
 
-		for_each_cpu(cpu, mask)
+		affinity_mask = dev->bus->irq_get_affinity(dev, offset + queue);
+		if (!affinity_mask)
+			goto free_fallback;
+
+		for_each_cpu(cpu, affinity_mask) {
 			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+
+			cpumask_set_cpu(cpu, mask);
+			if (cpu_online(cpu))
+				cpumask_set_cpu(queue, active_hctx);
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

