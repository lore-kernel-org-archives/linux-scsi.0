From: Nik Nyby <nikolas@gnu.org>
Subject: [PATCH] aic7xxx: Fix typo in error message
Date: Mon,  6 Jul 2015 10:59:48 -0400
Message-ID: <1436194788-16185-1-git-send-email-nikolas@gnu.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eggs.gnu.org ([208.118.235.92]:55427 "EHLO eggs.gnu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbbGFPAD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 11:00:03 -0400
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
	(envelope-from <nikolas@gnu.org>)
	id 1ZC7sG-0004c8-6B
	for linux-scsi@vger.kernel.org; Mon, 06 Jul 2015 11:00:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, linux-scsi@vger.kernel.org, trivial@kernel.org
Cc: Nik Nyby <nikolas@gnu.org>

This fixes "referenced" where it is spelled "referrenced".

Signed-off-by: Nik Nyby <nikolas@gnu.org>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index c4829d8..64ab9ea 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -79,7 +79,7 @@ struct ahc_hard_error_entry {
 
 static const struct ahc_hard_error_entry ahc_hard_errors[] = {
 	{ ILLHADDR,	"Illegal Host Access" },
-	{ ILLSADDR,	"Illegal Sequencer Address referrenced" },
+	{ ILLSADDR,	"Illegal Sequencer Address referenced" },
 	{ ILLOPCODE,	"Illegal Opcode in sequencer program" },
 	{ SQPARERR,	"Sequencer Parity Error" },
 	{ DPARERR,	"Data-path Parity Error" },
-- 
1.9.1

