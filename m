From: Fam Zheng <famz@redhat.com>
Subject: [PATCH] virtio-scsi: Change sense buffer size to 252
Date: Thu,  6 Mar 2014 16:47:40 +0800
Message-ID: <1394095660-15075-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

According to SPC-4, section 4.5.2.1, 252 is the limit of sense data. So
increase the value.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 include/linux/virtio_scsi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index 4195b97..a437f7f 100644
--- a/include/linux/virtio_scsi.h
+++ b/include/linux/virtio_scsi.h
@@ -28,7 +28,7 @@
 #define _LINUX_VIRTIO_SCSI_H
 
 #define VIRTIO_SCSI_CDB_SIZE   32
-#define VIRTIO_SCSI_SENSE_SIZE 96
+#define VIRTIO_SCSI_SENSE_SIZE 252
 
 /* SCSI command request, followed by data-out */
 struct virtio_scsi_cmd_req {
-- 
1.9.0
