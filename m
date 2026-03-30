Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021116.outbound.protection.outlook.com [52.101.95.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7A33A9610;
	Mon, 30 Mar 2026 22:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908659; cv=fail; b=OulY8rkWr1bsjokfpfbQH08CO5LJM26Ac429gBa9WuxmjFWkMdTRySbyIrS2/pH+QrSKRbYsL+D06Oox+DtoSMu6zOX71YGfEwfb8Ye3X+7w+7iok+MHHubD1EVztEmh/8UfNIZKI02iWcXYwxaq7jRR6lUDABBg7blE/lXHqbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908659; c=relaxed/simple;
	bh=rlCRI6w3B0G2dfF3EH8m3Bulrl7HIYzKqwGvieAqpRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QCzP5kLg/XtgM5k2wacLjCVcTr6Nbvn9Io/n9H1kMEw7wW9psZdLYz8eApcoKrFrqLLpBftbqi9Xgo0aUG3UPHRfLTd3Vz6pZ6ojfkoSLLk6RXeTf8Yeu9i40m7bFHJ5l+pwobx01880YnsRlK5GaHn03zgg3Vb6iXHiOF1fhdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vN1g+tHoZg/7JXbWZJCcKh0cCUKjcJlels+QPVJ8Vk9esDFsjpx/llZ7yc+Ye/V6PPrlqCvGraD9QgUz4UlzubJq9Z5tl6b37YduOnDqJ3L3rk4pbJe19ckFlsXJTzw7o0ykvOPicmCWQBIJRp+BrgAHs+kchr9/HSH4hRMD6rsbnPqaTsexbw+5QBG0aYKbcM6eaO+F4wrS59MGr/tS3nnTsSeXTdnipuPYL4vOF1O+t+Vd1/RNFEx0e5EVpqnSVLVPzIWhpwvo6W7e29tNbzzMmyRG2eju3ryp9EcCsnMaaOUf506QJlV0Q/FwfOZUrpGsL554oIKWb9Mj0w9LkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cO0UiFQ2IRes4ghqRITa3JO8yWqXB4isrdREy2MaGLM=;
 b=V+E+zj1p+S5DwF4aSmyTLE6WSi/OTzBDjQPsbqmeu4UbEXVbDrG9dOkOLpcyOIfB9jZXu9BJGwrAXomUBkuPADgmuO7S7s5gZQcVtlinzR5mTAd6B4cObap3tJgdLNq+ZOhnCKgoUREJpZeGtlbL2hfHbff35SIR20SnyaUWZfzw5fmY4PrTPDNHKYw+jEoFRJqlSlF80wPmglxSw4Omurs1KlclgRgJ6279DmJvx7V/xmCoUj7PGm9ybb/vUTk5OWIUlsWDI2Gs9ocr0Zt9BS9jHMgySrgQ7JLAXbpwyInXBGU/gZpCFSrM/LK/pqlt0GWntB+eOCKgFQaFMQwbow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB6512.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:186::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 22:10:54 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Mon, 30 Mar 2026
 22:10:54 +0000
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
Subject: [PATCH v9 01/13] scsi: aacraid: use block layer helpers to calculate num of queues
Date: Mon, 30 Mar 2026 18:10:35 -0400
Message-ID: <20260330221047.630206-2-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330221047.630206-1-atomlin@atomlin.com>
References: <20260330221047.630206-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0768.namprd03.prod.outlook.com
 (2603:10b6:408:13a::23) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: f3b9816f-6f9b-4719-d629-08de8ea93644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PbDSLSbJb7lEPDrb68Q/WBB+F/st32B5m/sELDyDSgItH6ztXIxFwDdohrccl/gQvRYjn6T6a/sa4P1/9sPT4NjS4mioANd4iL7tEENn2yfWrfp4IkhE6Hn71ntHivcBoGD1qO4HwqLVRyvpdHKzmO2QKL6QouxsZ3Dc0enhwlJDJ1mYMPgbmQo+lu9PnsaPIwmsRoRMDITrAJ3CZ9slaamLo+QWbJfr6IiOAVEwOmxqwMjxitND/QfOop32+UrxBAGEPTUDODAw5ORZ8k/5pnors0tTnJfWii2pMySRGrsPz745oyH+CydZdjfJ6V2+bg361FAHmrRHiDW1VvrYTR5i8xpXMH5vcY3ivkimo9A8iQOw1KqBvQInj3AzTwFsQj4PQjvmGR8M31s2+Pe8WzQEzYxiFjMBCbaHoG4CSlQAPiTldyg+UbA1t508MCpA5p+8K0PuQc35c2LbZQgtufmla6NnGBTcFlAhRf6PZKCOHyHiL22y/7rPCyU20KpDS/cyK72bCIYa5zSgWK9buEaTlwwJPuYAOGft6GqDRyuJHsq9L0Uy/eZatepRSgjpy9Bnh357cHVIFwaEwWLrlTayxRPIvst/TlrttSm+Q/8L5tkZz0JQMeQHZBTHf1FfXiCZukmJWDHG2WAG+YQBCLWzeCfM6GgYcN3a6x7ks+3EUFUrIs0Z+84iKocUno0Slt6Jv31w//TTsYOaMenRhS/wNYH7k7jkfJrhInmxEVo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UWop9aZ34icJ28RKidH7XiKmALA4TrJWCYUtw+GQKxs5bk1E8l0lnixyDo2X?=
 =?us-ascii?Q?5sB3cxu14MdZMRU76np5Af50AWjjbDwQKheIlv1z/UKT1RuoQa9q9/fn61OR?=
 =?us-ascii?Q?F7hXI7fzyig9qVq8CNWmRN/a/YRtVvwht0B+Iuwza9R28mBTmY7OBNyw/JKG?=
 =?us-ascii?Q?wZ6DSWnqQn6kQvfePrmearx1oXHwZTNGJsnAQajElgwxgfkO1Hl9WUzyzPkQ?=
 =?us-ascii?Q?UzEL98nxS3FeTvIuRrjIScYm/1YR4PSo9X9VxI4uU7Ncv9Fk2rv+fpbf2B/X?=
 =?us-ascii?Q?Ok8MPSoCxIkv/HcqUjqJ5MvaQsHfSDX0XKY147HDOh+S+BI0Myo6dAU8eGxD?=
 =?us-ascii?Q?YVk9BlKSUlzgGfBo3zX1wG85UvIKaqFwnTuXP2/fhLDWcY0y7hfYV9y80l9Y?=
 =?us-ascii?Q?lKWILAZQXprN6J5+/qc6G+AWuhw7nn6Knyl5DF1pT9IpPOJQyblsMYtleDRM?=
 =?us-ascii?Q?r3USPaCbe0rLBhlkIyV0oNXAxoS3kuO6Vs+/m7rfDodmMr0H7NlTqLvyFTcI?=
 =?us-ascii?Q?fmNIFUwwh8SCLSdMMAYZEgBejTmRFvpNi2blgrm3kcXeV0H3neMXdxo6UaF5?=
 =?us-ascii?Q?dy3pQyaPEFaz4zA3gFuTYBJSqndxtKrymk6/PFY/oIOExLiFUzNXmli9JPf2?=
 =?us-ascii?Q?p2jXkUGi0LAPy3Cl2SIlofXUQ2woGvU69Fea1pptYFW5cyQOBk/EbDLLKQCe?=
 =?us-ascii?Q?BFasuvpy7Yh2AkpFUgP7yRK3qHQTZnwxiyDp3+QhuGQjFJdlrL6dnI4ihbXK?=
 =?us-ascii?Q?XrTs/yNflI89LpdiNzXPuXaY+H6P+x3i9MNECXaALB2tzucW2mRpWm0XKzAh?=
 =?us-ascii?Q?y7WNm3VVFxErWxAXuGWEmM0xQ/vQPQ0KdnckwvBk2ecpY23JhRap8oDJPqrO?=
 =?us-ascii?Q?WZ29+rJe1dT/CWdulO2LuCulXU6R7OK7uX+R87BykPXq0QeCeiacb9ZJH6bX?=
 =?us-ascii?Q?b7Y9F3hb28F1q7W+I3Y8sG2bg+RlfI8cMtH9lvjMDmaTg2Dt6I0eXbxeNGf8?=
 =?us-ascii?Q?zbqEl0vN8uXwIOQiceVtgn23z69MBobvsk/q7F6akyPz0it17UpL3C3/X6eQ?=
 =?us-ascii?Q?uNCFpMoBbwLSAdtJECH7Tl7q9xw0ZfvqE4VhCWWf7V7fEYYbOVsaljFdoa+9?=
 =?us-ascii?Q?HlBovHaiLf4YSjQLhPCeymamGOSNsj7gZOStPBdd919BEhPb5/0zanvZ3A6c?=
 =?us-ascii?Q?A6l9ycdLfU3LVq0VDiScAnSsQ5x3Y83IwMG6AO8zul+2gbMkHYK6BOfP5rDt?=
 =?us-ascii?Q?j5ICPuCcQDcPq00GzwIxhnAsaLPDPmORrjQGW5Pc1hVw/U7ftxTUaiQ4yuBt?=
 =?us-ascii?Q?3fIzj3sgYGIuuT09B2XgIne50yr53ZrvRN47fLUJnV2Ao8g7nI0FBvtJoR2b?=
 =?us-ascii?Q?6xLRK1SCOTJ8DWU3spBeQ8x5QPZajcRLHb4Efa8VAaGSIdyZNT1QaAlEB14M?=
 =?us-ascii?Q?WewBHri0AJEb9zdAWycuzvPpFZaFFpIhEFrhFWV6Xed5OjPYBNiveBcKnmKj?=
 =?us-ascii?Q?QiBvgOVdt7CrOSDrCwsqThXUR0JlBjdDcqFqECDW8QJIhJcMRa8psRxQDM8v?=
 =?us-ascii?Q?QutavgXaQghEHyo5nFT827vnGBVfF8A7Pkt8pF22TBZl57mWdJGBhR35KNhm?=
 =?us-ascii?Q?uHI1rNfzz2a9T3abo6xUMa0vIQyACyEsTsL/+T+AMIYs6kqXiI2MPMd8w5VP?=
 =?us-ascii?Q?W33//62t+4yfTg1ANi+0ypTC58d+ZvbQY8nrjKhF2333q649OveZLdJ7mWAG?=
 =?us-ascii?Q?I8nWBc3zLg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b9816f-6f9b-4719-d629-08de8ea93644
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:10:54.5407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r/GwaBp+TEbxj7FCMmFsoLHn7TnMplgYKLzYN50z10baUWQNu0reLHJEjcDoUG+k/8oA2ks2P0HqNL41MsCe5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB6512

From: Daniel Wagner <wagi@kernel.org>

The calculation of the upper limit for queues does not depend solely on
the number of online CPUs; for example, the isolcpus kernel
command-line option must also be considered.

To account for this, the block layer provides a helper function to
retrieve the maximum number of queues. Use it to set an appropriate
upper queue number limit.

Fixes: 94970cfb5f10 ("scsi: use block layer helpers to calculate num of queues")
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/comminit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 9bd3f5b868bc..ec165b57182d 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -469,8 +469,7 @@ void aac_define_int_mode(struct aac_dev *dev)
 	}
 
 	/* Don't bother allocating more MSI-X vectors than cpus */
-	msi_count = min(dev->max_msix,
-		(unsigned int)num_online_cpus());
+	msi_count = blk_mq_num_online_queues(dev->max_msix);
 
 	dev->max_msix = msi_count;
 
-- 
2.51.0

