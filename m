From: Chao Fan <vidos.fan@gmail.com>
Subject: [PATCH] Remove the unnecessary semicolons
Date: Thu, 18 Aug 2016 23:04:34 +0800
Message-ID: <1471532674-7263-1-git-send-email-vidos.fan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35701 "EHLO
        mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753454AbcHSHsI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2016 03:48:08 -0400
Received: by mail-pa0-f66.google.com with SMTP id cf3so3042758pad.2
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 00:48:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vidos Fan <vidos.fan@gmail.com>

From: Vidos Fan <vidos.fan@gmail.com>

At the end of funcions, semicolons are unnecessary. So drop them.

Signed-off-by: Vidos Fan <vidos.fan@gmail.com>
---
 drivers/scsi/virtio_scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 7dbbb29..9632a0c 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -241,7 +241,7 @@ static void virtscsi_req_done(struct virtqueue *vq)
 	struct virtio_scsi_vq *req_vq = &vscsi->req_vqs[index];
 
 	virtscsi_vq_done(vscsi, req_vq, virtscsi_complete_cmd);
-};
+}
 
 static void virtscsi_poll_requests(struct virtio_scsi *vscsi)
 {
@@ -267,7 +267,7 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 	struct virtio_scsi *vscsi = shost_priv(sh);
 
 	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
-};
+}
 
 static void virtscsi_handle_event(struct work_struct *work);
 
@@ -413,7 +413,7 @@ static void virtscsi_event_done(struct virtqueue *vq)
 	struct virtio_scsi *vscsi = shost_priv(sh);
 
 	virtscsi_vq_done(vscsi, &vscsi->event_vq, virtscsi_complete_event);
-};
+}
 
 /**
  * virtscsi_add_cmd - add a virtio_scsi_cmd to a virtqueue
-- 
2.7.4

