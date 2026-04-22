Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021126.outbound.protection.outlook.com [52.101.95.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AE230EF75;
	Wed, 22 Apr 2026 18:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.126
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883970; cv=fail; b=QU/Fmuq1dbYlFtuVIXY81kZNiTvEdc7OO1qstgVH6n/AU9YkfF/Z9n3G5zt1XsWcx6fU5rjc/EZfl9rE/Sz+6Eo4ytj9SIAljZOy3pdNVRL4aN1FahLbWS0PYJMHe3G6EMsLQkAhVscwTSA+Bx6F7XdiEKmaxCZlGXUnYXJkLng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883970; c=relaxed/simple;
	bh=LhqXVQbhS0qUuxUgkARbjJwJPNSSQ0om0dBDJhBUTM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u+MlvNvlmPqqtFDv1sMJNK9YAmaBrNH9Qmo4NuLuYdKfLxFaXjfnhjHifke+P6qD5BycxI94ENGHY0qVzEkmKViZJPlfLD+o0u/uAG6OQCJUWn71G7F7lvlneEr9W4HO/8UkhZvqPCLZ8vUfa450pipMJXQZ8vJ+D3gLU0aB5qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jtp9CkRUteTcLorChip5wGuq6TN5COJuFqOZvY4m5RDvwd4w9wZj1C9ic3IEfx5fNt5Ohi00flipS7OYFiZucV3u9PxKcfUHcnIkMRXijj+BtbQxKDVXevkBtIggMDi2sVxM3EpE0iSVbhm5i+PQlzNoHXVG2AxCrVmy1atUVK9DwVRHrHJ6OUFnwHUZFQN3K6KR+FA40GJJLyvazYRFmtWhBK2UEi6SzDENAsJjYcinYj8fN7mWTqM6BMvY7CkQrShZn+bZ4lSlCujEGr9FHYM5xrOb9eE7pSTHdPFXcbeCxYc+BIW28To/ACdqWz2ddLJWCxFQI3PMpPd4VNWI9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7w4S0Z3T6wNBB72YJiGmTd9PC8pdIC2EN9E7yxwOg5g=;
 b=S+Dh5DygHeGJjyP2VQkhGqhu8t9JIrDkiWjisJV3WI56SNEusXvodUdk5q7dkjupXvciy84Gq8cOcANt6wfaLZYmONxfd2zZm+ufGFlfTbRb4GafUZl30FTQQILZcq+9aB/CujrZeqsrb6L870lwVftrC2wtSGaSuDmO3UxrLJEr4PJa2sUqIS3f5Z6cMIxn79lxLdVaepEHMXktplmi6opq73NGT1/ktEb4E58evAh9+/wFS+AikGZpewuKRKF9GVJjfi15zjcBGrcN+6lYQrxmiId8r6zX4nhSJB3aRi3NkwBXuFBhLq774x7FO33GHprdZxotAq96DNRlo0RkBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:52:45 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:52:45 +0000
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
Subject: [PATCH v12 06/13] nvme-pci: use block layer helpers to constrain queue affinity
Date: Wed, 22 Apr 2026 14:52:08 -0400
Message-ID: <20260422185215.100929-7-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0533.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::18) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 19016d5d-31db-48a6-f762-08dea0a05751
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	165EVx2vv9lkhMxhhT165VZcCO4LU4/EveykqCYOyhrBKvzSpkyLjTDdZfl4f+GtAT7B1wQsrt08j0YfBIeC46ymOpKJIIgcx8xcok1UsRnPJ1LSc09aMBDR2xOneKLgiTHwVwm2R1RnJj5n7LfZ5kHOaGwK1JbIh0ZjLPWiVtbwCjDYxSbK+VNRZx5B5SaSqAtoG+OLyvW3Mb/lfpJMsYjvVmHwdN6Xxzz3hkhflYJcD3XYu0pjYD855Je/rcARsQprz6oTSOSMo4zThveuMomlnpMPibYLklQglRCeIYflDgliC2X894pUEfLjdU+RqvgfSuv6J6/rD9Xmx/j4me3SEwH9vUIj5XsxJ99shBr3ckTnsWZKQ9+I9tTcs1KdRJ//D6EpcVbgqHVQKhgm7iFW3w93MJO2HVOjny7kEp8vwoYJda31T9L6l0AaybBHwNvh955VTzJ+pxnsHAH9IMDb2491PVoNk2J1hAkKJErydh66j5//K1QQg4WDrUNFRKv5EgriHZ9nS87e0AKNnDXxHfFTTb/1lK0MDzeWP7uSpRpelSwY/4G0J0G23zXmzON+ytO3vqzqkKSBeJxQOwocilmKXK6+MU8CZXzf/wzoem/rD0e8ajSsECXLukp/52a4EBJ0p66CbfyqG/eWiq+y1iJOl4ZPhw1c1xtehl6ydN2VRokPLtFmKh/7kz6dMm5wNicBLlaVuOMt2LdyQdDlRo0vTOd4mf8+B5YGzgk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vGsUsIy8dt1xRFonrPQAO0oszsUXC04ZonO3/2WdtgUJw4z5uiJR2xkNuWDd?=
 =?us-ascii?Q?JTTDkVk7z35tHBzLM/WHbiQQkIR1YS92DFOxAH5RqDogdU1JEBrxgMkIAvo8?=
 =?us-ascii?Q?igW9stuF2xDXTFw2IAtnfMN0Etd2Evk0eGMdLNw956QRGRioqvYDepOLI0ae?=
 =?us-ascii?Q?nv3HgOs3r3/drYP3IXVehP6+/Ebv7kzjrE0PqszW8xn87wDdFTQK6bq0DcMj?=
 =?us-ascii?Q?M7I4c7OV3vcCUaU+w4jfvCzojZOT2J/yucKZteWVdMB+6diMJt9KzRYiXQTC?=
 =?us-ascii?Q?e1848b1pUbhkrEdV8Uym8qbiWSP7QHop5J9E2QP9hTD2j6QMjUNQiiFhrnug?=
 =?us-ascii?Q?vd0ysPExokFShHEgvo4hPNx9EAxlIyhhiwM+qIP229N8FSyQ6gk4ETu6VSfG?=
 =?us-ascii?Q?5Go9BB4UMn4WV5Xfaxwq/Bh99x/U5KQHgH6BrJalnIvCKoFvO/aUtbJZj1Um?=
 =?us-ascii?Q?bQvNaDl2r3V2FUVO0n731qnaRomfUwkXe9KRn5CUbcsIvW13/YFiNMC2FyEB?=
 =?us-ascii?Q?reSc4J+SIkrM8pbTd9A7hzP3CddxGI6tj14jQ5BD5J+FXKEiOfdxvKUsNmwA?=
 =?us-ascii?Q?jLfqLDU5xb4VjIXCM/LKmRrSFHgTNNFPfaxICets/sheQsgqok1Rs7jp7KQy?=
 =?us-ascii?Q?XB5rnU2J90iLyvV0DuwD3fW7MKzaq4RnC0UxJcYZHjhG8OXXmKeMlZCyf5H4?=
 =?us-ascii?Q?3m8oudQXyXdC7vNC75sTQaz9/LXxM9CIF6SXwZImQ67NFAbsMl3PaUFmhkui?=
 =?us-ascii?Q?n/Z6cLYPkc0GpQ4cGkgE6BA3T0Inr0X68sastuBE8vcH9iWdc4j9EorNPjBT?=
 =?us-ascii?Q?l2MRs+rk45IXX4pFNfSqE/fFcnHuM/Vp/856qY3DCkrvTZBSFZUpjXSySF9X?=
 =?us-ascii?Q?B+nBdP4ktPuWeGR03ay6o/nd4K2n2oPg5fE11YD9NN+Hk6lRMMPRjpaHeDRj?=
 =?us-ascii?Q?Ti06kr+xqpCaKz0qC1LTbf0iLhLdQbmemdCIYuviMzEGETZ3MtojZ5JE2DEZ?=
 =?us-ascii?Q?7Tl8VeworN9je9UEkyTP358jRmC2Au65+/dEZ65o3X16AqkLLnpybPnmwUMk?=
 =?us-ascii?Q?ojEjhL/HwXGtDiwwhJ0Z2wOYvkklLYwkOLkxlAQ4/v/0lnmu0HaRILTdBr/n?=
 =?us-ascii?Q?NFMml+iA2ca+CbciZe4AC03mnwU2lOHeCb287TwCoZT5Kj8bE+lKEgnYQNpP?=
 =?us-ascii?Q?nct3TLEZtODZx9HYi6Gkt6iBmuWZGYHnPtWvxracTYPQFiibYzZcEHMlcQa0?=
 =?us-ascii?Q?y9MVRVdAEz1WnWk/brPN/Y6Wb0RHgkh72bi65QITC8hnJ+19fQzG2+LpvscO?=
 =?us-ascii?Q?e7CNAh00yt6COeRy8w1nnkfOFvVTj3s2Jfp/8ELC34NNVHxYHCSbqNvs0c7G?=
 =?us-ascii?Q?z2LrzvLbJf4cEcFrQr9P8GZ0KgM1jX4Q34sf4jbKQxdBfhRCXYDDSwWJ0j7q?=
 =?us-ascii?Q?6Efcfgr4wnEdSCgCKJnhDQKC2fFDpZE4BV5A8f3sXIQYzxi95aFUC15dVdVW?=
 =?us-ascii?Q?6CW1Mu/hiLuB01qs+oWtMwiMbxHdb5p708UQrjMTIiO9DCm3gHQVJMXr3AMw?=
 =?us-ascii?Q?Dp3c3+EMiGWyi0uNDYLVycmNOa+xARfwqIRk/nHyxawSYpMjqNGMUNBlL5KE?=
 =?us-ascii?Q?rVXuyi4ACt5b+Y45zE3XcgDVoGmCMy9hAUnufQd36ivN53DHoW8aqHetUfU6?=
 =?us-ascii?Q?uCJ2aynlJ1VPx3Fe//kHG35h27aRhljTV1ZyL0GhYOIHBzIj5kMfjW1wL7cc?=
 =?us-ascii?Q?DousAwl8uw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19016d5d-31db-48a6-f762-08dea0a05751
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:52:45.4315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ZxiY0C6z3PhOzxDODgCL3TuK6vcvUxUrTZTIt0Kp2DKctdO3ss0hRvcECoH69GClnqimyCVvk6f9yV2aef+Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

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

