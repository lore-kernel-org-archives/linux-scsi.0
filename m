From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 35/39] virtio_scsi: use blk_mq
Date: Mon, 17 Mar 2014 06:28:08 -0700
Message-ID: <20140317133136.747017596@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0035-virtio_scsi-use-blk_mq.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/virtio_scsi.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 5ec4a73..98469cd 100644
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
