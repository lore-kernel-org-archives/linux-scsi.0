From: Jerry Snitselaar <dev@snitselaar.org>
Subject: [PATCH 1/2] virtio_scsi: blank line after declaration cleanup
Date: Sun, 27 Apr 2014 23:31:06 -0700
Message-ID: <1398666667-24721-1-git-send-email-dev@snitselaar.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Clean up of coding style warnings from checkpatch

Signed-off-by: Jerry Snitselaar <dev@snitselaar.org>
---
 drivers/scsi/virtio_scsi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 16bfd50..fa0b25f 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -498,8 +498,8 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 {
 	struct virtio_scsi_cmd *cmd;
 	int ret;
-
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
+
 	BUG_ON(scsi_sg_count(sc) > shost->sg_tablesize);
 
 	/* TODO: check feature bit and fail if unsupported?  */
@@ -661,6 +661,7 @@ static int virtscsi_target_alloc(struct scsi_target *starget)
 {
 	struct virtio_scsi_target_state *tgt =
 				kmalloc(sizeof(*tgt), GFP_KERNEL);
+
 	if (!tgt)
 		return -ENOMEM;
 
@@ -675,6 +676,7 @@ static int virtscsi_target_alloc(struct scsi_target *starget)
 static void virtscsi_target_destroy(struct scsi_target *starget)
 {
 	struct virtio_scsi_target_state *tgt = starget->hostdata;
+
 	kfree(tgt);
 }
 
@@ -768,6 +770,7 @@ static int virtscsi_cpu_callback(struct notifier_block *nfb,
 				 unsigned long action, void *hcpu)
 {
 	struct virtio_scsi *vscsi = container_of(nfb, struct virtio_scsi, nb);
+
 	switch(action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-- 
2.0.0.rc0
