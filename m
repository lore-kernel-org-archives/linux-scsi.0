From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/lpfc/lpfc_scsi.c: make lpfc_get_scsi_buf() static
Date: Sat, 14 Jan 2006 03:09:53 +0100
Message-ID: <20060114020953.GD29663@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:22034 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1423272AbWANCJx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 21:09:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@SteelEye.com, James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes the needlessly global function lpfc_sli_get_scsi_buf()
static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: James Smart <James.Smart@Emulex.Com>

---

This patch was already sent on:
- 6 Jan 2006

--- linux-2.6.15-mm1-full/drivers/scsi/lpfc/lpfc_scsi.c.old	2006-01-06 19:50:38.000000000 +0100
+++ linux-2.6.15-mm1-full/drivers/scsi/lpfc/lpfc_scsi.c	2006-01-06 19:50:46.000000000 +0100
@@ -150,7 +150,7 @@
 	return psb;
 }
 
-struct  lpfc_scsi_buf*
+static struct lpfc_scsi_buf*
 lpfc_get_scsi_buf(struct lpfc_hba * phba)
 {
 	struct  lpfc_scsi_buf * lpfc_cmd = NULL;

