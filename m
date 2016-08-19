From: Zhou Jie <zhoujie2011@cn.fujitsu.com>
Subject: [PATCH] Remove the unnecessary semicolons
Date: Fri, 19 Aug 2016 10:03:09 +0800
Message-ID: <1471572189-21257-1-git-send-email-zhoujie2011@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58490 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753665AbcHSCHF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2016 22:07:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mst@redhat.com, rusty@rustcorp.com.au, pbonzini@redhat.com, stefanha@linux.vnet.ibm.com, Zhou Jie <zhoujie2011@cn.fujitsu.com>, Chao Fan <fanc.fnst@cn.fujitsu.com>

At the end of funcions, semicolons are unnecessary. So drop them.

Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
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
2.5.5



