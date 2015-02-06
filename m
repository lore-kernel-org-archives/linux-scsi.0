From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 6/8] vhost/scsi: Set VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits
Date: Fri,  6 Feb 2015 05:06:39 +0000
Message-ID: <1423199201-14659-7-git-send-email-nab@daterainc.com>
References: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Sender: kvm-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signal support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits
required for virtio-scsi 1.0 spec layout requirements.

Cc: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index e53959f..b5e2b40 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -173,7 +173,9 @@ enum {
 /* Note: can't set VIRTIO_F_VERSION_1 yet, since that implies ANY_LAYOUT. */
 enum {
 	VHOST_SCSI_FEATURES = VHOST_FEATURES | (1ULL << VIRTIO_SCSI_F_HOTPLUG) |
-					       (1ULL << VIRTIO_SCSI_F_T10_PI)
+					       (1ULL << VIRTIO_SCSI_F_T10_PI) |
+					       (1ULL << VIRTIO_F_ANY_LAYOUT) |
+					       (1ULL << VIRTIO_F_VERSION_1)
 };
 
 #define VHOST_SCSI_MAX_TARGET	256
-- 
1.9.1

