Received: from iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com [3.221.209.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66B82BEC2C;
	Wed,  1 Apr 2026 13:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.221.209.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050623; cv=none; b=cu/9CKUFXSusqtPjiD5syCFSYlji2UpOr/dvDaaDMA8epl0WflKHJaG7SyrSyCSeVtwH2Jmhyy+vqjzGm/s9zlIt4KGZmgfAco12p95KPjDIoRyqQsRKg+aomUwuRdL7Ub/OKkhePs4FsMMfCxEQE2mut3dPU4umkczWg8YWokM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050623; c=relaxed/simple;
	bh=vpq4nB3qwZzEF+4p6P592kZd1o2sPQZYwp9+15SRk2E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cYN7bg9HxIkAfdXS8pBOgTXBAv4flUqqnLM0UD0zzRvkDLUB4rUsdMJ1aZVkSPoYIOZLixn5HVlse/KMIHDsY1HgGejIyX6YH3KMB+Rmti7iIjb8uHTy1Jn9UwfmilKSWj6Av1saDZEDaS1wDyJZdS1edf1SumeS5odzzhHx6z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=WoIx5u0M; arc=none smtp.client-ip=3.221.209.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="WoIx5u0M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1775050622; x=1806586622;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=WXQBh+3u+MJvhba/wycvWbO/cH1qS5tV/vhN0sfRQX4=;
  b=WoIx5u0MMcRat5wNpt0cYGpc/6Us63IUXWkbY+DCCowlnOm8D03I3qkJ
   dAwMw/ooZGrgj6zfBuLOzmfEuJPQQHlOt3sJzZ+TGHgElzp3qCcjboIqK
   InWsrt/0ToWnMQuZqIGqIqo6wJ59drw1yOchjUVU2+KYRjsD6PeL0fl18
   6DiPhCwMUGx/rzFUaGmBgdIXX6ZpcSyBQq7OL9oOyWzRK3eyDAH02sTow
   tRkSj4m8jFg7uQcO0Iyn58tbYj2XsaOO/Kjvnzhu0DIxMRyIhTD8/PoOt
   GA/ZH5fnmnsJrBKmXO+CFS5pEryMJGDVBKzwP7FIBFdzfSD6yjfuZ0xtr
   Q==;
X-CSE-ConnectionGUID: qkzQSM3KQLWzasintYDu2w==
X-CSE-MsgGUID: 75F1YqcgT1yDcLfS194f3A==
X-IronPort-AV: E=Sophos;i="6.23,153,1770595200"; 
   d="scan'208";a="15299613"
Received: from ip-10-4-10-75.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.10.75])
  by internal-iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 13:36:59 +0000
Received: from EX19MTAUEA001.ant.amazon.com [72.21.196.67:18181]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.17.255:2525] with esmtp (Farcaster)
 id 5a89eca9-fb6b-4296-84c0-9f378bbb3c74; Wed, 1 Apr 2026 13:36:59 +0000 (UTC)
X-Farcaster-Flow-ID: 5a89eca9-fb6b-4296-84c0-9f378bbb3c74
Received: from EX19D012UEC001.ant.amazon.com (10.252.135.206) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 1 Apr 2026 13:36:59 +0000
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19D012UEC001.ant.amazon.com (10.252.135.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 1 Apr 2026 13:36:58 +0000
Received: from EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9]) by
 EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9%3]) with mapi id
 15.02.2562.037; Wed, 1 Apr 2026 13:36:58 +0000
From: "Heyne, Maximilian" <mheyne@amazon.de>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "Heyne, Maximilian" <mheyne@amazon.de>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, "Keith
 Busch" <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Hector Martin
	<marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>, Alyssa Rosenzweig
	<alyssa@rosenzweig.io>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van Assche
	<bvanassche@acm.org>, Sasha Levin <sashal@kernel.org>, Peter Wang
	<peter.wang@mediatek.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Seunghwan Baek <sh8267.baek@samsung.com>, Bean Huo <beanhuo@micron.com>,
	Thomas Yen <thomasyen@google.com>, Brian Kao <powenkao@google.com>, "Seunghui
 Lee" <sh043.lee@samsung.com>, Sanjeev Yadav <sanjeev.y@mediatek.com>, "Wonkon
 Kim" <wkon.kim@samsung.com>, Hannes Reinecke <hare@suse.de>, Ming Lei
	<ming.lei@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "asahi@lists.linux.dev"
	<asahi@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: [PATCH 6.1.y 2/8] blk-mq: move the call to blk_put_queue out of
 blk_mq_destroy_queue
Thread-Topic: [PATCH 6.1.y 2/8] blk-mq: move the call to blk_put_queue out of
 blk_mq_destroy_queue
Thread-Index: AQHcwdycwz+7VPd2vkmdKVAi3XDU9Q==
Date: Wed, 1 Apr 2026 13:36:58 +0000
Message-ID: <20260401-plank-yogi-fbc6b91f@mheyne-amazon>
References: <20260401-defer-gleam-5226cb65@mheyne-amazon>
In-Reply-To: <20260401-defer-gleam-5226cb65@mheyne-amazon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2b3f056f72e56fa07df69b4705e0b46a6c08e77c ]

