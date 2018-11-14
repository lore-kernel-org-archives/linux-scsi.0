From: John Garry <john.garry@huawei.com>
Subject: [PATCH 5/5] scsi: libsas: Remove pcidev reference
Date: Wed, 14 Nov 2018 21:47:49 +0800
Message-ID: <1542203269-174932-6-git-send-email-john.garry@huawei.com>
References: <1542203269-174932-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542203269-174932-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.com, yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, joe@perches.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Not all host drivers are PCI drivers - like hisi_sas, which supports a
platform driver - so remove reference to "pcidev".

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_discover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index ba468ce..b23ecb1 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -186,7 +186,7 @@ int sas_notify_lldd_dev_found(struct domain_device *dev)
 
 	res = i->dft->lldd_dev_found(dev);
 	if (res) {
-		pr_warn("sas: driver on pcidev %s cannot handle "
+		pr_warn("sas: driver on host %s cannot handle "
 			"device %llx, error:%d\n",
 			dev_name(sas_ha->dev),
 			SAS_ADDR(dev->sas_addr), res);
-- 
1.9.1
