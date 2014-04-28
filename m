From: Jerry Snitselaar <dev@snitselaar.org>
Subject: [PATCH 2/2] virtio_scsi: space required before open parenthesis
Date: Sun, 27 Apr 2014 23:31:07 -0700
Message-ID: <1398666667-24721-2-git-send-email-dev@snitselaar.org>
References: <1398666667-24721-1-git-send-email-dev@snitselaar.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56342 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaD1GbT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2014 02:31:19 -0400
Received: by mail-pd0-f176.google.com with SMTP id y10so384272pdj.21
        for <linux-scsi@vger.kernel.org>; Sun, 27 Apr 2014 23:31:19 -0700 (PDT)
In-Reply-To: <1398666667-24721-1-git-send-email-dev@snitselaar.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Fix coding style warnings from checkpatch

Signed-off-by: Jerry Snitselaar <dev@snitselaar.org>
---
 drivers/scsi/virtio_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 9f2fccc..9248a1e 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -723,7 +723,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	do { \
 		typeof(((struct virtio_scsi_config *)0)->fld) __val = (val); \
 		virtio_cwrite(vdev, struct virtio_scsi_config, fld, &__val); \
-	} while(0)
+	} while (0)
 
 static void __virtscsi_set_affinity(struct virtio_scsi *vscsi, bool affinity)
 {
@@ -771,7 +771,7 @@ static int virtscsi_cpu_callback(struct notifier_block *nfb,
 {
 	struct virtio_scsi *vscsi = container_of(nfb, struct virtio_scsi, nb);
 
-	switch(action) {
+	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 	case CPU_DEAD:
-- 
2.0.0.rc0

