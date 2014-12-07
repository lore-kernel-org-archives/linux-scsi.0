From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: bfa: bfa_fcpim.c:  Remove unused function
Date: Sun,  7 Dec 2014 18:26:02 +0100
Message-ID: <1417973162-13148-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36604 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaLGRXY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2014 12:23:24 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so2798362wid.15
        for <linux-scsi@vger.kernel.org>; Sun, 07 Dec 2014 09:23:22 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Remove the function bfa_tskim_iodone() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfa_fcpim.c |    9 ---------
 drivers/scsi/bfa/bfa_fcpim.h |    1 -
 2 files changed, 10 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index d7385d1..ceb18ef 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -3477,15 +3477,6 @@ bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim)
 }
 
 /*
- * Notification on completions from related ioim.
- */
-void
-bfa_tskim_iodone(struct bfa_tskim_s *tskim)
-{
-	bfa_wc_down(&tskim->wc);
-}
-
-/*
  * Handle IOC h/w failure notification from itnim.
  */
 void
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index e693af6..8ab548f 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -286,7 +286,6 @@ void	bfa_ioim_tov(struct bfa_ioim_s *ioim);
 
 void	bfa_tskim_attach(struct bfa_fcpim_s *fcpim);
 void	bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
-void	bfa_tskim_iodone(struct bfa_tskim_s *tskim);
 void	bfa_tskim_iocdisable(struct bfa_tskim_s *tskim);
 void	bfa_tskim_cleanup(struct bfa_tskim_s *tskim);
 void	bfa_tskim_res_recfg(struct bfa_s *bfa, u16 num_tskim_fw);
-- 
1.7.10.4

