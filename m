From: <rajinikanth.pandurangan@pmcs.com>
Subject: [Patch V2 1/9] [SCSI] aacraid: Fix for logical device name and UID not exposed to the OS
Date: Wed, 10 Jun 2015 18:42:23 -0700
Message-ID: <1433986951-9033-3-git-send-email-rajinikanth.pandurangan@pmcs.com>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:47104 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbbFKBnB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 21:43:01 -0400
In-Reply-To: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
	Driver sends the right size of the response buffer.

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

