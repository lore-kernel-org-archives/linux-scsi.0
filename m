From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 09/15] smartpqi: minor function reformating
Date: Wed, 31 Aug 2016 14:54:59 -0500
Message-ID: <147267329927.22907.6393881571477959244.stgit@brunhilda>
References: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0058.outbound.protection.outlook.com ([104.47.41.58]:22129
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753708AbcHaTzK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 15:55:10 -0400
In-Reply-To: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

reformatted pqi_num_elements_free() to match the rest of the driver

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ea822b1..bfd2d75 100644
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
 

