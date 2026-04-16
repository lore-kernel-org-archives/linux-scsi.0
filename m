Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022129.outbound.protection.outlook.com [52.101.101.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447D139D6DD;
	Thu, 16 Apr 2026 19:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367816; cv=fail; b=NUNpZiDiegpZE0yhOVUJjpYWuCre3/J7DcMbNGV6LYPwjx/zY3TbQ9kmRjw4rkc9psozR4Psw8aJyLLZqNDVyD+NxA/10i7NOkidegWsyu+PXTxLceVODs4UA7CUKJBGAnAbcNp4x8tKw0pWMlyHHB4bLZvydO9b6D2mdbJemSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367816; c=relaxed/simple;
	bh=LhqXVQbhS0qUuxUgkARbjJwJPNSSQ0om0dBDJhBUTM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BLs52rRQxWb9/9ko/IO3GbOxwNBblhStz8DCWBoBR/3sMp0kZB9HOrUzp0dovblGvw0N7oWX+H0WeBKoWCwqNCBh1qhCuZzWVJ6UE465a011Tq0li9P4NGHK2nOwMlBa58PY5pqB3E+YoyYjzPBYLuaN8WC2QYX2k6odf1JhgTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yLyrTHiMgKAegd3saQc9FJOxbR+tOOeoxk6RmLqoYXwIB24slE5EqCToec7JOmABB7WIH61GYC6VhlxczhEViHWR9gFV2qy6iFvErXyJnv1EgBncRutqiQBj2b+OFLmDcFGlWjKKEI9d1jjZGA3QtZqpsRZIknAm6AarxtOZNx66dKzQVGSMzJw99GDMF750AjaCKtxi4zxOVhVZAxXa3CVZ7XgoL/2BdRvTi4kp2rrYrDmIHUoBKmCgbFlxnvNk1yXbvD4H8pbvHQWVtjDGnn7ddz7RgbCpeqJC8m3bDYNM4Hl5rRrv/w7WMYqKKSs+m2d0di+pb5mBkVBfm+ExhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7w4S0Z3T6wNBB72YJiGmTd9PC8pdIC2EN9E7yxwOg5g=;
 b=IuG4lQ+/d3/MMiZGWRIemRyn/w/+b+De479cYws+qY4tOGbSfA06RuHzcfYwgvJGBzaWXjY2jikWYCD6C5LpytuJy2yZ3d95Vu/8x8dKBeR0ZTc5yKM0FuRv4V8nS1erI6Bdtu3qcxA4xwoAoblAf4PBxfCYRcE6QBzqOuA4x6f0lYkZBcJvbkq7lAzUPFBPc/CWy1Jzak5qlzZ6ZnYR0R/wgGL92znDn21XS8uJ694NySD29Ra6Mw3iXjNrpVRuyXSpe5dVDLNECwBWP5k2DCJjEU4E+sROSMTEhXURp0pdUdsavDm1OMXFF2LNj+R+/keC73FOWLJtjR1NTcDDsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB4039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:30:10 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:30:10 +0000
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
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v11 06/13] nvme-pci: use block layer helpers to constrain queue affinity
Date: Thu, 16 Apr 2026 15:29:35 -0400
Message-ID: <20260416192942.1243421-7-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260416192942.1243421-1-atomlin@atomlin.com>
References: <20260416192942.1243421-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0755.namprd03.prod.outlook.com
 (2603:10b6:408:13a::10) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 685075c6-322e-4328-17bb-08de9bee92fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0fnF5USjswGcB5AmfhETrgG3ZaInspHGNz8njGGNJAFecu0SeDMJ43A10OURjm9+KhPybtG/yVWuNjyPawowQepH2yrFfoN9GzTTDcZDXtONFIPua8zTgiUsv4T9MozhJNDWS+6nC9MvOIBxiTGGyA247X8V59S60nZ9poeQz0FJoX7eR2d4dlMM13h6UBuFRPiEHBd6ztXYXhYPCeldigPu1QajhwNPIupz1Du4ioKYFBvMJdSd5Oh0j/IU1QWQU2DMZqQMa0558b7Gn5dpz8BvH/c5yv3xS/5hhXhkkCMMfeOrLbXapXl6LV+yNGuzuWRxn9w9DCxPqH4ARmlrJSAsUosqTRQQJRvKd9AjOeFtaCxCBeThuCbtzPTYgmZLQoVKtUqNyrD4jMnQpYY3lUzMQz5/SrmpJyKZpytVfNf31MfyyRp7o+TYyovmEY3WlO3Q2GhNyTRZ+aMzV3RHVMZJCSN5TgKkYk6GeN9Rhod7UCxCAj9Ua+TQIfAIxKV82DMCprmGd2C7SeOH2TL2Ja65/oECCP5Qmewueq9iAsxBfawvzzFFfxAjaCW8b1ZPS4NvNUSuhsEnJLxkxFfLdz9EKUDyBnADJdau9se9PUrUoIWKXcqHsupDr0Lf3O4nudHwph6t24FjYnIgu7C/obyMEusjjFTlJ5XkMuriu/M77uciVnannl7SU1wjvLY7KulUzb0kXuONV3t/xyMfcczm3beOC38sZlLjR4uRU84=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vr0FFfaA734BvcJAt6nR0nPBJ2K7jwKlEZ+pM+gC/dNlLnQaOy6WKGfZnhJo?=
 =?us-ascii?Q?eutT3kc7OKPdpVJ4Bu9UH5UwcabM5AwaV1IQVswL4DwPvg9M4TkgFDbK/esD?=
 =?us-ascii?Q?+M6v8d4SLXTErr0QoSq2G5aoGQpc8fpnOY0X02hFdWfc+P3GscwGlK0raZwP?=
 =?us-ascii?Q?zCaM7HeDRJY0Kys+4J6tqRAVeVnB6x+RgCu7RPZBMobt/3XWVEl0SiRkVe3C?=
 =?us-ascii?Q?zxkAjpMLLjgbll6pWneiBOKoi0fqmJY1i4kLlPKtT00JOaKIhfNigBq0Kpz9?=
 =?us-ascii?Q?esaIrnHPZQlyzXioalZDdOAN6x63vCYrO1P8Ny5cwp3d5zrBfuZGMhaujMDS?=
 =?us-ascii?Q?JSBDnuRo8DvR837TQDvR21QahxqsApDTpmRvsDPog6M2Z+RvXDnlgIVwC4fH?=
 =?us-ascii?Q?kUa5veOYxXYzm6ADu5LW3K+KOdA2oV4VHLbLKvcHxZ3rgOdi/+cawcheptVU?=
 =?us-ascii?Q?UFW749kx9igvSfPrSzuklGjKhB3tW/IEQyNNmDNQdRhqydA3dAdFuoAbcpkm?=
 =?us-ascii?Q?H3XLKzPQfEDr75dCVCtZhyNBPOrX6qrHw4A6b5FjG0ek4P9YXLiEN1WirGyo?=
 =?us-ascii?Q?ZoZgnJY6XhBsB1ZfLnFU3Q+JPI845lXDmZr5sJDCJwKesXxIZvs/TC22WKDe?=
 =?us-ascii?Q?Cp3Arn2jFSy/o8/nzm8mO1VNF7dhDayvaHuQh6HCCWIduGs9f5Y9MO+fVk93?=
 =?us-ascii?Q?cx3iDw0ifP5ucNIrQfWZKY3uKccOBjiqmRuUk13ABn78gd2OtYdTivHEB17S?=
 =?us-ascii?Q?RgDPRmrwD1SHlndm6UdfLAWS9V+0KHOlSTvh3m9B/2WjWYbUUIRWaQOm0SZY?=
 =?us-ascii?Q?W3wsX+hS+gx2O01habXml5eGns36Of1JP24s7U8rMObvdmpPsdSVxFn/Bl6x?=
 =?us-ascii?Q?2dOlihF9HpszAcaVTuu/c0gRe/1+6w6py2QjxPOmcMUuzNrap9knBsmDrmNy?=
 =?us-ascii?Q?oqn2MoLfAz7lv+zDN+BKY04faUD/8ilCTzm5arTYbLSeGbC6IewCQRCOMQ+u?=
 =?us-ascii?Q?IrUDk8Ey42N+lDPs9C6CihnTbw7CqmNy+h62C4nuStnpBwcTkECvFhgaGU17?=
 =?us-ascii?Q?04z5Lv4YL+WLc4ha2bhqf4WJms69Uh08M0EDEpJaaZeDbirl+y5kDSxyDZwx?=
 =?us-ascii?Q?ob2SndyuO51sXtFLgPjT1C7tG9f85jXkcTchPWZ88QA0Afz7/VJe13kNH6Lg?=
 =?us-ascii?Q?MRLg/TmU4BN/MRrgYucjhWX/PeCEopzh/kY4aaLXD0qOirhw7FA7h69fuL3G?=
 =?us-ascii?Q?kICSsqG5JzZ/UVA1ZSvFJU/UXGFq29JeRWJu4ln9VsvMDka7UI/KtpAw8t6W?=
 =?us-ascii?Q?HaOxXuK35sY5/93kk4hh/vqCfyjmbXuEq2mr8C7vnlvCJTvmbX1tZSg2CpPv?=
 =?us-ascii?Q?c7/gCv86T1rhkc6YwK8oFRH5HZofSdd5BcYjBNUfcnkhM/X9rDUwsjQGBL3H?=
 =?us-ascii?Q?UCUuFW/12R6nDakxwvcH9yxTzzKtUc8x4zVrdtQi5TJXiKa10b61k1G9Hfr3?=
 =?us-ascii?Q?6mg2J/NTOTCyZfNw0eeQ9mg80bRTfb/VEMhhq61iGzYp5USYfK/Pjw6Ike9/?=
 =?us-ascii?Q?mtIeTmtGPrRV1pN6QiQ6B8S5dfBCa1Wf5tGq9t1+j+kTVzXlp+M8HyefFEGp?=
 =?us-ascii?Q?aCWT9geDL4mBllIH05Dks+DJ9g6HOa6Kr/35hxxs2Jg9isLceeASLi3rouDM?=
 =?us-ascii?Q?c7IpP6p1ypWrGQyROni4BLDymQNPVbOG5SdlEH06cpv3O/L0hHJKX3dYUtXv?=
 =?us-ascii?Q?Wpo+2gskGg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 685075c6-322e-4328-17bb-08de9bee92fd
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:30:10.4983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A96MEmx95AIgRT1DaXKOiNAfQWYj98JznU+a++fZCVR2nMvWrSusXHv00JYeEksD42JAf5KmRVy0qGXvqfFpGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB4039

From: Daniel Wagner <wagi@kernel.org>

Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
constraints provided by the block layer. This allows the NVMe driver
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index db5fc9bf6627..daa041d15d3c 100644
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

