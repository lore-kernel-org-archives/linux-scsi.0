From: Fam Zheng <famz@redhat.com>
Subject: [PATCH 1/2] virtio_scsi: Add fc_host definitions
Date: Tue, 17 Jan 2017 00:04:29 +0800
Message-ID: <20170116160430.11815-2-famz@redhat.com>
References: <20170116160430.11815-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20170116160430.11815-1-famz@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, virtualization@lists.linux-foundation.org, stefanha@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
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
