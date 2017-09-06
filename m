From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 03/11] libsas: remove unused port_gone_completion and DISCE_PORT_GONE
Date: Wed, 6 Sep 2017 17:15:06 +0800
Message-ID: <1504689314-20072-4-git-send-email-yanaijie@huawei.com>
References: <1504689314-20072-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504689314-20072-1-git-send-email-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, chenweilong@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, yanaijie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

No one uses the port_gone_completion in struct asd_sas_port and
DISCE_PORT_GONE in enum disover_event, clean them out.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
---
 include/scsi/libsas.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ccf3b48..99f32b5 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -81,7 +81,6 @@ enum phy_event {
 enum discover_event {
 	DISCE_DISCOVER_DOMAIN   = 0U,
 	DISCE_REVALIDATE_DOMAIN,
-	DISCE_PORT_GONE,
 	DISCE_PROBE,
 	DISCE_SUSPEND,
 	DISCE_RESUME,
@@ -256,8 +255,6 @@ struct sas_discovery {
 /* The port struct is Class:RW, driver:RO */
 struct asd_sas_port {
 /* private: */
-	struct completion port_gone_completion;
-
 	struct sas_discovery disc;
 	struct domain_device *port_dev;
 	spinlock_t dev_list_lock;
-- 
2.5.0
