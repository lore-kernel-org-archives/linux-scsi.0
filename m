From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RFC 11/15] scsi: replace **** with a hug
Date: Fri, 30 Nov 2018 11:27:20 -0800
Message-ID: <20181130192737.15053-12-jarkko.sakkinen@linux.intel.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

In order to comply with the CoC, replace **** with a hug.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/scsi/qlogicpti.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.h b/drivers/scsi/qlogicpti.h
index 884ad72ade57..f1785154061c 100644
--- a/drivers/scsi/qlogicpti.h
+++ b/drivers/scsi/qlogicpti.h
@@ -62,7 +62,7 @@
 #define REQUEST_QUEUE_WAKEUP		0x8005
 #define EXECUTION_TIMEOUT_RESET		0x8006
 
-/* Am I fucking pedantic or what? */
+/* Am I hugging pedantic or what? */
 struct Entry_header {
 #ifdef __BIG_ENDIAN
 	u8	entry_cnt;
-- 
2.19.1
