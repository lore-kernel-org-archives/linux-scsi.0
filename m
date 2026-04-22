Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021121.outbound.protection.outlook.com [52.101.95.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F772F361F;
	Wed, 22 Apr 2026 18:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883947; cv=fail; b=bmGPX3I1LvEaBEzn5cPf+dWcM/h1Y0AxKNQgqt+xgb0VeYer/VcwhnFX3TyyJ3kO5chlxK4kU+E7FT9HzTuntMHA52P1vlqBFTPFsAo7mOHcHsOdSnpNJ6xAHztGfTpiC5xf5jpDy6pCdhi4hVmO+qHLTg+a9lUauGl3Lu/HwG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883947; c=relaxed/simple;
	bh=ZmC6aXtPRP05ZtCX03B+lneBACYLp/Gf8ZNsdQvr29E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dhtbsljGgp7OziWuM34bEY88KIdd/Qh4Rph0IUCA310Hiqnt0KXarrclLaE8VzArcaRsMrrG1NTyz3nlLVUQdUlipHTxnO2eYL6U9jz75Q4oTgI9srJF0/Dwny8owzEcC7bIHz0EHMHc9r169a5c0h4nR2f366wvcyfoqC/gorY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BtGwUIUs9gzQQMQvOF9+nC5XP9UYYH+a7tsjk4QE8FTVcMO+vf69seybpCwBvovyHwG3zGW/VMM1SNaIIplbj2fP7CpulRu1JfILYL1KS4JJF6lVnaiyfPUPjKfNo9noWS0Hs7iLt7ZpWZotD93KiV5C4NeIvbYPSDivdHkXS14G7OlTW+79fVQ53IF4zvHIIzAaJ17wSs6Gp1qU59eSCSoD6tc8/nv6h0Wfhxb+6DvjMiArtkMrXE5FLU4USYV9+hSZ5O4l/Bk4liaYbd062o7XS+vmti4Ju/JkDmjVf654D+yNSt5IEZxZNMhCfzzeXEgo/9gkbpoVkIanPL1BJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ee9AYLriQVkhiQVnDInfi9nP0h08/1jbZ3RuojyHH9c=;
 b=lu2JYx2VNnW+NzNI/NLSVpLmqPRKMInPpKda0QaCiN6AsOOZkwWoIzwVxw3apVcyczdW+SU+Lef3xNpwlpN1+6xIdVgvrNLU8tnpBjvlOoOI4sK0qe+I4Hw0ShgIKzYhqA+J6hkitySwypFQjZE2k/INXzKVsATufjMiN1WfPKFUXq1iLVOM0P1m/lroYnJoKA8BUNg1DIr2WUu3oGGpr4I4yE06Pu/yc4e0HUtNB8bsDxJBM1XzU/eUOT0gGEfuiECHeQSYPqGZ+wBW42PSSgV5tyjQzfZXDrv4xTJrA8p1VRTlxN+d2Dp8kq9Lbk1Q6QNVIIt3hBgubcCwpJJdVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:52:24 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:52:24 +0000
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
Subject: [PATCH v12 01/13] scsi: aacraid: use block layer helpers to calculate num of queues
Date: Wed, 22 Apr 2026 14:52:03 -0400
Message-ID: <20260422185215.100929-2-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0041.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::19) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b0c9d11-e6f4-406f-4d5f-08dea0a04a82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/jl109328YTVaEx6byGR8TV/8b+WIrMgoTBWtnktrWU4rFqWPMXQiIIRAGekeKPQ9z1ocJCemCG0OeZ5hGh3sgPu5inzCI0r2bVy6olTrJz7ceHhEWSfT4wUdWRZbQW6UM1ZI7KJMqxw6hgxDSl3pDcg415wdqGCSVjP4fxnd9x8UsbDRE8zznQMuKVpu7TVDloZcsotIneXyDJVXwX4nvbOLLbUK1Uh6ynDFY2+2rXAkJ4JyJvllTzsKq/yHcADxCkmgAO3N+mTc2ILUrqj1LjeWQ1caOCaluA3L+xn6k8Zgxuaj+Ma4NQPZ/XqHyANt08gsE01C25Q7NEhhrGiEgVWt975jHDLF7PhR8n8yer+NC5Ipusu+4+mkjyVr3R1umL+o/z6/1//0J7ri1gz/mbVpW5dBdiFWZv+F1eOWsyS/IZoJ7OjkUA29ifGyHrxb/uNm33FjZYBzZa6RVd8bNT2MnFkGeJxz7wWxSu4GeHsCVHguZttys1jpdJS/l8lxz7FNsccTqXC4k7092Kkv+LKMOzt7uapCBHlfs1DG7edslN8vpzx1PbnOn1nv8og3PCjMFFGHq+/AwoDePG5BxMOfN1F2l2s9pp/ipo/Z8CtyTKRuIPl14aSDPwBTgbaqsryP1v5HSDFU6JmtzeTwEB8AZoZ1zoJx/npfwvCLrHMoGJ+75RtWVQWUOZl8ZFW8ZEg+Unko58hMtKkbjKRQ1GLsKckCmkXSgSFc+YL0ow=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z6W3wGwsxwRrUpXOasWdvsapEsRTng8s84U0L0KZxB5Y6F6gq9j9G/mhWbOd?=
 =?us-ascii?Q?RxzR1QmG1yE7fFbr+V0vRYUFKqyUb+/7fT1JIJRaRg+B3CUxCwhYklmmEXLP?=
 =?us-ascii?Q?hvV54NPfH7frzSMdkTR4tXkTwuW4sM669Xz1euK5gZsroDnXks8nPOfSROj7?=
 =?us-ascii?Q?rsN3phOlv2ShN+ghh2H/yqaycrxLmO0/TmzqYnI5JbGaytS9r8/+IcP5DM1Q?=
 =?us-ascii?Q?NL+LkqwcC55qYTk3iOiblRY9zeiZUFH0nZqZKsDUL/Bf3LxP9adwvEXeLUtI?=
 =?us-ascii?Q?a1Entzhegdg1TZpOaAExBmNoK1StfFjEzMY8x2Lf03ws6dirVEGlMiIipWOe?=
 =?us-ascii?Q?QVHQo69YZy7CKp2N1xasMxtzHkDG3dWva8Xgkk2j7V4h2BLaPfPA9XMXDyhv?=
 =?us-ascii?Q?E8vDqtZly6xVwERJ+SqT5ch0fIxiXY8qspP+yWNxnxBU4ccVpkJcbVBPdcC6?=
 =?us-ascii?Q?6TpFdP02pCLVkki6GeexB17ioohzFrLac51n+f7oszw2JsJpuMpz7W1IncWe?=
 =?us-ascii?Q?hTU4VfynwawaF9iiIRLPDrRxdyw8bTEdI1BdC1JghAh2ktsbDy1wPgpudXRr?=
 =?us-ascii?Q?ewLC5zmwXN4CxmJt8iYxyQp2rhtEMMz85qMLTxt3oSU4LNrZ5W3UouSjGPA6?=
 =?us-ascii?Q?JNeYF9ODj0Mjb/eKhORLc6hVCT+NAtPn39SHQh1uBQU1RWa8bEgi/m8d/U+i?=
 =?us-ascii?Q?mRfz4Ugsueu5i4BcgkY2qNmAYyaqEr4hLS6OQNh0k954sOYd6VVSN3oFyy0+?=
 =?us-ascii?Q?VIpKx1nO8VOxio8KOoRA2VAGNoBRqXNxkruFMG+SmfrC26ftL/wojF07qunW?=
 =?us-ascii?Q?fsFpXOEXdf+DsOtTdEKyA+Og43Nmyf32CrfUFH4chvwOURRA0kwk+nEP/bnc?=
 =?us-ascii?Q?T6WdhZvRw6XxAcVLJ64w6PusU7/zc637ebl+bj1Es81LTC9lZtjSgqWycZBw?=
 =?us-ascii?Q?t5GLzGVxH3ivMcOHvntUt1qAyml4wJK/9CIOhsKmyhfYUENYW5pQAzVTTWVY?=
 =?us-ascii?Q?CqS74E9tGSo/4nuCDW9kecxSCrXOr3aPoZuLgckwjoA0+6GHxWx2Zx5qC60c?=
 =?us-ascii?Q?kiPklIvGEy3O//pEXSFJvj5fJtd5T190usOR9O5x+46g4gWsHrfburG3p1oe?=
 =?us-ascii?Q?41ONYaWE0w6Sd8ch6mOmX/jbBXnl5ERj5YhQIR5kHDWvB2VW09pnx4grsgmY?=
 =?us-ascii?Q?jvdwRlsC2ZjWT0JBLwTqrvAOCSM3DGJLzKQhlaUNzeya8hiy4Q9qO45q1FkX?=
 =?us-ascii?Q?4THkeJPwBYfsOZQzZTw2f0lUQDjC1A2MwZmZ1qcLMKfoKZ0Gm6IEm0Qu1uXA?=
 =?us-ascii?Q?ge1M5SRJF77su0mInS3P4CQdixdyPM9qA1Spnk1IaCmFYvKMKsw+EFj+0/1L?=
 =?us-ascii?Q?Bdxy6lnQXH+LJOe6sy+OoCATG2Uqgrein1uZTCfqhdZoMrHvfsPhrcbuQSqK?=
 =?us-ascii?Q?T87oAZrizP+DkUagAZ+oDqNUP+aZvtMULyp4Qcyazd3SnvkLB9uqyuz6Vy7t?=
 =?us-ascii?Q?bL1Kv0qeTE27J2FUVYZA08Teja7PzMPV+E243CIGNXwzAEKBU+6R7TKceDAy?=
 =?us-ascii?Q?JkbPcJbx4X93YYSDZXS6M+hygZJu/N0mi1ICCbvroOi9fqtxdPqehzTKPw9m?=
 =?us-ascii?Q?VAO59D5VZkxfDemPiPt/AbemtxXaI7KKfq392gh+JZK0aesh6btOsiCczv+n?=
 =?us-ascii?Q?I26Sgxu3m5JqLbMMt/HJwBIHXUYewRP9H9ga5PlMJCA7rrLUT/M6rxcgM1Vh?=
 =?us-ascii?Q?1sZZSsjl4g=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0c9d11-e6f4-406f-4d5f-08dea0a04a82
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:52:24.0621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SzFT557t/MVc3+5ce8kkrBEmn09Q5oT8ePBse9wMCSbnp/0/A5tTz++j6tJZGsNmPppCzuvkdQVsX1HSPq9lIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

From: Daniel Wagner <wagi@kernel.org>

The calculation of the upper limit for queues does not depend solely on
the number of online CPUs; for example, the isolcpus kernel
command-line option must also be considered.

To account for this, the block layer provides a helper function to
retrieve the maximum number of queues. Use it to set an appropriate
upper queue number limit.

Fixes: 94970cfb5f10 ("scsi: use block layer helpers to calculate num of queues")
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
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