The fact that blk_mq_destroy_queue also drops a queue reference leads
to various places having to grab an extra reference.  Move the call to
blk_put_queue into the callers to allow removing the extra references.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/20221018135720.670094-2-hch@lst.de
[axboe: fix fabrics_q vs admin_q conflict in nvme core.c]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 03b3bcd319b3 ("nvme: fix admin request_queue lifetime")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
---
 block/blk-mq.c            |  4 +---
 block/bsg-lib.c           |  2 ++
 drivers/nvme/host/apple.c |  1 +
 drivers/nvme/host/core.c  | 10 ++++++++--
 drivers/nvme/host/pci.c   |  1 +
 drivers/scsi/scsi_sysfs.c |  1 +
 drivers/ufs/core/ufshcd.c |  2 ++
 7 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a9697541d67f9..8b9e5ca398242 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4194,9 +4194,6 @@ void blk_mq_destroy_queue(struct request_queue *q)
 	blk_sync_queue(q);
 	blk_mq_cancel_work_sync(q);
 	blk_mq_exit_queue(q);
-
-	/* @q is and will stay empty, shutdown and put */
-	blk_put_queue(q);
 }
 EXPORT_SYMBOL(blk_mq_destroy_queue);
 =

@@ -4213,6 +4210,7 @@ struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag=
_set *set, void *queuedata,
 	disk =3D __alloc_disk_node(q, set->numa_node, lkclass);
 	if (!disk) {
 		blk_mq_destroy_queue(q);
+		blk_put_queue(q);
 		return ERR_PTR(-ENOMEM);
 	}
 	set_bit(GD_OWNS_QUEUE, &disk->state);
diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index d6f5dcdce748c..435c32373cd68 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -325,6 +325,7 @@ void bsg_remove_queue(struct request_queue *q)
 =

 		bsg_unregister_queue(bset->bd);
 		blk_mq_destroy_queue(q);
+		blk_put_queue(q);
 		blk_mq_free_tag_set(&bset->tag_set);
 		kfree(bset);
 	}
@@ -400,6 +401,7 @@ struct request_queue *bsg_setup_queue(struct device *de=
v, const char *name,
 	return q;
 out_cleanup_queue:
 	blk_mq_destroy_queue(q);
+	blk_put_queue(q);
 out_queue:
 	blk_mq_free_tag_set(set);
 out_tag_set:
diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 262d2b60ac6dd..c5fc293c22123 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1510,6 +1510,7 @@ static int apple_nvme_probe(struct platform_device *p=
dev)
 	if (!blk_get_queue(anv->ctrl.admin_q)) {
 		nvme_start_admin_queue(&anv->ctrl);
 		blk_mq_destroy_queue(anv->ctrl.admin_q);
+		blk_put_queue(anv->ctrl.admin_q);
 		anv->ctrl.admin_q =3D NULL;
 		ret =3D -ENODEV;
 		goto put_dev;
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 938af571dc13e..044e1a9c099b3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5031,6 +5031,7 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, =
struct blk_mq_tag_set *set,
 =

 out_cleanup_admin_q:
 	blk_mq_destroy_queue(ctrl->admin_q);
+	blk_put_queue(ctrl->admin_q);
 out_free_tagset:
 	blk_mq_free_tag_set(set);
 	ctrl->admin_q =3D NULL;
@@ -5042,8 +5043,11 @@ EXPORT_SYMBOL_GPL(nvme_alloc_admin_tag_set);
 void nvme_remove_admin_tag_set(struct nvme_ctrl *ctrl)
 {
 	blk_mq_destroy_queue(ctrl->admin_q);
-	if (ctrl->ops->flags & NVME_F_FABRICS)
+	blk_put_queue(ctrl->admin_q);
+	if (ctrl->ops->flags & NVME_F_FABRICS) {
 		blk_mq_destroy_queue(ctrl->fabrics_q);
+		blk_put_queue(ctrl->fabrics_q);
+	}
 	blk_mq_free_tag_set(ctrl->admin_tagset);
 }
 EXPORT_SYMBOL_GPL(nvme_remove_admin_tag_set);
@@ -5099,8 +5103,10 @@ EXPORT_SYMBOL_GPL(nvme_alloc_io_tag_set);
 =

 void nvme_remove_io_tag_set(struct nvme_ctrl *ctrl)
 {
-	if (ctrl->ops->flags & NVME_F_FABRICS)
+	if (ctrl->ops->flags & NVME_F_FABRICS) {
 		blk_mq_destroy_queue(ctrl->connect_q);
+		blk_put_queue(ctrl->connect_q);
+	}
 	blk_mq_free_tag_set(ctrl->tagset);
 }
 EXPORT_SYMBOL_GPL(nvme_remove_io_tag_set);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 518f8c5012bdf..727585f580362 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1782,6 +1782,7 @@ static void nvme_dev_remove_admin(struct nvme_dev *de=
v)
 		 */
 		nvme_start_admin_queue(&dev->ctrl);
 		blk_mq_destroy_queue(dev->ctrl.admin_q);
+		blk_put_queue(dev->ctrl.admin_q);
 		blk_mq_free_tag_set(&dev->admin_tagset);
 	}
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 456b92c3a7811..af81b2ba0c9b3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1486,6 +1486,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	mutex_unlock(&sdev->state_mutex);
 =

 	blk_mq_destroy_queue(sdev->request_queue);
+	blk_put_queue(sdev->request_queue);
 	kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 	cancel_work_sync(&sdev->requeue_work);
 =

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f72ba0b206437..a39ffc62d88a1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9651,6 +9651,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufshpb_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
 	blk_mq_destroy_queue(hba->tmf_queue);
+	blk_put_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
@@ -9953,6 +9954,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mm=
io_base, unsigned int irq)
 =

 free_tmf_queue:
 	blk_mq_destroy_queue(hba->tmf_queue);
+	blk_put_queue(hba->tmf_queue);
 free_tmf_tag_set:
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
 out_remove_scsi_host:
-- =

2.50.1




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

