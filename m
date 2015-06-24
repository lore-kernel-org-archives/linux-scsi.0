From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [Patch V2 1/9] [SCSI] aacraid: Fix for logical device name and
 UID not exposed to the OS
Date: Wed, 24 Jun 2015 05:40:18 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AB7F787FC@BBYEXM01.pmc-sierra.internal>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1433986951-9033-3-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60507 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbbFXFkX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jun 2015 01:40:23 -0400
In-Reply-To: <1433986951-9033-3-git-send-email-rajinikanth.pandurangan@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>

Reviewed-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>


-----Original Message-----
From: Rajinikanth Pandurangan 
Sent: Thursday, June 11, 2015 7:12 AM
To: jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Mahesh Rajashekhara; Rich Bono; Achim Leubner; Murthy Bhat; Rajinikanth Pandurangan
Subject: [Patch V2 1/9] [SCSI] aacraid: Fix for logical device name and UID not exposed to the OS

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
	Driver sends the right size of the response buffer.

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/aachba.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c index 9b3dd6e..fe59b00 100644
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

