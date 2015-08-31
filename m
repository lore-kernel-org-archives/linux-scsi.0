From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 06/14] lpfc:Make the function
 lpfc_sli4_mbox_completions_pending static in order to comply with function
 prototype
Date: Mon, 31 Aug 2015 16:48:13 -0400
Message-ID: <55e4bd8d.880iZVpjZfJsbEZL%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:34441 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbbHaUs3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:29 -0400
Received: by qkct7 with SMTP id t7so16742430qkc.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:29 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id f9sm9449975qhe.7.2015.08.31.13.48.27
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


From: Nicholas Krause <xerofoify@gmail.com>

This makes the function lpfc_sli4_mbox_completion's definition
static now in order to comply with its prototype being also
declared as static too.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4feb931..95d53c7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6696,7 +6696,7 @@ lpfc_mbox_timeout(unsigned long ptr)
  * This function checks if any mailbox completions are present on the mailbox
  * completion queue.
  **/
-bool
+static bool
 lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba)
 {
 
-- 
1.7.11.7

