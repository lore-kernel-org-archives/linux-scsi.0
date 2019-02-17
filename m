From: Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: clean obsolete return values of eh_timed_out
Date: Sun, 17 Feb 2019 08:30:27 +0200
Message-ID: <1550385027-6217-1-git-send-email-avri.altman@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Avri Altman <avri.altman@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Those are no longer in use since commit 242f9dcb8ba6
("block: unify request timeout handling").

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 include/scsi/scsi_host.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 4047d68..dbbdfbd 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -300,11 +300,7 @@ struct scsi_host_template {
 	/*
 	 * This is an optional routine that allows the transport to become
 	 * involved when a scsi io timer fires. The return value tells the
-	 * timer routine how to finish the io timeout handling:
-	 * EH_HANDLED:		I fixed the error, please complete the command
-	 * EH_RESET_TIMER:	I need more time, reset the timer and
-	 *			begin counting again
-	 * EH_DONE:		Begin normal error recovery
+	 * timer routine how to finish the io timeout handling.
 	 *
 	 * Status: OPTIONAL
 	 */
-- 
1.9.1
