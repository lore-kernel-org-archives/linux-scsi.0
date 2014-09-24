From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 20/35] qla2xxx: Unload of qla2xxx driver crashes the machine.
Date: Wed, 24 Sep 2014 03:08:23 -0400
Message-ID: <1411542518-2477-21-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:27335 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbaIXHmp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:42:45 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8846883..6539513 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3190,10 +3190,10 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla2x00_free_device(base_vha);
 
-	scsi_host_put(base_vha->host);
-
 	qla2x00_clear_drv_active(base_vha);
 
+	scsi_host_put(base_vha->host);
+
 	qla2x00_unmap_iobases(ha);
 
 	pci_release_selected_regions(ha->pdev, ha->bars);
-- 
1.7.7

