From: Murthy Bhat <Murthy.Bhat@pmcs.com>
Subject: RE: [PATCH V6 01/10] [SCSI] aacraid: Fix for logical device name
 and UID not exposed to the OS
Date: Tue, 25 Aug 2015 07:06:11 +0000
Message-ID: <13272BDD18A5F44CB23C497D29A37252DAB0F78E@BBYEXM02.pmc-sierra.internal>
References: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1439272701-15344-2-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <E4E5FF3C42893646A5934D219F9C8A514CA3A4C1@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:60666 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbbHYHGN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2015 03:06:13 -0400
In-Reply-To: <E4E5FF3C42893646A5934D219F9C8A514CA3A4C1@BBYEXM02.pmc-sierra.internal>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Tomas Henzl <thenzl@redhat.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>

Reviewed-by: Murthy Bhat <Murthy.Bhat@pmcs.com>


-----Original Message-----
From: Karthikeya Sunkesula 
Sent: Tuesday, August 25, 2015 11:56 AM
To: Mahesh Rajashekhara; Tomas Henzl; JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Murthy Bhat
Subject: RE: [PATCH V6 01/10] [SCSI] aacraid: Fix for logical device name and UID not exposed to the OS

Reviewed-by: Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>

-----Original Message-----
From: Mahesh Rajashekhara 
Sent: Tuesday, August 11, 2015 11:28 AM
To: Tomas Henzl; JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Mahesh Rajashekhara
Subject: [PATCH V6 01/10] [SCSI] aacraid: Fix for logical device name and UID not exposed to the OS

Description:
	Driver sends the right size of the response buffer.

Changes from V2:
None

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
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

