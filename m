From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] scsi: hisi_sas: make local symbol host_attrs static
Date: Thu, 11 Jan 2018 11:13:58 +0000
Message-ID: <1515669238-125768-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:51544 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S932732AbeAKLHz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jan 2018 06:07:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

Fixes the following sparse warning:

drivers/scsi/hisi_sas/hisi_sas_main.c:1691:25: warning:
 symbol 'host_attrs' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 360ecef..e3e7285 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1688,7 +1688,7 @@ void hisi_sas_kill_tasklets(struct hisi_hba *hisi_hba)
 struct scsi_transport_template *hisi_sas_stt;
 EXPORT_SYMBOL_GPL(hisi_sas_stt);
 
-struct device_attribute *host_attrs[] = {
+static struct device_attribute *host_attrs[] = {
 	&dev_attr_phy_event_threshold,
 	NULL,
 };
