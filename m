From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v2 1/2] virtio_scsi: Add fc_host definitions
Date: Thu, 26 Jan 2017 11:41:08 +0800
Message-ID: <20170126034109.16144-2-famz@redhat.com>
References: <20170126034109.16144-1-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170126034109.16144-1-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, famz@redhat.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, stefanha@redhat.com, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 include/uapi/linux/virtio_scsi.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/virtio_scsi.h b/include/uapi/linux/virtio_scsi.h
index cc18ef8..a26fb31 100644
--- a/include/uapi/linux/virtio_scsi.h
+++ b/include/uapi/linux/virtio_scsi.h
@@ -113,6 +113,11 @@ struct virtio_scsi_config {
 	__u16 max_channel;
 	__u16 max_target;
 	__u32 max_lun;
+	__u8  primary_wwpn[8];
+	__u8  primary_wwnn[8];
+	__u8  secondary_wwpn[8];
+	__u8  secondary_wwnn[8];
+	__u8  primary_active;
 } __attribute__((packed));
 
 /* Feature Bits */
@@ -120,6 +125,7 @@ struct virtio_scsi_config {
 #define VIRTIO_SCSI_F_HOTPLUG                  1
 #define VIRTIO_SCSI_F_CHANGE                   2
 #define VIRTIO_SCSI_F_T10_PI                   3
+#define VIRTIO_SCSI_F_FC_HOST                  4
 
 /* Response codes */
 #define VIRTIO_SCSI_S_OK                       0
-- 
2.9.3
