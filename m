From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/osst.c: remove unused code
Date: Tue, 22 Mar 2005 22:59:48 +0100
Message-ID: <20050322215948.GP1948@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59660 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S262120AbVCVV7x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 16:59:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org
Cc: osst-users@lists.sourceforge.net, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Thanks to both the Coverity checker and GNU gcc, it was found that this 
variable is completely unused.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.12-rc1-mm1-full/drivers/scsi/osst.c.old	2005-03-22 21:04:36.000000000 +0100
+++ linux-2.6.12-rc1-mm1-full/drivers/scsi/osst.c	2005-03-22 22:09:32.000000000 +0100
@@ -4770,9 +4770,6 @@ static int os_scsi_tape_close(struct ino
 {
 	int		      result = 0;
 	struct osst_tape    * STp    = filp->private_data;
-	struct scsi_request * SRpnt  = NULL;
-
-	if (SRpnt) scsi_release_request(SRpnt);
 
 	if (STp->door_locked == ST_LOCKED_AUTO)
 		do_door_lock(STp, 0);

