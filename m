From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: [PATCH] [SCSI] FlashPoint: Fix non-ANSI function declaration
Date: Mon, 07 Apr 2014 11:51:53 +0900
Message-ID: <1982826.16T5d6eoLo@daeseok-laptop.cloud.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:53134 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaDGCv6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Apr 2014 22:51:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: khalid@gonehiking.org, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


sparse says:
 non-ANSI function declaration of function 'FPT_SccbMgrTableInitAll'

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/scsi/FlashPoint.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index 5c74e4c..867b864 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -2136,7 +2136,7 @@ static unsigned char FPT_SccbMgr_bad_isr(u32 p_port, unsigned char p_card,
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_SccbMgrTableInitAll()
+static void FPT_SccbMgrTableInitAll(void)
 {
 	unsigned char thisCard;
 
-- 
1.7.4.4


