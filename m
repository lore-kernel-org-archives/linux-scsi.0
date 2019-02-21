From: Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH v2 2/2] scsi: whitespace cleanup in scsi_scan.c
Date: Thu, 21 Feb 2019 10:18:01 +0100
Message-ID: <b6078c66923536b3086a8b9ca528ac0711ae8139.1550740533.git.bblock@linux.ibm.com>
References: <20190220184847.24640-1-bblock@linux.ibm.com> <c5bd5a82d1250471822cbf5891ea1866166cd9e6.1550740533.git.bblock@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c5bd5a82d1250471822cbf5891ea1866166cd9e6.1550740533.git.bblock@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Benjamin Block <bblock@linux.ibm.com>, Steffen Maier <maier@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

Noticed during editing that vim would remove some trailing spaces.

Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/scsi/scsi_scan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 53380e07b40e..7e1a6c3dd42c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -108,7 +108,7 @@ MODULE_PARM_DESC(scan, "sync, async, manual, or none. "
 static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ + 18;
 
 module_param_named(inq_timeout, scsi_inq_timeout, uint, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(inq_timeout, 
+MODULE_PARM_DESC(inq_timeout,
 		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
 		 " Default is 20. Some devices may need more; most need less.");
 
@@ -604,7 +604,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			 * not-ready to ready transition [asc/ascq=0x28/0x0]
 			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
 			 * INQUIRY should not yield UNIT_ATTENTION
-			 * but many buggy devices do so anyway. 
+			 * but many buggy devices do so anyway.
 			 */
 			if (driver_byte(result) == DRIVER_SENSE &&
 			    scsi_sense_valid(&sshdr)) {
@@ -850,7 +850,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * Don't set the device offline here; rather let the upper
 	 * level drivers eval the PQ to decide whether they should
 	 * attach. So remove ((inq_result[0] >> 5) & 7) == 1 check.
-	 */ 
+	 */
 
 	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
 	sdev->lockable = sdev->removable;
@@ -994,7 +994,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 }
 
 #ifdef CONFIG_SCSI_LOGGING
-/** 
+/**
  * scsi_inq_str - print INQUIRY data from min to max index, strip trailing whitespace
  * @buf:   Output buffer with at least end-first+1 bytes of space
  * @inq:   Inquiry buffer (input)
@@ -1495,7 +1495,7 @@ EXPORT_SYMBOL(__scsi_add_device);
 int scsi_add_device(struct Scsi_Host *host, uint channel,
 		    uint target, u64 lun)
 {
-	struct scsi_device *sdev = 
+	struct scsi_device *sdev =
 		__scsi_add_device(host, channel, target, lun, NULL);
 	if (IS_ERR(sdev))
 		return PTR_ERR(sdev);
-- 
2.20.1
