From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/lpfc/lpfc_scsi.c: make lpfc_sli_get_scsi_buf() static
Date: Sun, 20 Nov 2005 23:50:47 +0100
Message-ID: <20051120225047.GY16060@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:19216 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S932092AbVKTWus (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Nov 2005 17:50:48 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes the needlessly global function lpfc_sli_get_scsi_buf() 
static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.15-rc1-mm2-full/drivers/scsi/lpfc/lpfc_scsi.c.old	2005-11-20 19:52:28.000000000 +0100
+++ linux-2.6.15-rc1-mm2-full/drivers/scsi/lpfc/lpfc_scsi.c	2005-11-20 19:52:45.000000000 +0100
@@ -136,7 +136,7 @@
 	return psb;
 }
 
-struct  lpfc_scsi_buf*
+static struct lpfc_scsi_buf*
 lpfc_sli_get_scsi_buf(struct lpfc_hba * phba)
 {
 	struct  lpfc_scsi_buf * lpfc_cmd = NULL;

