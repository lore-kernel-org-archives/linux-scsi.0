Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020119.outbound.protection.outlook.com [52.101.195.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175FF2F744F;
	Wed, 22 Apr 2026 18:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883978; cv=fail; b=dHb77088kAQO0luAOUOFjKcAqWmA4M60pc++kQJecNu5zn5xCu/7GApcSA7xbpFHOiQjEvMb4xqqfz3MgnO+oenlX0WvrR16zX1Ri+5jUFgVh9tFMxsIjUICf1oTukg2K6J87LeqCChbVzWTRXPkblMzLds3R+Gwycq1I961s64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883978; c=relaxed/simple;
	bh=eJndu5EpHx9KeNjIm+pQ2VF6eSpdcbKw7Mkf4OGJQqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kFrsC9IT9J5j6cbORzRKtYaRlc3Rbs6B6SdwQx8hQFF4o03deHnDm601n72QHW3Tl4FsJDh9oBpJMNjbtVjP5x69WUhdLK6gBBcP4MxT3p43OAwR0A1N5vNEs1bjQ1GPbQu+7A+T+EpS0d9ecYGIr/+F/DPmaYYNg9N9tb6eyjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZuqWAYc8xRS0W7+Xm8rNCL/Fg0iSBiu6wsspxd1X3ZIZCLxCFY7ItMsJq9eLwxmyCc3sIhNPfcnW/F/q9+mqXQmsWbp/ZdOjoMt5Re72ewf6z9IFQZoSHABZfSKQmOF4QKGHiDwojqNyP85lKMyRb7+LzoYMtw/NwkLoEYawew+uzG/5eCON9zuDM5aGySREcox0SdZ3JMcJ0lFOLTEGGzPv5fGGfgorEpBq2MeI+iDwgSWYxcDU4IJEHZK8mAU9y11w+rZiEr9vklRCiGtH9PgPFEhAuctRDS1dcUshCiXWOk/tUtUD/HgCiAg0ucmjL9P0GUTV+agz8mlpZWiYXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ndv+ewFWgr8q/DKYsNicKzhzBW/NQOBeFuhXmt7XClE=;
 b=e/g7d3WqHP4b0c5vkR2ytHX+s2TjGIHkNcGL9lxTE1Eb+5JAhA15BsLfuHkJl7ak01QPexwg3xxHLm0sNerlPbb9AdojEQdf6CA7nu/qE9uZRTx7o9O9z39wPdTtSccQDPDpmpH2W2fEm5DcxGwqf5dql1y5kRxmg5YSnsOP14dEaOC8GBUlu/64dmtqCaB2MorwIZYF/lY8BH7TQgKxl+8RyicM44cEOKSAlN18vgPqoYUXlTTGWX7xUmfJlvoaC4IttOnLiEu9j74lX+Cr1OMbmZJ6aQBiYN+PfnA5zvzCo1wYSCUs1NHa6dO8xKXmalQ30hJEI5oZpGIl+5U3pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:52:53 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:52:53 +0000
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
Subject: [PATCH v12 08/13] virtio: blk/scsi: use block layer helpers to constrain queue affinity
Date: Wed, 22 Apr 2026 14:52:10 -0400
Message-ID: <20260422185215.100929-9-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0317.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::18) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 866bd42a-4f1b-4c3b-7ed6-08dea0a05c34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	D3w9rrbNPOBpz9bgRAU7XExv07GEcm6uIPlf/fCTiQfshHdf8PHgW5SGWrITlT91kF2dJNRA9OY2ai4B064Kue7HfVey8M27g6vLRBb4qmnTuG6OqV/uVHvhFRHEfBy/r1O/GcaPRxiZ33aYOW8HgaLnRh4RjUEXoOnW2F4KP6hA7eag1i5gY0Twc12rGb1Xql9nnN8yxYanbLeC5in/Ws+y6rX1wX8C579lz5sc2YGJ/Fh6L7ngjBdv2vnOzjBRnQjMwv+6lHKxmcvWX4AmNPXhYMRt7x/ZzPOUxnA/yXv7DIMc7jdjJmkUBmEYTH5jh5G8RlWAAZwyewyy0vuHN8Ol2pFA0RkdQHVnKBCb3X23xNrfMpdZDE2wINUJWa+43d1R9tc0fwVihKAQhS8nXzLx5n/HoU5IXfyYBTQsnSwsRjeNF4e6PD0IXCs4is7nR1HpLigiPQRHl9lXphdtAr/eWzvAc/QDd9nbDt7MjMPpGrK2nZ5RGK6wDwyVxmKMkwoHYisc8Rm1ofERXMIYaN4CMqEgKXVXrmAOtG3zGUs9kfb6cTBdtHt5RRlxxljdXhILMfN9LVyul5bMDfZ7cVDArMjg0u0lw4oa0x7m8GqbRzFUqPhBqAFs9qTTUxsYgsG4Nk90I6SoCxlu2sO2gv2MrMNMaZpD9wlPJnXR6mi5jcBRvvK1d3nK0drUCQANPJMnZ9vj9llgIEHg2pvjZFPp608LYh4cFWvPkABWUr0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RbDen6BwiFp32zaqNI3zy3LR1FSWatHYUeZ5DV8GuiIP6/BMhqfsKJZcwXjv?=
 =?us-ascii?Q?498QYviY7WfvsrBc5lefN4PFLXSF/kiH+mNgwGhGaITKuY3nx21pZAIHpAU2?=
 =?us-ascii?Q?fXmy55XEzCrVN1BatdSRsQhGW4SXJb9LxYDQ4ttApqa5v77lvRUyQM94zygO?=
 =?us-ascii?Q?lAJxPunie7I2nETeO8pjRdnpPHeEhR4bvkiV52eNJqkMcSIOcqjiX//jjT9X?=
 =?us-ascii?Q?X2GfcvDwcCeXQIjbhQ2gLKepE/CFvDCHTTNtj+SsSKLcoPJfBSa8HDF6AJZh?=
 =?us-ascii?Q?Fo1wtR0nKE7alzphHGw1ZYEoP6ejLFU1tB54YZJ0qB2uh3xXkCL6jPJ0r73v?=
 =?us-ascii?Q?5j3W1PLjENmL7eJmZLVWxvOACaNPoO8wuAxMPFZM/Ig5PCnzvO+s9DAH2Rly?=
 =?us-ascii?Q?wsuAszzTF9dF7qpkZx7URrYxU2ZnGW/k/VMlGhKoEzio/6xlfXi/LxN7ChYF?=
 =?us-ascii?Q?TzWvuehI5Mm+A86EyM7KujRh1e52okG3KbtlEDEfsxZ1nCtFItU8An73rdHS?=
 =?us-ascii?Q?/NeST8Y2hA/nW6lp950tUhV7yPWgsZDAxnCwDvJcgpdKZX4IK2OiubewvKVV?=
 =?us-ascii?Q?6YVAAqKxRcWce/DtYBLipf1kSHhLHQiTw9Qaznx5LoUZSnfpIc/2ou5syQdt?=
 =?us-ascii?Q?MrGW8yT5le8d2F3jBtrmR2xQm2m9Is9aHy3pssvvABrFomxTENAmglpBQKQ9?=
 =?us-ascii?Q?qH8Kco/yLra4b2cwCfZTZJbyE3mqO4k5ZhhjozLZnaAfaENA3o8c2sbTmPJB?=
 =?us-ascii?Q?D5wvYz7GK7xxvIJQNm36mbrikT0qu8m7Ec2n58bUYGY8vRShkaIzIA5TDggm?=
 =?us-ascii?Q?k0+aCWXybKOEhJFynzEMKn/IjaWmgt+xIztTDw+QpSI408E+pNDNgYAYw3H3?=
 =?us-ascii?Q?PiwkIt/er6dtc48ZLoowS2J0nLbsVPG7EfizXA+iw9YkgOP/LSUCR5V3Ed5M?=
 =?us-ascii?Q?Ua2VTGH683FHsb9ayHXsmk3Dz7JunB4m6HRQi2hL+lstRYAMBcQM+f0sXz6E?=
 =?us-ascii?Q?aVNHqkbCYoENDVaaeYs3R58/jsrXa8x3frO++aU2HM+Pm0/slrh13qdFWEjI?=
 =?us-ascii?Q?aiauPHlTUqOEu08iF44CfddDgK0XjAnWwptX3qX/h4OQfAG4I8BpPIzx8NXd?=
 =?us-ascii?Q?BAm+CiQP2ueLkoAy6Vy8X5kE87Za21OTERZc8paRCL0KlL0jbD8DsvRK66Z3?=
 =?us-ascii?Q?blwII7WbTThmx+yh8em1qNkxmzey0otsEUpviCq5mbIyTQkKB9YISNQHHsnX?=
 =?us-ascii?Q?10y2+COSigrfzuS96GI3Oc2QshEU/kIBAEKCziDFRdTloDh9Odqp3bhH1dZl?=
 =?us-ascii?Q?I0rlON7PYMA0tTvq5D9vclTVwv8+TMnEnio9QMOUa1VcdiUnChlalZZSACSw?=
 =?us-ascii?Q?fMTbtitDhY66m8fKu7d9aImb2xc+2n5IBM0u/bwytjwE7fuSMxpsULLQRw24?=
 =?us-ascii?Q?JtFqM6ZVwPKUe2IzB9W55nIqOG7+iVKtbIzbI5rNAOy0TBGzafTIb9L3HitL?=
 =?us-ascii?Q?//vKAXCM60U2xhn2RAxj3rEfg6I2yWwzi5A60XgAq7DTo1SOZxFrHNRZ/FMw?=
 =?us-ascii?Q?eM42XE2J/EtgjTZOfGA1sRqwLkdCnzkEyXqFW8Rfu30UKqO7vEOBoXiPnDVH?=
 =?us-ascii?Q?pekdVpZIroFIcyi45zpnpK2sdb2iWHiz4pIWHgz57Ny/8D5KZJZJjs9gvFlO?=
 =?us-ascii?Q?p3DbfCl5sp769SnZRCbR5KLBUozSN9x90K6+4iAOqHA3SGjd+kGjnLjFieBe?=
 =?us-ascii?Q?uUQG7Qo/Kw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 866bd42a-4f1b-4c3b-7ed6-08dea0a05c34
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:52:53.8309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wLYWeq6NBqidF+ynQFSYB7rfULvDnV7RANfQQ/788g+0YUi0JIgb1FGNP0zOv5OlDxMTeG3mJHWab4ode0P5qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

