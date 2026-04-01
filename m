Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020088.outbound.protection.outlook.com [52.101.196.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9193B47F1;
	Wed,  1 Apr 2026 22:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082251; cv=fail; b=oxG4Uu2wwkVPPt5PR7zR+zz+kT62g6SkgmlKI/3qkEy45zcZApkRUt5Ppe4TXlxUay9xQBw1HXEz7ILF2F0uUvOwX/GI+dOA3yzm49/luiQLB7LcWktTMfkbvVh+ASVFNNCU+RD/IbI5/CGuYXE5MpfsDpeYcBfkhAuKA3dq8a4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082251; c=relaxed/simple;
	bh=ItPOcxRhjtgzEQQIDQzwKXHR2yp4LC3hEx+6HiKyiDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tKe6Btl8I8iGYPvQdlMuuruE0mbc9hv/sqkmQ66rvukMNrN4DqKzcxMSHgioAbmUWwiJcZ5e51zI5MUqPA/eWjU0fWcNsf+h69XNazLSW+5QgURgJmxgbfxNwJ2t9CZgqQMiNRJS88QFzzpFCubC0WXkUY2HXmSLKMTA9WxhPmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jWnHB7gnKu3AYhWfALPKuK//aH1LQYDAUjDefgzK5ZSE/M/k6Yb4CK4WW4VQll35wp+DnJz1n2PDPQ+mbZm0m8+/d84/wJMqyGF6ISyCRad0xfmlP53OWX+N3GuAX1OLLBv1F3Vb+YslUm6ezhn75HsrXURWfo9j2b2bi98qSfbgpS1mi6t2iRs33nOOZbJ8PHzIuOYJKeXH0CejP82RHpe598wKRAXQ0xtavUFD967B0mH0isBO19xXiGEaSpMCJ4YrNMqKXDyw5ztdz1eJPpuK5r77bc8xFYc1r8e+GxLoLVRE/25mf+rOS/aE+6jsQnqg8Yugmx38XKHYW/wHxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8o5u8GwmIkzAtIXbkx6IlboXM/3nq8c5AgRY7dsuNXo=;
 b=TPYaTStt75CxcKke+YsfLnWAO/un5R+p4TsNpetk5EZL78dy2H9VV/tZiRRCtguDDkPTRyuXsURdDvYi/+StC+c7rB4bdnQPSxFP2ZJ9b7D0YK9ZWvQv4xS38orusNkD7ISPIeX3++XOw8m032V4YiC7EoLKDJosnntCTBAC29nXqoJ9Jj84SQrotF++qVDC6YtnTA+24x/Bsk7d5vH9KnouBZQWViUX4I1AiKTzDfDV/CxQv21e9Q5DSV55xtEudb4yXGx1X7ry8PKhccyCfLMARUpf5srfAYHf6fiVAa9OAF/+aBfkYSvFwW5Y+aK7FlbDQ7XSyg8uUAG0Mer/BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CW1P123MB7844.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 22:23:36 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:23:36 +0000
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
Subject: [PATCH v10 06/13] nvme-pci: use block layer helpers to constrain queue affinity
Date: Wed,  1 Apr 2026 18:23:05 -0400
Message-ID: <20260401222312.772334-7-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260401222312.772334-1-atomlin@atomlin.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0039.namprd04.prod.outlook.com
 (2603:10b6:408:e8::14) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CW1P123MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: 8625bf30-bbb8-43bb-cc4c-08de903d513b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qjNxuUOOeAmflJmbaD1d+gtt1kt+djMv43iww613hKQyE/ot0E7ccdMiqUt8Qp3zh0DPcJuDDeH55vB7tG+YF5BsuWUjMsvkJMf7G+UYA9IvipijtSictCgsvZIL+fUMKdQKck3/ZYS/tLlJZqcLdBGQhpObp0NJqTTP8C86qxi4A4e+LmHe9adyT7TwGTW0Y2jFe+paLLunaTHnSusI6KNSXSTSSIMHtU3EkNHdrhvqCawd1YEKaWHd6KUwvtEweK4FVyZgb584l/XBIcX5SJAcXFCM0x5Y16SpPuAGXGfNPSopdCBmxQKhZr1A4SVu+ThDdEBlwO3X2Rap7x1bCnt2xNjXkknYrIjBOn6hHPYyktkooUQR52akbuulNqODWOU8rsSC1u4eEuBZh7NFwIjm/UJZ6Xsa2KO2bUBk7yQULM83K2Itu26tDJkGWLhhlIrhkojmC0VG1c83kpoE6twCh+nPp6gT9lm5L84K/9k9Bv1EY/Zyt7HzTjNyEHiNJdPi9PFh8FIOf8cGtSZ7cAJ08FhsnBwkfJOKm6yNNKP4HPU7TUMK7KCLi3S9Nd/QlkMX1sh4wkq9RQzaNHqa/rrEQYmcVN9b+MXiz/HKEUtegRRIW/qoJgt89tSImz6NCkO9MUk2pcGoK1xgiDKfilQOTCFpTDKqYGd7OSg1GxH54Hu0LAjebkkTTJd1ZiKN3dDqo6j1YKQPTzeU0zoc7VZ8s4+L7K0Rrxa0J/HBAVY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T6txXDDvauqFgThG81AEmhqOGL6cCL8vMII3z00pqmToN0aZnGsZyA0SN7A0?=
 =?us-ascii?Q?m9cz77jYtKqqbGEmV/ahQKOVNvg94jRPxkNa3lD3H6hD5EHLNqZ+Xc4UK3R7?=
 =?us-ascii?Q?lMxVLEUTHkXrRgY7+UHOUE0fWP/wbgia5ZYG+fjgq4h4vX9hEYUGwOCbS1uG?=
 =?us-ascii?Q?M/z8RXDgZ5nAgaIO01J4u7Ftd0/fgUrgaBbIFbb2hrF4pWtyzIFAjpkWnN0d?=
 =?us-ascii?Q?K0Q6BpLGfQNiPvEjx/Sb1FHAQ10YNXbtdPv7yOqDKZRRt/Vcwaw5mGy8Ku0I?=
 =?us-ascii?Q?XpmsFuBVqTlQ0jO56UB9u/RmICxiJUvyx4Nu52Hnl+DU6ROHM+XNyQQXg0nI?=
 =?us-ascii?Q?VnwkHgZU1Go5jpoLrHBLv4kKHuInOd0BQ4njpFkM1aM6OSQ8sN3kTSF6lvwr?=
 =?us-ascii?Q?klyfOLvshl7tZ6jLJuWhOWstZLYIwd1XDw8iHt2EtwcnTiCFO2I/tEJIVzyv?=
 =?us-ascii?Q?DBJSh6wfDYvJSiiU2RJhW8/Zr1Qr9hWXyF4vcx+gx/nuX1yFhu7mtQzXzohN?=
 =?us-ascii?Q?GBxsKht5F18o3FloiQyviC22dUcCFfzx+m75oJ18G4b0AudtFFkFoc7wyric?=
 =?us-ascii?Q?bJ4WpsSlLOP311qfDsfFWM9zY/p0/7V4Z042zNvoM3r6fHK65ksqX51+tQFm?=
 =?us-ascii?Q?uDZsrwnLOIjvU5o0gUjxCbH+Lu+UyV115Ltw650hNdyL1qdqIxs5Bjq4wg7f?=
 =?us-ascii?Q?1mh4zn6P2LvOS1dG+dyvUYSNcM98oz0p9x2g44cdiGuQTN/zEs0OyYSZ2+4g?=
 =?us-ascii?Q?5x7PRYzjGlQAucsJolLD6WLsZYNSbwroIDzvI9RejylV9Pv+xDVDlY3ITYhz?=
 =?us-ascii?Q?53F38n9UQXvEjrYbuNrRtdMPbE5UeGHLryJVdyOqELXg2KDcwtP9NP3Pu2BF?=
 =?us-ascii?Q?iuXdYOFEuxnlvApcebw4z2l3KezpR5p1FFtnu2i2UIgVqMsdku5To/eJVJCJ?=
 =?us-ascii?Q?MzBNxqcSo/hXaaMRbFZEQ0nGmrBOmFF7k823DoMHNudffysjl/S66FaJ8GbG?=
 =?us-ascii?Q?tiHWt8sA8gg7cstYyCDmpwZMcdDwpO65w8MhFFyQWp4r6JJHi1nWcsmEiV9k?=
 =?us-ascii?Q?xNasngH4XqQJtuq//cSoldLTM2DtIhdgT1x5UNUtzREMD7SkxQ4HzMZySMdz?=
 =?us-ascii?Q?nRPHISW9kqXUUN4/swHeGveYsb+vPFhKSOTGE8B64QkzY/1YmiuV8aXV2zzN?=
 =?us-ascii?Q?jH9p8JSUDpQM7z9zmNjWQIAjm3lwFakLzTBDN/qJWIwqLkF21jKSbZq9NZvy?=
 =?us-ascii?Q?zWp+p91ACSlleQ5UDmVMfnIl6b0oIsEcdOeljbKqp4QOJPuwubCWW3aTNOk2?=
 =?us-ascii?Q?AWFTjn8czxIQ3B1EPLIOT7wb+d7p+cUmS774DmosT+9Mu7ppLF3z0mWdmFrf?=
 =?us-ascii?Q?Tn7k/OcK2GyWCmQm3++g50j/neqzj3m7vJcm/u/64msdsHf+UvQCFfb1PQ1x?=
 =?us-ascii?Q?lpkkKqhai9wyoeQrY/Vse+g3sNu+7d7UMc+36l5bfDqtilI6d51vQCiJe5Aj?=
 =?us-ascii?Q?jk0lZpaz/yrtrtMo4fiNdPPkO/TW7K+wgMDjMUlbZEBja79fnunm7TLE0HwX?=
 =?us-ascii?Q?Qqeddf/VGNnsSseVyd2ZcTHwsVbXDrZzS5SJI2AqMIhZz+Mo3iGwoJVv7jGg?=
 =?us-ascii?Q?zJcrbwBQS1Mw4Mqo5ZQ8EnE/ZB59j212Gks6/T3pMTqUlNITc0HiyFZNkvZe?=
 =?us-ascii?Q?mrlGAKJqAXfiodtE2fMJ0LRelCe/kv7ox8DE156/1rNHlykW82UTMCZdTFNc?=
 =?us-ascii?Q?US7CMBHJJQ=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8625bf30-bbb8-43bb-cc4c-08de903d513b
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:23:36.4309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0IOCC7gNL7zLASMPFFlwZumxkr2vVx9felyanHCAT3ButYXgvvtVy5tJPGkvYBwKskJsSUbmiOIjP+bLF3aPCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB7844

From: Daniel Wagner <wagi@kernel.org>

Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
constraints provided by the block layer. This allows the NVMe driver
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b78ba239c8ea..8e05ad06283e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2862,6 +2862,7 @@ static int nvme_setup_irqs(struct nvme_dev *dev, unsigned int nr_io_queues)
 		.pre_vectors	= 1,
 		.calc_sets	= nvme_calc_irq_sets,
 		.priv		= dev,
+		.mask		= blk_mq_possible_queue_affinity(),
 	};
 	unsigned int irq_queues, poll_queues;
 	unsigned int flags = PCI_IRQ_ALL_TYPES | PCI_IRQ_AFFINITY;
-- 
2.51.0

