From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 15/15] virtio_scsi: use blk_mq
Date: Wed, 05 Feb 2014 04:41:33 -0800
Message-ID: <20140205124154.942594130@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53244 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaBEMl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:56 -0500
Content-Disposition: inline; filename=0015-virtio_scsi-use-blk_mq.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/virtio_scsi.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index d9a6074..59b030c 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -680,6 +680,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.target_alloc = virtscsi_target_alloc,
 	.target_destroy = virtscsi_target_destroy,
+	.use_blk_mq = true,
 };
 
 static struct scsi_host_template virtscsi_host_template_multi = {
@@ -697,6 +698,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.target_alloc = virtscsi_target_alloc,
 	.target_destroy = virtscsi_target_destroy,
+	.use_blk_mq = true,
 };
 
 #define virtscsi_config_get(vdev, fld) \
-- 
1.7.10.4


