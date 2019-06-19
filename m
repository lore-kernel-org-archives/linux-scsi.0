From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH 1/1] scsi: virtio_scsi: remove unused 'affinity_hint_set'
Date: Wed, 19 Jun 2019 15:52:19 +0800
Message-ID: <1560930739-25692-1-git-send-email-dongli.zhang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, mst@redhat.com, linux-kernel@vger.kernel.org, stefanha@redhat.com, pbonzini@redhat.com, jejb@linux.ibm.com
List-Id: linux-scsi@vger.kernel.org

The 'affinity_hint_set' is not used any longer since
commit 0d9f0a52c8b9 ("virtio_scsi: use virtio IRQ affinity").

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/scsi/virtio_scsi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 13f1b3b..1705398 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -74,9 +74,6 @@ struct virtio_scsi {
 
 	u32 num_queues;
 
-	/* If the affinity hint is set for virtqueues */
-	bool affinity_hint_set;
-
 	struct hlist_node node;
 
 	/* Protected by event_vq lock */
-- 
2.7.4
