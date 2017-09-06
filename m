From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 02/11] libsas: remove the numbering for each event enum
Date: Wed, 6 Sep 2017 17:15:05 +0800
Message-ID: <1504689314-20072-3-git-send-email-yanaijie@huawei.com>
References: <1504689314-20072-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504689314-20072-1-git-send-email-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, chenweilong@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, yanaijie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Numbering for each event enum makes no sense. Remove the numbering so
that we don't have to calculate the number by hand every time.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
---
 include/scsi/libsas.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index e536597..ccf3b48 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -62,31 +62,31 @@ enum sas_phy_type {
  */
 enum port_event {
 	PORTE_BYTES_DMAED     = 0U,
-	PORTE_BROADCAST_RCVD  = 1,
-	PORTE_LINK_RESET_ERR  = 2,
-	PORTE_TIMER_EVENT     = 3,
-	PORTE_HARD_RESET      = 4,
-	PORT_NUM_EVENTS       = 5,
+	PORTE_BROADCAST_RCVD,
+	PORTE_LINK_RESET_ERR,
+	PORTE_TIMER_EVENT,
+	PORTE_HARD_RESET,
+	PORT_NUM_EVENTS,
 };
 
 enum phy_event {
 	PHYE_LOSS_OF_SIGNAL   = 0U,
-	PHYE_OOB_DONE         = 1,
-	PHYE_OOB_ERROR        = 2,
-	PHYE_SPINUP_HOLD      = 3, /* hot plug SATA, no COMWAKE sent */
-	PHYE_RESUME_TIMEOUT   = 4,
-	PHY_NUM_EVENTS        = 5,
+	PHYE_OOB_DONE,
+	PHYE_OOB_ERROR,
+	PHYE_SPINUP_HOLD,             /* hot plug SATA, no COMWAKE sent */
+	PHYE_RESUME_TIMEOUT,
+	PHY_NUM_EVENTS,
 };
 
 enum discover_event {
 	DISCE_DISCOVER_DOMAIN   = 0U,
-	DISCE_REVALIDATE_DOMAIN = 1,
-	DISCE_PORT_GONE         = 2,
-	DISCE_PROBE		= 3,
-	DISCE_SUSPEND		= 4,
-	DISCE_RESUME		= 5,
-	DISCE_DESTRUCT		= 6,
-	DISC_NUM_EVENTS		= 7,
+	DISCE_REVALIDATE_DOMAIN,
+	DISCE_PORT_GONE,
+	DISCE_PROBE,
+	DISCE_SUSPEND,
+	DISCE_RESUME,
+	DISCE_DESTRUCT,
+	DISC_NUM_EVENTS,
 };
 
 /* ---------- Expander Devices ---------- */
-- 
2.5.0
