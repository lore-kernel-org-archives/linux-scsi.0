Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022133.outbound.protection.outlook.com [52.101.96.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3153A452C;
	Mon, 30 Mar 2026 22:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908676; cv=fail; b=RIM9uTgsnza+wvP71hzMN8ttXGjTlB1FEGEBf9IVatAXerVKzbmIprehGJiwY9uWEvGEe5tc2pauBWx2dRBjBRxqnKlGLs3z9yx0IPhBdOubAGPTIbEVG12bvtVFZNKmfbosNWVL+A39VR9oBB2f8v7C205fktvDIWt9fILHlDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908676; c=relaxed/simple;
	bh=9PAeHts+/xxWKvG+ncrtDt0K6d4HnfUQ0MHinX82lWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WDiw5TLx0eQjHOPJWuYn1mDbh53ijyLMs5ToJAW7/c1iIQXbR1x6NiPw6twV77CsKuMuEuYc6ALZ1Q4UXFaFKHaEh5c50ViRYH5aYYZ7FbHg0vOsYVmSiyjIPAEPdE+1eNKsyr+T8a8ArxED4YuUY3TeJmuJqRhnSkhrEfGdy3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p1e3kR1jRGbhWtn4q5rMGEoiqJXgkMcP9o0u+aX2Mbs++rtRfh8dq58vuM/uPg5xnq2br38Y0yPCwvTL5iAM1P8R5zBwh2oR5Spq7eLA1Lu1Hean8t5IzgaHl8+0TGTxuEKLGYFgPozO9yggFiSchNTz6cUSHHpepL8xuq8aPL/1tl5wPNUgKSU8/TUw25WrVPusdK6NcJ+HeiK1jFKw3G+kSPSmD4RO/pcW99RgzInwG5tWJVGOuFSwFmkftXQMMAmoZYtHyrN9iiln+8dekOCQYYa+caQ8g4KokqdZ4duO7kVluDwPcr46DFSqccSottdpjiGH5o1mxuN94h9E2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QshZOTJioXRV3wV+1i+k2TcmzZPPaOACjJ8wNOCa3os=;
 b=Aag2zeN0tPRm1DhfD3hk0poSidEkOBYZZlhWqv793k+XTx9xYOSTE7veh/Dlimil1zGtIVcDK0Wmwljcjbn0rgURpfuldYbzlnKNjdzT3A6Ny/wlAP2+zBUaOhCVqT8/JmAw9m9m0ZVU4x63rdXX60rP89a2OnI0srJXqIee38TtBL3RsvtbnowJETit/Rt3FC+WJIhelWsNGjX2nvkn+8A4VAUfjD9Rw/IQZx+86/B86fujOPbcObsk8pgulOh3+I+9jeEEmUt08Yj9ewo7KqrXTwb6J7Ru8orrz/STo0b5Iqm7t0FdwFV7rDW3oV6PdrOgPCW+nSBDhCdJsPVALA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB6512.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:186::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 22:11:12 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Mon, 30 Mar 2026
 22:11:12 +0000
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
Subject: [PATCH v9 06/13] nvme-pci: use block layer helpers to constrain queue affinity
Date: Mon, 30 Mar 2026 18:10:40 -0400
Message-ID: <20260330221047.630206-7-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330221047.630206-1-atomlin@atomlin.com>
References: <20260330221047.630206-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN1PR12CA0019.namprd12.prod.outlook.com
 (2603:10b6:408:e1::24) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: 98c899db-c5b7-4600-d678-08de8ea9411a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZYGiKsPyEWSswFsjq4MCVELe2SShq5bpYBe2iI/KPMgmyyZnV7UswR6LZc5s2dsaSzgktx9ZN3PFxpxPdwI1USqmiLK9dntKANcf4B5TtJIbcaPe3u+6TIKmpnYQp8DMMwv6Gz2YgeRRTQ5PUV+L+plihyFvsohCAwtUxOV0iNPBf6KhnP0Ydby7EB7+zS4MBypeCO2tEk2hlOycbgATu3IoCLgKddJ0GPuGBNKenNlJSySzxz80knZu8LByHJCtJiQsR5dHUDdCOdzd2BRjGVdAO6CENk6r02eCJQdJvxrY27vqJtZEJOPjYoKWHVM7Hbg3X/DIfubqKtMvV34qKtvjpQUuv8WJ5J4dz8RM+ov3K9NRB4/d+riytE/+YQqDy/2ke7h+Nye5b1R7w8OSL2HNuQ0V9arxto5Fdyne3ljlOOSgF8Mclutij60srmSmhRqdUPHgg1KKzdkkWefxLf8x+IHt2JHHhgMf4N4stwBOKIN/VPkUjqXPbPbD+BJ+plQsifLUfIGaxSKT7hNlIGx2vcNekEDdoJcbNuuPYsUB58gW3OgbD+tPnW+JoMMpLJPVQ1kuoqaQ5XNNuGMb+m9FzkbvZ5C0MJ3JPs2SXZOHrlWStdfUDYdClgwqS5v+mSWXm8u+LMxO1IRvyJsCsWXYF51/4FOI5f4ep6IyqKgsl08DzSmcs2ngHIstkJW4HDgDHo82DNHp7j1rbU8R4gW5OUufaxUyO51DT/iIWkk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xHYnCOPUJ82v+AFyLK5vdHlA7sND/10f97IUZ123R3HXbLBC3xltJ1ic7h+3?=
 =?us-ascii?Q?X6rMIX36Z8jpMWG1vpGeR0vSv4mq+HMHGdcAZrlIc4Z8URmASndJuvcN+qX8?=
 =?us-ascii?Q?z7Bp0UT4dJmPF0hOaZQPMDK7cbsQGirnJOSBDJW50z8RYLo18tkufl8xF9VT?=
 =?us-ascii?Q?eMP+svYgqQqH3+odiFSJN5NyRCjqejFA1mAv2oDnYVRn79OdwbGvKbazomSR?=
 =?us-ascii?Q?/m8BojYMdPnMgB3/wA7lAd2TeH7/7FNqV+B5sxTfqwPHqtUr4sjaH58a+M0K?=
 =?us-ascii?Q?vBL+dIdqrXdgBV+LIMaKMNJxPAjDB9rbwFQ9FFx4MBEnTEZUsrJ3u9Q24dZr?=
 =?us-ascii?Q?g+/nY5m+gyCGd09VVP9IYfrL4LndhpwrMbCOGyhQcjefzcH8prNIvfM5aY9N?=
 =?us-ascii?Q?X69h3GBRZbD6zezRkMhNxNU5lks0AiMcmfLCMsU1NXhh4LQYMpCDKKaeHP8V?=
 =?us-ascii?Q?SBd5pXLe1WaOMwQ+jWz2aFTJ+3q1xxqc9M1GE3a7B6yNHv3KtyMAVST31APC?=
 =?us-ascii?Q?5rge3rz9D/iUpK0o0zFpp7/+2/A9pnqHmTL2/0xsLMlerigQAkuJIiwzTJKW?=
 =?us-ascii?Q?jNqndNgIxbqMr8+GGkU5TCtmZKAtF5LhVuZbxgj0reTLdgQlEPJrbEO4GAaO?=
 =?us-ascii?Q?bVoZeP+9S7fex4BGjRonHVPlqD/BYd/kxQouA8UkIn7Q3mwzKh2Rl/NWDf+K?=
 =?us-ascii?Q?DhANvf8SpvyarntJeVArZe8pTBisJxecFOazwQEKfaSXhiNXNCdv4vFIFfZu?=
 =?us-ascii?Q?fhsS9G49osEIPtW8MZ4QqKqOQkaYxhyZmZLQts1wx45nmr8/BTrHQ99c5BB1?=
 =?us-ascii?Q?tQiD4ap67NPFZIFWA4nbIj6Yd9WyT7hsljWOUaPBYeuH897j1mQpPLElWV8Y?=
 =?us-ascii?Q?ieyGy3ZfhFBTNuUU4S3BA4PlZoEo7/+MwMbCYkErcm4gC23zStM5ODzysImc?=
 =?us-ascii?Q?+wLGxFNZT3IYaivNa9vEDzbL6gaB3EEOaCfz/q+uOucCY35rtzkLvCKzBtAJ?=
 =?us-ascii?Q?nKPcrRMvQnO+1jlJOh3lyqs/yu0ZdudSvB0up13vy2IDW+6KfLKDU3H1ZwUp?=
 =?us-ascii?Q?727TdiUd+RAkSv6ZRLPG4OoBWjwAgN7Ym+LgOjAaZ46aSD6h2qL0v40Ic/CX?=
 =?us-ascii?Q?EOs/cedOP9y/+8F2o2csNfMwUghyf/s7WWLKUeC3bCJykun/3ZeIuwQ98+6m?=
 =?us-ascii?Q?5k963JktHVPb3t1tzmzbaG5KOXt7w5xCaVwAEtZfplVo4V2dntI0zcslx/WT?=
 =?us-ascii?Q?LzYNDkmvquLWBefArRwerhYM03qCOFMb2eyv8BGAnWTSrix20/KgsJ/+Rqkw?=
 =?us-ascii?Q?+Y3C7Q+GYHuldKmfbkS/t25uGwuE480w0MFw/hbqiKQeSHkS31OjMZSFPMmF?=
 =?us-ascii?Q?wP7J32bPiqpZYaPQoBEJcbXHkjoIhYAgeSzvrDqlwqYBKKN7G0WQOSkclfWo?=
 =?us-ascii?Q?dkErldrOmNfFYuSnub+NIMGnRSpCB23lDZ2E40QUQ4a1cFw12ZyD3vCVJhDe?=
 =?us-ascii?Q?8pb9QGMZgdCBZJEBJKn6QsqCJFaa4HvaZ4rvsS4yFnump0oTdlmYLF6Pq8i1?=
 =?us-ascii?Q?MjdQuWvcZZ8P2ANaEE0ihE/55motq2pLhbFsHqihmfqqmoSRFCv2+IRrwSuL?=
 =?us-ascii?Q?nnMaqIsoYlxSljjzUooc83LaHMZeCG3cFdPBNNeaHV9s6fi4/X592zL8ZtzB?=
 =?us-ascii?Q?ga5lwsAnPz+gLsq6W6yQOnYZLJpFAgOxmIUAL7lT/n0aXx0pBri1dJLDSO8E?=
 =?us-ascii?Q?5c7x2eQd2g=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98c899db-c5b7-4600-d678-08de8ea9411a
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:11:12.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /4npD8E0v0d942/5T30J1ufN2eXZzh4Y3UFVIWHXUFPkTwQiiweYL8TFa/ytYR1jQ95bLlgofzhHo/8ry+Xhpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB6512

From: Daniel Wagner <wagi@kernel.org>

Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
constraints provided by the block layer. This allows the NVMe driver
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
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

