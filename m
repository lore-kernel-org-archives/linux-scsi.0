From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [SCSI] st: Remove obsolete scsi_tape.max_pfn
Date: Sun, 15 Nov 2015 12:48:33 +0100
Message-ID: <1447588113-21117-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:59374 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbbKOLsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2015 06:48:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

Its last user was removed 10 years ago, in commit
8b05b773b6030de5 ("[SCSI] convert st to use scsi_execute_async").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/st.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index b6486b5d86811227..8c732c8de0153eb1 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -148,8 +148,6 @@ struct scsi_tape {
 	int tape_type;
 	int long_timeout;	/* timeout for commands known to take long time */
 
-	unsigned long max_pfn;	/* the maximum page number reachable by the HBA */
-
 	/* Mode characteristics */
 	struct st_modedef modes[ST_NBR_MODES];
 	int current_mode;
-- 
1.9.1

