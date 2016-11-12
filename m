From: Colin King <colin.king@canonical.com>
Subject: [PATCH] isci: fix typo in deg_dbg message
Date: Sat, 12 Nov 2016 18:30:26 +0000
Message-ID: <20161112183026.9626-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to typo "repsonse" to "response" in dev_dbg message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/isci/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index b709d2b..47f66e9 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2473,7 +2473,7 @@ static void isci_request_process_response_iu(
 		"%s: resp_iu = %p "
 		"resp_iu->status = 0x%x,\nresp_iu->datapres = %d "
 		"resp_iu->response_data_len = %x, "
-		"resp_iu->sense_data_len = %x\nrepsonse data: ",
+		"resp_iu->sense_data_len = %x\nresponse data: ",
 		__func__,
 		resp_iu,
 		resp_iu->status,
-- 
2.10.2
