From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 10/17] smartpqi: minor function reformating
Date: Fri, 26 Aug 2016 11:45:06 -0500
Message-ID: <147222990607.31214.690487833623546424.stgit@brunhilda>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0088.outbound.protection.outlook.com ([104.47.32.88]:13920
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752456AbcHZQps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 12:45:48 -0400
In-Reply-To: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

reformatted pqi_num_elements_free() to match the rest of the driver

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 52c752f..2759c90 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2576,8 +2576,7 @@ static unsigned int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info,
 }
 
 static inline unsigned int pqi_num_elements_free(unsigned int pi,
-						unsigned int ci,
-						unsigned int elements_in_queue)
+	unsigned int ci, unsigned int elements_in_queue)
 {
 	unsigned int num_elements_used;
 