From: Daniel Wagner <wagi@kernel.org>

Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
constraints provided by the block layer. This allows the virtio drivers
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 drivers/block/virtio_blk.c | 4 +++-
 drivers/scsi/virtio_scsi.c | 5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index b1c9a27fe00f..9d737510454b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -964,7 +964,9 @@ static int init_vq(struct virtio_blk *vblk)
 	unsigned short num_vqs;
 	unsigned short num_poll_vqs;
 	struct virtio_device *vdev = vblk->vdev;
-	struct irq_affinity desc = { 0, };
+	struct irq_affinity desc = {
+		.mask = blk_mq_possible_queue_affinity(),
+	};
 
 	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_MQ,
 				   struct virtio_blk_config, num_queues,
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 5fdaa71f0652..d0b6a137e9b7 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -847,7 +847,10 @@ static int virtscsi_init(struct virtio_device *vdev,
 	u32 num_vqs, num_poll_vqs, num_req_vqs;
 	struct virtqueue_info *vqs_info;
 	struct virtqueue **vqs;
-	struct irq_affinity desc = { .pre_vectors = 2 };
+	struct irq_affinity desc = {
+		.pre_vectors = 2,
+		.mask = blk_mq_possible_queue_affinity(),
+	};
 
 	num_req_vqs = vscsi->num_queues;
 	num_vqs = num_req_vqs + VIRTIO_SCSI_VQ_BASE;
-- 
2.51.0

