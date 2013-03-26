From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH] scsi/lpfc: add return code FAST_IO_FAIL in lpfc_abort_handler() comments
Date: Tue, 26 Mar 2013 15:31:00 +0800
Message-ID: <1364283060-30425-1-git-send-email-renmx@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@emulex.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 98af07c..cc6fc83 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4426,6 +4426,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
  * Return code :
  *   0x2003 - Error
  *   0x2002 - Success
+ *   0x2009 - fast_io_fail_tmo fired
  **/
 static int
 lpfc_abort_handler(struct scsi_cmnd *cmnd)
-- 
1.7.1
