From: <rajinikanth.pandurangan@pmcs.com>
Subject: [PATCH V3 01/10] [SCSI] aacraid: Fix for logical device name and UID  not exposed to the OS
Date: Tue, 7 Jul 2015 16:16:15 -0700
Message-ID: <1436310984-4519-2-git-send-email-rajinikanth.pandurangan@pmcs.com>
References: <1436310984-4519-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:49998 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614AbbGGXRM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2015 19:17:12 -0400
In-Reply-To: <1436310984-4519-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
        Driver sends the right size of the response buffer.

Changes from V2:
None

V2:
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/aachba.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 9b3dd6e..fe59b00 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -570,7 +570,7 @@ static int aac_get_container_name(struct scsi_cmnd * scsicmd)
 
 	status = aac_fib_send(ContainerCommand,
 		  cmd_fibcontext,
-		  sizeof (struct aac_get_name),
+		  sizeof(struct aac_get_name_resp),
 		  FsaNormal,
 		  0, 1,
 		  (fib_callback)get_container_name_callback,
@@ -1052,7 +1052,7 @@ static int aac_get_container_serial(struct scsi_cmnd * scsicmd)
 
 	status = aac_fib_send(ContainerCommand,
 		  cmd_fibcontext,
-		  sizeof (struct aac_get_serial),
+		  sizeof(struct aac_get_serial_resp),
 		  FsaNormal,
 		  0, 1,
 		  (fib_callback) get_container_serial_callback,
-- 
1.9.3

